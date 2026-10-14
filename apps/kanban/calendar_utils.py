"""Pure helpers to lay tasks out on a month grid (no database access)."""
import calendar
from datetime import date, timedelta

MAX_VISIBLE_PER_DAY = 4


def parse_month(value, today):
    """Parse 'YYYY-MM' into (year, month); fall back to today's month."""
    try:
        year_s, month_s = (value or "").split("-")
        year, month = int(year_s), int(month_s)
        date(year, month, 1)
        return year, month
    except (ValueError, TypeError):
        return today.year, today.month


def shift_month(year, month, delta):
    index = year * 12 + (month - 1) + delta
    return index // 12, index % 12 + 1


def grid_range(year, month):
    """First and last date shown for the month (full Monday-start weeks)."""
    weeks = calendar.Calendar(firstweekday=0).monthdatescalendar(year, month)
    return weeks[0][0], weeks[-1][-1]


def task_span(task):
    """Return (start, end) dates for a task, or None if it has no dates."""
    start, end = task.start_date, task.due_date
    if not start and not end:
        return None
    start = start or end
    end = end or start
    if start > end:
        start, end = end, start
    return start, end


def build_month_grid(year, month, tasks, today):
    """Return a list of weeks; each week is a list of day dicts with tasks."""
    weeks = calendar.Calendar(firstweekday=0).monthdatescalendar(year, month)
    grid_start, grid_end = weeks[0][0], weeks[-1][-1]

    by_day = {}
    for task in tasks:
        span = task_span(task)
        if not span:
            continue
        start, end = span
        if end < grid_start or start > grid_end:
            continue
        day = max(start, grid_start)
        last = min(end, grid_end)
        while day <= last:
            by_day.setdefault(day, []).append(
                {
                    "id": task.pk,
                    "title": task.title,
                    "priority": task.priority,
                    "completed": task.completed,
                    "overdue": bool(
                        not task.completed and task.due_date and task.due_date < today
                    ),
                    "is_start": day == start,
                    "is_end": day == end,
                    "board_name": getattr(getattr(task, "column", None), "board", None).name if getattr(getattr(task, "column", None), "board", None) else "",
                }
            )
            day += timedelta(days=1)

    result = []
    for week in weeks:
        row = []
        for day in week:
            items = sorted(
                by_day.get(day, []),
                key=lambda t: (t["completed"], t["title"].lower()),
            )
            row.append(
                {
                    "date": day,
                    "in_month": day.month == month,
                    "is_today": day == today,
                    "tasks": items[:MAX_VISIBLE_PER_DAY],
                    "more": max(0, len(items) - MAX_VISIBLE_PER_DAY),
                }
            )
        result.append(row)
    return result
