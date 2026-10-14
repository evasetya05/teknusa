from datetime import date, timedelta

from django.contrib.auth import get_user_model
from django.test import SimpleTestCase, TestCase
from django.urls import reverse
from django.utils import timezone

from entity.models import Entity
from kanban.models import Board, Column, Task
from ledger.models import Account, JournalEntry, JournalItem

from agent.briefing import build_briefings, is_briefing_admin
from agent.collectors.finance import (
    collect_finance,
    month_bounds,
    previous_month_start,
)
from agent.collectors.kanban import collect_board
from agent.rules import (
    CRITICAL,
    Alert,
    finance_alerts,
    kanban_alerts,
    overall_status,
)

TODAY = date(2026, 10, 14)


def _finance_metrics(**overrides):
    base = {
        "month": "2026-10",
        "today": TODAY,
        "days_left_in_month": 17,
        "current": {"revenue": 10_000_000, "expenses": 4_000_000, "net_profit": 6_000_000},
        "previous": {"revenue": 10_000_000, "expenses": 4_000_000, "net_profit": 6_000_000},
        "cash": 5_000_000,
        "open_period": "2026-10",
        "unposted": {"count": 0, "oldest_date": None},
        "unbalanced": 0,
        "expense_changes": [],
    }
    base.update(overrides)
    return base


class DateHelperTests(SimpleTestCase):
    def test_month_bounds(self):
        self.assertEqual(month_bounds(date(2026, 10, 14)), (date(2026, 10, 1), date(2026, 11, 1)))
        self.assertEqual(month_bounds(date(2026, 12, 5)), (date(2026, 12, 1), date(2027, 1, 1)))

    def test_previous_month_start(self):
        self.assertEqual(previous_month_start(date(2026, 1, 20)), date(2025, 12, 1))
        self.assertEqual(previous_month_start(date(2026, 10, 14)), date(2026, 9, 1))


class FinanceRuleTests(SimpleTestCase):
    def codes(self, **overrides):
        return {a.code for a in finance_alerts(_finance_metrics(**overrides))}

    def test_healthy_has_no_alerts(self):
        self.assertEqual(self.codes(), set())

    def test_unbalanced_and_negative_cash_are_critical(self):
        alerts = finance_alerts(_finance_metrics(unbalanced=2, cash=-1))
        self.assertEqual({a.code for a in alerts}, {"unbalanced", "negative_cash"})
        self.assertTrue(all(a.severity == CRITICAL for a in alerts))
        self.assertEqual(overall_status(alerts), "red")

    def test_loss(self):
        cur = {"revenue": 1, "expenses": 5_000_000, "net_profit": -4_999_999}
        self.assertIn("loss", self.codes(current=cur))

    def test_profit_drop(self):
        cur = {"revenue": 1, "expenses": 1, "net_profit": 3_000_000}
        self.assertIn("profit_drop", self.codes(current=cur))

    def test_closing_rules(self):
        self.assertIn("closing_overdue", self.codes(open_period="2026-09"))
        self.assertIn(
            "closing_soon",
            self.codes(unposted={"count": 3, "oldest_date": TODAY}, days_left_in_month=2),
        )
        self.assertIn("unposted", self.codes(unposted={"count": 3, "oldest_date": TODAY}))

    def test_expense_jump_respects_thresholds(self):
        big = {"account": "Fuel", "current": 5_000_000, "previous": 1_000_000, "delta": 4_000_000}
        small = {"account": "Pens", "current": 200_000, "previous": 100_000, "delta": 100_000}
        alerts = finance_alerts(_finance_metrics(expense_changes=[big, small]))
        messages = [a.message for a in alerts if a.code == "expense_jump"]
        self.assertEqual(len(messages), 1)
        self.assertIn("Fuel", messages[0])


class KanbanRuleTests(SimpleTestCase):
    def metrics(self, **kw):
        base = {"overdue": 0, "urgent_overdue": 0, "due_soon": 0, "unassigned": 0, "stalled": 0}
        base.update(kw)
        return base

    def test_overdue_severity(self):
        warn = kanban_alerts(self.metrics(overdue=1))
        self.assertEqual(warn[0].severity, "warning")
        crit = kanban_alerts(self.metrics(overdue=1, urgent_overdue=1))
        self.assertEqual(crit[0].severity, CRITICAL)

    def test_green_when_nothing_to_report(self):
        self.assertEqual(overall_status(kanban_alerts(self.metrics())), "green")

    def test_overall_status_yellow(self):
        self.assertEqual(overall_status([Alert("warning", "x", "m")]), "yellow")


class FinanceCollectorTests(TestCase):
    def setUp(self):
        self.entity = Entity.objects.create(name="Alpha", code="ALPHA")
        self.other = Entity.objects.create(name="Beta", code="BETA")

    def _account(self, entity, name, a_type):
        return Account.objects.create(
            entity=entity, account_name=name, account_type=a_type, coa=name, balance_type="DEBIT"
        )

    def _journal(self, entity, day, lines, posted=False):
        je = JournalEntry.objects.create(
            entity=entity, date=day, description="t", period=day.strftime("%Y-%m"), is_posted=posted
        )
        for account, debit, credit in lines:
            JournalItem.objects.create(journal_entry=je, account=account, debit=debit, credit=credit)
        return je

    def test_totals_cash_and_isolation(self):
        cash = self._account(self.entity, "Kas Besar", "ASSET")
        income = self._account(self.entity, "Sales", "INCOME")
        expense = self._account(self.entity, "Fuel", "EXPENSES")
        self._journal(self.entity, date(2026, 10, 3), [(cash, 1000, 0), (income, 0, 1000)])
        self._journal(self.entity, date(2026, 10, 5), [(expense, 300, 0), (cash, 0, 300)])
        # Other entity data must never leak in.
        o_cash = self._account(self.other, "Kas", "ASSET")
        o_inc = self._account(self.other, "Sales", "INCOME")
        self._journal(self.other, date(2026, 10, 4), [(o_cash, 9999, 0), (o_inc, 0, 9999)])

        m = collect_finance(self.entity, today=TODAY)
        self.assertEqual(m["current"], {"revenue": 1000, "expenses": 300, "net_profit": 700})
        self.assertEqual(m["cash"], 700)
        self.assertEqual(m["unposted"]["count"], 2)
        self.assertEqual(m["unbalanced"], 0)
        self.assertEqual(m["days_left_in_month"], 17)

    def test_unbalanced_detected(self):
        cash = self._account(self.entity, "Cash", "ASSET")
        income = self._account(self.entity, "Sales", "INCOME")
        self._journal(self.entity, date(2026, 10, 3), [(cash, 1000, 0), (income, 0, 900)])
        self.assertEqual(collect_finance(self.entity, today=TODAY)["unbalanced"], 1)


class KanbanCollectorTests(TestCase):
    def setUp(self):
        self.entity = Entity.objects.create(name="Alpha", code="ALPHA")
        self.board = Board.objects.create(name="Web", entity=self.entity)
        self.todo = Column.objects.create(board=self.board, name="To Do", position=1)
        self.done = Column.objects.create(board=self.board, name="Done", position=2)

    def test_counts_and_top_tasks(self):
        today = timezone.localdate()
        Task.objects.create(column=self.todo, title="Late urgent", priority="urgent",
                            due_date=today - timedelta(days=2))
        Task.objects.create(column=self.todo, title="Soon", priority="medium",
                            due_date=today + timedelta(days=1))
        Task.objects.create(column=self.todo, title="Far", priority="low",
                            due_date=today + timedelta(days=30))
        Task.objects.create(column=self.done, title="Finished", completed=True)

        m = collect_board(self.board, today=today)
        self.assertEqual(m["open_total"], 3)
        self.assertEqual(m["overdue"], 1)
        self.assertEqual(m["urgent_overdue"], 1)
        self.assertEqual(m["due_soon"], 1)
        self.assertEqual(m["unassigned"], 3)
        self.assertEqual(m["completed_week"], 1)
        self.assertEqual(m["top_tasks"][0]["title"], "Late urgent")
        self.assertEqual(m["columns"][0], {"name": "To Do", "open": 3})


class BriefingAccessTests(TestCase):
    def setUp(self):
        User = get_user_model()
        self.entity = Entity.objects.create(name="Alpha", code="ALPHA")
        self.admin = User.objects.create_user("boss", password="x", is_staff=True)
        self.user = User.objects.create_user("worker", password="x")

    def test_is_briefing_admin(self):
        self.assertTrue(is_briefing_admin(self.admin))
        self.assertFalse(is_briefing_admin(self.user))

    def test_non_admin_forbidden(self):
        self.client.force_login(self.user)
        self.assertEqual(self.client.get(reverse("agent:briefing")).status_code, 403)

    def test_admin_can_view(self):
        self.client.force_login(self.admin)
        response = self.client.get(reverse("agent:briefing"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Alpha")

    def test_entity_scoping(self):
        other = Entity.objects.create(name="Beta", code="BETA")
        Board.objects.create(name="Alpha board", entity=self.entity)
        Board.objects.create(name="Beta board", entity=other)
        data = build_briefings(str(self.entity.id))
        self.assertEqual([b["entity"].name for b in data["finance"]], ["Alpha"])
        self.assertEqual([b["metrics"]["board"] for b in data["kanban"]], ["Alpha board"])

    def test_invalid_session_entity_returns_nothing(self):
        data = build_briefings("not-a-uuid")
        self.assertEqual(data, {"finance": [], "kanban": []})
