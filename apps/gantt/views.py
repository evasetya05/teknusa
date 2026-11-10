"""Gantt chart on top of kanban tasks, plus dependencies, milestones and baselines."""
import json
from datetime import date

from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.shortcuts import render
from django.urls import reverse
from django.utils import timezone
from django.views.decorators.http import require_POST

from kanban.models import Board, Task
from entity.models import Entity

from .models import Milestone, TaskBaseline, TaskDependency

PRIORITY_COLORS = {
    "low": "#94a3b8",
    "medium": "#3b82f6",
    "high": "#f59e0b",
    "urgent": "#ef4444",
}


def _visible_boards(request, entity_id=None):
    boards = Board.objects.select_related("entity")
    if entity_id is None:
        entity_id = request.GET.get("entity") or request.session.get("current_entity_id")
    if entity_id and entity_id != "all":
        boards = boards.filter(entity_id=entity_id)
    return boards


def _visible_tasks(request):
    return Task.objects.filter(column__board__in=_visible_boards(request))


def _err(msg, status=400):
    return JsonResponse({"ok": False, "error": msg}, status=status)


def _dates(task):
    start = task.start_date or task.due_date
    end = task.due_date or task.start_date
    if start and end and end < start:
        start, end = end, start
    return start, end


@login_required
def gantt_view(request):
    today = timezone.localdate()

    # 1. Handle Entity (PT) filter
    all_entities = Entity.objects.filter(is_active=True).order_by("name")
    entity_param = request.GET.get("entity")
    if entity_param:
        selected_entity_id = entity_param
        # Sync with session so switching in Gantt retains active entity across the ERP
        request.session["current_entity_id"] = entity_param
    else:
        selected_entity_id = request.session.get("current_entity_id", "all")

    current_entity_obj = None
    if selected_entity_id and selected_entity_id != "all":
        try:
            current_entity_obj = Entity.objects.filter(id=selected_entity_id, is_active=True).first()
            if not current_entity_obj:
                selected_entity_id = "all"
        except (ValueError, Exception):
            selected_entity_id = "all"

    # 2. Boards for selected entity (or all entities)
    boards_qs = Board.objects.select_related("entity")
    if selected_entity_id and selected_entity_id != "all":
        boards_qs = boards_qs.filter(entity_id=selected_entity_id)
    boards = list(boards_qs.order_by("entity__name", "name"))

    # 3. Selected board filter
    board_id = request.GET.get("board")
    selected_board = None
    if board_id and board_id.isdigit():
        selected_board = next((b for b in boards if b.pk == int(board_id)), None)

    show_done = request.GET.get("done") == "1"
    scope_boards = [selected_board] if selected_board else boards

    tasks = Task.objects.select_related("column__board__entity", "gantt_baseline").prefetch_related("assignees")
    tasks = tasks.filter(column__board__in=scope_boards)
    if not show_done:
        tasks = tasks.filter(completed=False)
    tasks = tasks.exclude(start_date__isnull=True, due_date__isnull=True).order_by(
        "column__board__entity__name", "column__board__name", "start_date", "due_date", "id"
    )

    rows = []
    for t in tasks:
        start, end = _dates(t)
        stats = t.checklist_stats
        bl = getattr(t, "gantt_baseline", None)
        entity_name = t.column.board.entity.name if t.column.board.entity else "Umum (Tanpa PT)"
        entity_id_str = str(t.column.board.entity_id) if t.column.board.entity_id else ""
        rows.append({
            "id": t.pk,
            "title": t.title,
            "board": t.column.board.name,
            "board_id": t.column.board_id,
            "entity": entity_name,
            "entity_id": entity_id_str,
            "column": t.column.name,
            "start": start.isoformat(),
            "end": end.isoformat(),
            "priority": t.priority,
            "color": PRIORITY_COLORS.get(t.priority, "#3b82f6"),
            "completed": t.completed,
            "overdue": (not t.completed) and end < today,
            "progress": 100 if t.completed else (stats["percent"] if stats else 0),
            "assignees": [u.get_full_name() or u.username for u in t.assignees.all()],
            "url": reverse("kanban:task_edit", args=[t.pk]),
            "baseline": {
                "start": bl.planned_start.isoformat(),
                "end": bl.planned_end.isoformat(),
            } if bl else None,
        })

    task_ids = [r["id"] for r in rows]
    deps = [
        {"id": d.pk, "from": d.predecessor_id, "to": d.successor_id}
        for d in TaskDependency.objects.filter(predecessor_id__in=task_ids, successor_id__in=task_ids)
    ]
    milestones = [
        {
            "id": m.pk, "title": m.title, "date": m.date.isoformat(), "done": m.is_done,
            "board": m.board.name, "board_id": m.board_id,
            "entity": m.board.entity.name if m.board.entity else "Umum (Tanpa PT)",
            "entity_id": str(m.board.entity_id) if m.board.entity_id else "",
        }
        for m in Milestone.objects.filter(board__in=scope_boards).select_related("board__entity")
    ]

    no_date_count = Task.objects.filter(
        column__board__in=scope_boards,
        completed=False, start_date__isnull=True, due_date__isnull=True,
    ).count()

    data = {
        "rows": rows,
        "deps": deps,
        "milestones": milestones,
        "is_all_entities": (selected_entity_id == "all"),
    }
    return render(request, "gantt/gantt.html", {
        "all_entities": all_entities,
        "selected_entity_id": str(selected_entity_id),
        "current_entity_obj": current_entity_obj,
        "is_all_entities": (selected_entity_id == "all"),
        "boards": boards,
        "selected_board": selected_board,
        "show_done": show_done,
        "data_json": json.dumps(data),
        "task_count": len(rows),
        "milestone_count": len(milestones),
        "no_date_count": no_date_count,
        "today": today.isoformat(),
    })


@login_required
@require_POST
def update_task_dates(request, task_id):
    """Persist dates after dragging/resizing a bar. Body: start, end (ISO)."""
    try:
        task = _visible_tasks(request).get(pk=task_id)
        start = date.fromisoformat(request.POST.get("start", ""))
        end = date.fromisoformat(request.POST.get("end", ""))
    except (Task.DoesNotExist, ValueError):
        return _err("Invalid data.")
    if end < start:
        return _err("End before start.")
    task.start_date, task.due_date = start, end
    task.save(update_fields=["start_date", "due_date", "updated_at"])
    return JsonResponse({"ok": True})


# ---- Dependencies ---------------------------------------------------------

def _reaches(start_id, target_id):
    """True if target is reachable from start following successor links."""
    seen, stack = set(), [start_id]
    while stack:
        cur = stack.pop()
        if cur == target_id:
            return True
        if cur in seen:
            continue
        seen.add(cur)
        stack.extend(TaskDependency.objects.filter(predecessor_id=cur).values_list("successor_id", flat=True))
    return False


@login_required
@require_POST
def dependency_add(request):
    try:
        pred_id = int(request.POST.get("from", ""))
        succ_id = int(request.POST.get("to", ""))
    except ValueError:
        return _err("Invalid data.")
    if pred_id == succ_id:
        return _err("A task cannot depend on itself.")
    tasks = _visible_tasks(request)
    if tasks.filter(pk__in=[pred_id, succ_id]).count() != 2:
        return _err("Task not found.", 404)
    if TaskDependency.objects.filter(predecessor_id=pred_id, successor_id=succ_id).exists():
        return _err("Dependency already exists.")
    if _reaches(succ_id, pred_id):
        return _err("This link would create a circular dependency.")
    dep = TaskDependency.objects.create(
        predecessor_id=pred_id, successor_id=succ_id, created_by=request.user)
    return JsonResponse({"ok": True, "id": dep.pk})


@login_required
@require_POST
def dependency_delete(request, pk):
    deleted, _ = TaskDependency.objects.filter(
        pk=pk, predecessor__in=_visible_tasks(request)).delete()
    return JsonResponse({"ok": bool(deleted)})


# ---- Milestones -----------------------------------------------------------

@login_required
@require_POST
def milestone_add(request):
    title = (request.POST.get("title") or "").strip()
    try:
        when = date.fromisoformat(request.POST.get("date", ""))
        board = _visible_boards(request).get(pk=int(request.POST.get("board", "")))
    except (ValueError, Board.DoesNotExist):
        return _err("Invalid board or date.")
    if not title:
        return _err("Title is required.")
    m = Milestone.objects.create(board=board, title=title[:200], date=when, created_by=request.user)
    return JsonResponse({"ok": True, "id": m.pk})


@login_required
@require_POST
def milestone_toggle(request, pk):
    m = Milestone.objects.filter(pk=pk, board__in=_visible_boards(request)).first()
    if not m:
        return _err("Not found.", 404)
    m.is_done = not m.is_done
    m.save(update_fields=["is_done"])
    return JsonResponse({"ok": True, "done": m.is_done})


@login_required
@require_POST
def milestone_move(request, pk):
    m = Milestone.objects.filter(pk=pk, board__in=_visible_boards(request)).first()
    try:
        new_date = date.fromisoformat(request.POST.get("date", ""))
    except ValueError:
        return _err("Invalid date.")
    if not m:
        return _err("Not found.", 404)
    m.date = new_date
    m.save(update_fields=["date"])
    return JsonResponse({"ok": True})


@login_required
@require_POST
def milestone_delete(request, pk):
    deleted, _ = Milestone.objects.filter(pk=pk, board__in=_visible_boards(request)).delete()
    return JsonResponse({"ok": bool(deleted)})


# ---- Baselines ------------------------------------------------------------

@login_required
@require_POST
def baseline_set(request):
    """Snapshot current dates of visible dated tasks. overwrite=1 replaces existing baselines."""
    overwrite = request.POST.get("overwrite") == "1"
    board_id = request.POST.get("board")
    tasks = _visible_tasks(request).filter(completed=False).exclude(
        start_date__isnull=True, due_date__isnull=True)
    if board_id and board_id.isdigit():
        tasks = tasks.filter(column__board_id=int(board_id))
    count = 0
    for t in tasks.select_related("gantt_baseline"):
        start, end = _dates(t)
        existing = getattr(t, "gantt_baseline", None)
        if existing and not overwrite:
            continue
        TaskBaseline.objects.update_or_create(
            task=t, defaults={"planned_start": start, "planned_end": end, "set_by": request.user})
        count += 1
    return JsonResponse({"ok": True, "count": count})


@login_required
@require_POST
def baseline_clear(request):
    board_id = request.POST.get("board")
    qs = TaskBaseline.objects.filter(task__in=_visible_tasks(request))
    if board_id and board_id.isdigit():
        qs = qs.filter(task__column__board_id=int(board_id))
    deleted, _ = qs.delete()
    return JsonResponse({"ok": True, "count": deleted})
