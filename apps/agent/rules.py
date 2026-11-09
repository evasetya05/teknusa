"""Alert rules: turn raw figures into severity-tagged alerts. No I/O."""
from dataclasses import dataclass

from agent.config import get_thresholds

INFO, WARNING, CRITICAL = "info", "warning", "critical"
_SEVERITY_ORDER = {INFO: 0, WARNING: 1, CRITICAL: 2}


@dataclass(frozen=True)
class Alert:
    severity: str
    code: str
    message: str


def overall_status(alerts):
    """Map alerts to a traffic-light status: green / yellow / red."""
    top = max((_SEVERITY_ORDER[a.severity] for a in alerts), default=-1)
    if top >= _SEVERITY_ORDER[CRITICAL]:
        return "red"
    if top >= _SEVERITY_ORDER[WARNING]:
        return "yellow"
    return "green"


def sort_alerts(alerts):
    return sorted(alerts, key=lambda a: -_SEVERITY_ORDER[a.severity])


def _money(value):
    return f"Rp {value:,.0f}"


def finance_alerts(metrics, thresholds=None):
    t = thresholds or get_thresholds()
    alerts = []
    cur, prev = metrics["current"], metrics["previous"]

    if metrics["unbalanced"]:
        alerts.append(Alert(CRITICAL, "unbalanced",
                            f"{metrics['unbalanced']} journal entr{'y is' if metrics['unbalanced'] == 1 else 'ies are'} unbalanced (debit does not equal credit)."))

    if metrics["cash"] < 0:
        alerts.append(Alert(CRITICAL, "negative_cash",
                            f"Cash/bank position is negative ({_money(metrics['cash'])})."))

    if cur["net_profit"] < 0:
        alerts.append(Alert(WARNING, "loss",
                            f"Net loss of {_money(abs(cur['net_profit']))} so far this month."))

    if prev["net_profit"] > 0:
        drop = (prev["net_profit"] - cur["net_profit"]) / prev["net_profit"] * 100
        if drop >= t["profit_drop_percent"] and cur["net_profit"] >= 0:
            alerts.append(Alert(WARNING, "profit_drop",
                                f"Net profit is down {drop:.0f}% compared with last month."))

    unposted = metrics["unposted"]["count"]
    if metrics["open_period"] < metrics["month"]:
        alerts.append(Alert(CRITICAL, "closing_overdue",
                            f"Period {metrics['open_period']} is still open and overdue for closing."))
    elif unposted and metrics["days_left_in_month"] <= t["closing_warning_days"]:
        alerts.append(Alert(WARNING, "closing_soon",
                            f"{unposted} unposted journal(s); {metrics['days_left_in_month']} day(s) left before month end."))
    elif unposted:
        alerts.append(Alert(INFO, "unposted",
                            f"{unposted} journal(s) are waiting to be posted."))

    shown = 0
    for row in metrics["expense_changes"]:
        if shown >= t["max_expense_alerts"]:
            break
        if row["delta"] < t["expense_jump_min_amount"]:
            continue
        base = row["previous"]
        pct = (row["delta"] / base * 100) if base > 0 else None
        if pct is None or pct >= t["expense_jump_percent"]:
            tail = f" (+{pct:.0f}%)" if pct is not None else " (new this month)"
            alerts.append(Alert(WARNING, "expense_jump",
                                f"Expense '{row['account']}' rose by {_money(row['delta'])}{tail}."))
            shown += 1

    return sort_alerts(alerts)


def kanban_alerts(board_metrics, thresholds=None):
    t = thresholds or get_thresholds()
    alerts = []
    m = board_metrics

    if m["overdue"]:
        critical = m["urgent_overdue"] > 0 or m["overdue"] >= t["overdue_critical_count"]
        alerts.append(Alert(CRITICAL if critical else WARNING, "overdue",
                            f"{m['overdue']} task(s) overdue."))
    if m["stalled"]:
        alerts.append(Alert(WARNING, "stalled",
                            f"{m['stalled']} task(s) not updated for {t['stalled_days']}+ days."))
    if m["due_soon"]:
        alerts.append(Alert(INFO, "due_soon",
                            f"{m['due_soon']} task(s) due within {t['due_soon_days']} days."))
    if m["unassigned"]:
        alerts.append(Alert(INFO, "unassigned",
                            f"{m['unassigned']} open task(s) have no assignee."))
    return sort_alerts(alerts)


def leads_alerts(lead_metrics, thresholds=None):
    t = thresholds or get_thresholds()
    alerts = []
    m = lead_metrics

    if m["overdue"]:
        critical = m["urgent_overdue"] > 0 or m["overdue"] >= t.get("lead_overdue_critical_count", 3)
        msg = f"{m['overdue']} lead(s) overdue for follow-up"
        if m["urgent_overdue"]:
            msg += f" (including {m['urgent_overdue']} hot lead{'s' if m['urgent_overdue'] > 1 else ''})"
        msg += "."
        alerts.append(Alert(CRITICAL if critical else WARNING, "lead_overdue", msg))

    if m.get("stalled_hot"):
        alerts.append(Alert(WARNING, "lead_stalled_hot",
                            f"{m['stalled_hot']} hot lead(s) with no interaction in {t.get('lead_stalled_days', 7)}+ days."))
    elif m.get("stalled"):
        alerts.append(Alert(INFO, "lead_stalled",
                            f"{m['stalled']} lead(s) with no interaction in {t.get('lead_stalled_days', 7)}+ days."))

    if m["due_today"]:
        alerts.append(Alert(INFO, "lead_due_today",
                            f"{m['due_today']} lead(s) scheduled for follow-up today."))
    elif m["due_soon"]:
        alerts.append(Alert(INFO, "lead_due_soon",
                            f"{m['due_soon']} lead(s) due for follow-up in the next {t.get('lead_due_soon_days', 3)} days."))

    if m["unassigned"]:
        alerts.append(Alert(WARNING if m["hot_count"] and m["unassigned"] else INFO, "lead_unassigned",
                            f"{m['unassigned']} open lead(s) have no assignee."))

    return sort_alerts(alerts)
