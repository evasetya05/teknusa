"""Kanban metrics collector. Pure data gathering: no alerts, no text."""
from datetime import timedelta

from django.db.models import Count, Q
from django.utils import timezone

from kanban.models import Board, Task

from agent.config import get_thresholds

PRIORITY_RANK = {"urgent": 0, "high": 1, "medium": 2, "low": 3}


def _task_row(task, today):
    return {
        "id": task.pk,
        "title": task.title,
        "priority": task.priority,
        "due_date": task.due_date,
        "column": task.column.name,
        "days_overdue": (today - task.due_date).days
        if task.due_date and task.due_date < today
        else 0,
    }


def collect_board(board, today=None, now=None):
    thresholds = get_thresholds()
    now = now or timezone.now()
    today = today or timezone.localdate()
    soon_limit = today + timedelta(days=thresholds["due_soon_days"])
    stalled_before = now - timedelta(days=thresholds["stalled_days"])
    week_ago = now - timedelta(days=7)

    open_tasks = Task.objects.filter(column__board=board, completed=False).select_related("column")

    overdue = list(open_tasks.filter(due_date__lt=today))
    due_soon = list(open_tasks.filter(due_date__gte=today, due_date__lte=soon_limit))
    unassigned = open_tasks.filter(assignees__isnull=True).count()
    stalled = open_tasks.filter(updated_at__lt=stalled_before).count()
    completed_week = Task.objects.filter(
        column__board=board, completed=True, updated_at__gte=week_ago
    ).count()

    columns = [
        {"name": c.name, "open": c.open_count}
        for c in board.columns.annotate(
            open_count=Count("tasks", filter=Q(tasks__completed=False))
        ).order_by("position")
    ]

    candidates = {t.pk: t for t in overdue + due_soon}
    for t in open_tasks.filter(priority="urgent"):
        candidates.setdefault(t.pk, t)
    ranked = sorted(
        candidates.values(),
        key=lambda t: (
            PRIORITY_RANK.get(t.priority, 9),
            t.due_date is None,
            t.due_date or today,
        ),
    )[: thresholds["top_priority_count"]]

    return {
        "board_id": board.pk,
        "board": board.name,
        "open_total": open_tasks.count(),
        "overdue": len(overdue),
        "urgent_overdue": sum(1 for t in overdue if t.priority == "urgent"),
        "due_soon": len(due_soon),
        "unassigned": unassigned,
        "stalled": stalled,
        "completed_week": completed_week,
        "columns": columns,
        "top_tasks": [_task_row(t, today) for t in ranked],
    }


def collect_kanban(entity=None, all_entities=False, today=None):
    """Collect per-board metrics.

    ``all_entities=True`` covers every board; otherwise only boards of ``entity``.
    """
    boards = Board.objects.all() if all_entities else Board.objects.filter(entity=entity)
    return [collect_board(b, today=today) for b in boards.order_by("name")]
