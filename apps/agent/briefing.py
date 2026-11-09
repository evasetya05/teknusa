"""Compose collectors, rules and narration into briefing dicts for the UI."""
from django.core.exceptions import ValidationError

from entity.models import Entity

from agent.collectors.finance import collect_finance
from agent.collectors.kanban import PRIORITY_RANK, collect_board
from agent.collectors.leads import collect_leads
from agent.llm_narrator import narrate
from agent.narrator import narrate_board, narrate_finance, narrate_leads
from agent.rules import finance_alerts, kanban_alerts, leads_alerts, overall_status
from kanban.models import Board


def is_briefing_admin(user):
    """Briefings are visible to admins only (staff, superuser, or username admin)."""
    return bool(user and user.is_authenticated and (user.is_staff or user.is_superuser or user.username == "admin"))


def resolve_entities(session_entity_id):
    """Return the list of entities to brief, honouring the session selection."""
    active = Entity.objects.filter(is_active=True)
    if session_entity_id and session_entity_id != "all":
        try:
            return list(active.filter(id=session_entity_id))
        except (ValueError, TypeError, ValidationError):
            return []
    return list(active.order_by("name"))


def build_finance_briefing(entity, today=None):
    metrics = collect_finance(entity, today=today)
    alerts = finance_alerts(metrics)
    narration, source = narrate(narrate_finance(entity.name, metrics, alerts), alerts)
    return {
        "entity": entity,
        "status": overall_status(alerts),
        "alerts": alerts,
        "metrics": metrics,
        "narration": narration,
        "narration_source": source,
    }


def build_board_briefing(board, today=None):
    metrics = collect_board(board, today=today)
    alerts = kanban_alerts(metrics)
    narration, source = narrate(narrate_board(metrics, alerts), alerts)
    return {
        "board": board,
        "entity": getattr(board, "entity", None),
        "status": overall_status(alerts),
        "alerts": alerts,
        "metrics": metrics,
        "narration": narration,
        "narration_source": source,
    }


def build_entity_kanban_briefing(entity, today=None):
    """Aggregate all boards for an entity into a compact overview."""
    boards = Board.objects.filter(entity=entity).order_by("name")
    board_briefings = [build_board_briefing(b, today=today) for b in boards]

    all_overdue = []
    for b in board_briefings:
        all_overdue.extend(b["metrics"].get("overdue_tasks", []))

    all_overdue.sort(key=lambda t: (PRIORITY_RANK.get(t["priority"], 9), -t["days_overdue"]))

    total_open = sum(b["metrics"]["open_total"] for b in board_briefings)
    total_overdue = sum(b["metrics"]["overdue"] for b in board_briefings)
    total_urgent_overdue = sum(b["metrics"]["urgent_overdue"] for b in board_briefings)
    total_completed_week = sum(b["metrics"]["completed_week"] for b in board_briefings)

    if any(b["status"] == "red" for b in board_briefings):
        status = "red"
    elif any(b["status"] == "yellow" for b in board_briefings):
        status = "yellow"
    else:
        status = "green"

    return {
        "entity": entity,
        "status": status,
        "board_count": len(board_briefings),
        "total_open": total_open,
        "total_overdue": total_overdue,
        "total_urgent_overdue": total_urgent_overdue,
        "total_completed_week": total_completed_week,
        "overdue_tasks": all_overdue,
        "boards": board_briefings,
    }


def build_leads_briefing(entity, today=None):
    metrics = collect_leads(entity, today=today)
    alerts = leads_alerts(metrics)
    narration, source = narrate(narrate_leads(entity.name, metrics, alerts), alerts)
    return {
        "entity": entity,
        "status": overall_status(alerts),
        "alerts": alerts,
        "metrics": metrics,
        "narration": narration,
        "narration_source": source,
    }


def build_briefings(session_entity_id, today=None):
    """Full dashboard payload: finance per entity, kanban per entity & board, leads per entity."""
    entities = resolve_entities(session_entity_id)
    finance = [build_finance_briefing(e, today=today) for e in entities]

    boards = Board.objects.filter(entity__in=entities).order_by("name")
    kanban = [build_board_briefing(b, today=today) for b in boards]
    kanban_by_entity = [
        build_entity_kanban_briefing(e, today=today)
        for e in entities
        if Board.objects.filter(entity=e).exists()
    ]

    leads = [build_leads_briefing(e, today=today) for e in entities]

    order = {"red": 0, "yellow": 1, "green": 2}
    finance.sort(key=lambda b: order[b["status"]])
    kanban.sort(key=lambda b: order[b["status"]])
    kanban_by_entity.sort(key=lambda b: order[b["status"]])
    leads.sort(key=lambda b: order[b["status"]])
    return {
        "finance": finance,
        "kanban": kanban,
        "kanban_by_entity": kanban_by_entity,
        "leads": leads,
    }
