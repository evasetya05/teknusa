"""Tunable thresholds for briefing alert rules.

Override any key via ``settings.AGENT_BRIEFING = {...}``.
"""
from django.conf import settings

DEFAULTS = {
    # Finance
    "closing_warning_days": 5,          # warn when this many days (or fewer) remain in the month
    "profit_drop_percent": 20,          # warn when net profit falls by at least this % vs previous month
    "expense_jump_percent": 30,         # warn when an expense account rises by at least this %
    "expense_jump_min_amount": 1_000_000,  # ...and by at least this absolute amount
    "max_expense_alerts": 3,
    # Kanban
    "due_soon_days": 3,
    "stalled_days": 7,
    "overdue_critical_count": 5,
    "top_priority_count": 3,
}


def get_thresholds():
    merged = dict(DEFAULTS)
    merged.update(getattr(settings, "AGENT_BRIEFING", {}) or {})
    return merged
