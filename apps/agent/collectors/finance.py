"""Finance metrics collector. Pure data gathering: no alerts, no text."""
import calendar
from datetime import date

from django.db.models import F, Q, Sum
from django.db.models.functions import Coalesce
from django.utils import timezone

from ledger.models import ClosingPeriod, JournalEntry, JournalItem

CASH_NAME_HINTS = ("cash", "kas", "bank")
EXPENSE_TYPES = ("EXPENSES", "COGS")


def month_bounds(day):
    """Return (first day of month, first day of next month)."""
    start = day.replace(day=1)
    if start.month == 12:
        nxt = date(start.year + 1, 1, 1)
    else:
        nxt = date(start.year, start.month + 1, 1)
    return start, nxt


def previous_month_start(day):
    start, _ = month_bounds(day)
    if start.month == 1:
        return date(start.year - 1, 12, 1)
    return date(start.year, start.month - 1, 1)


def _items(entity):
    return JournalItem.objects.filter(journal_entry__entity=entity)


def _sum(qs):
    agg = qs.aggregate(d=Sum("debit"), c=Sum("credit"))
    return (agg["d"] or 0), (agg["c"] or 0)


def period_totals(entity, start, end):
    """Revenue / expenses / net profit for journals dated in [start, end)."""
    scoped = _items(entity).filter(
        journal_entry__date__gte=start, journal_entry__date__lt=end
    )
    inc_d, inc_c = _sum(scoped.filter(account__account_type="INCOME"))
    exp_d, exp_c = _sum(scoped.filter(account__account_type__in=EXPENSE_TYPES))
    revenue = inc_c - inc_d
    expenses = exp_d - exp_c
    return {"revenue": revenue, "expenses": expenses, "net_profit": revenue - expenses}


def expense_by_account(entity, start, end):
    rows = (
        _items(entity)
        .filter(
            journal_entry__date__gte=start,
            journal_entry__date__lt=end,
            account__account_type__in=EXPENSE_TYPES,
        )
        .values("account__account_name")
        .annotate(d=Sum("debit"), c=Sum("credit"))
    )
    return {r["account__account_name"]: (r["d"] or 0) - (r["c"] or 0) for r in rows}


def cash_position(entity):
    """Debit-minus-credit of ASSET accounts whose name looks like cash/bank."""
    name_q = Q()
    for hint in CASH_NAME_HINTS:
        name_q |= Q(account__account_name__icontains=hint)
    d, c = _sum(_items(entity).filter(account__account_type="ASSET").filter(name_q))
    return d - c


def open_period_label(entity, today):
    open_period = (
        ClosingPeriod.objects.filter(entity=entity, is_closed=False)
        .order_by("-period")
        .first()
    )
    return open_period.period if open_period else today.strftime("%Y-%m")


def unposted_summary(entity):
    qs = JournalEntry.objects.filter(entity=entity, is_posted=False)
    oldest = qs.order_by("date").values_list("date", flat=True).first()
    return {"count": qs.count(), "oldest_date": oldest}


def unbalanced_count(entity):
    return (
        JournalEntry.objects.filter(entity=entity)
        .annotate(
            total_debit=Coalesce(Sum("items__debit"), 0),
            total_credit=Coalesce(Sum("items__credit"), 0),
        )
        .exclude(total_debit=F("total_credit"))
        .count()
    )


def collect_finance(entity, today=None):
    """Gather raw finance figures for one entity (or the null-entity bucket)."""
    today = today or timezone.localdate()
    cur_start, cur_end = month_bounds(today)
    prev_start = previous_month_start(today)

    current = period_totals(entity, cur_start, cur_end)
    previous = period_totals(entity, prev_start, cur_start)

    cur_exp = expense_by_account(entity, cur_start, cur_end)
    prev_exp = expense_by_account(entity, prev_start, cur_start)
    expense_changes = []
    for name, amount in cur_exp.items():
        before = prev_exp.get(name, 0)
        expense_changes.append(
            {"account": name, "current": amount, "previous": before, "delta": amount - before}
        )
    expense_changes.sort(key=lambda r: r["delta"], reverse=True)

    last_day = calendar.monthrange(today.year, today.month)[1]
    return {
        "month": today.strftime("%Y-%m"),
        "today": today,
        "days_left_in_month": last_day - today.day,
        "current": current,
        "previous": previous,
        "cash": cash_position(entity),
        "open_period": open_period_label(entity, today),
        "unposted": unposted_summary(entity),
        "unbalanced": unbalanced_count(entity),
        "expense_changes": expense_changes,
    }
