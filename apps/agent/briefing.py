"""Compose collectors, rules and narration into briefing dicts for the UI."""
from django.core.exceptions import ValidationError

from entity.models import Entity

from agent.collectors.finance import collect_finance
from agent.collectors.kanban import collect_board
from agent.llm_narrator import narrate
from agent.narrator import narrate_board, narrate_finance
from agent.rules import finance_alerts, kanban_alerts, overall_status
from kanban.models import Board


def is_briefing_admin(user):
    """Briefings are visible to admins only (staff or superuser)."""
    return bool(user and user.is_authenticated and (user.is_staff or user.is_superuser))


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
        "status": overall_status(alerts),
        "alerts": alerts,
        "metrics": metrics,
        "narration": narration,
        "narration_source": source,
    }


def build_briefings(session_entity_id, today=None):
    """Full dashboard payload: finance per entity, kanban per board."""
    entities = resolve_entities(session_entity_id)
    finance = [build_finance_briefing(e, today=today) for e in entities]

    boards = Board.objects.filter(entity__in=entities).order_by("name")
    kanban = [build_board_briefing(b, today=today) for b in boards]

    order = {"red": 0, "yellow": 1, "green": 2}
    finance.sort(key=lambda b: order[b["status"]])
    kanban.sort(key=lambda b: order[b["status"]])
    return {"finance": finance, "kanban": kanban}
