"""Leads metrics collector. Pure data gathering: no alerts, no text."""
from datetime import timedelta

from django.db.models import Max, Q, Sum
from django.utils import timezone

from agent.config import get_thresholds
from leads.models import Lead

CLOSED_STATUSES = ("won", "lost")
PRIORITY_RANK = {"hot": 0, "warm": 1, "cold": 2}


def _lead_row(lead, today):
    return {
        "id": lead.pk,
        "name": lead.name,
        "company": lead.company or "",
        "status": lead.get_status_display() if hasattr(lead, "get_status_display") else lead.status,
        "priority": lead.priority,
        "estimated_value": float(lead.estimated_value or 0),
        "next_follow_up": lead.next_follow_up,
        "assigned_to": (lead.assigned_to.get_full_name() or lead.assigned_to.username) if lead.assigned_to else None,
        "days_overdue": (today - lead.next_follow_up).days if lead.next_follow_up and lead.next_follow_up < today else 0,
    }


def collect_leads(entity, today=None, now=None):
    thresholds = get_thresholds()
    now = now or timezone.now()
    today = today or timezone.localdate()
    month_start = today.replace(day=1)
    soon_limit = today + timedelta(days=thresholds.get("lead_due_soon_days", 3))
    stalled_before = now - timedelta(days=thresholds.get("lead_stalled_days", 7))

    leads_qs = Lead.objects.filter(entity=entity)

    open_leads = leads_qs.exclude(status__in=CLOSED_STATUSES).select_related("assigned_to")

    pipeline_agg = open_leads.aggregate(total=Sum("estimated_value"))
    pipeline_value = float(pipeline_agg["total"] or 0)

    overdue = list(open_leads.filter(next_follow_up__lt=today))
    urgent_overdue = [l for l in overdue if l.priority == "hot"]
    due_today = list(open_leads.filter(next_follow_up=today))
    due_soon = list(open_leads.filter(next_follow_up__gt=today, next_follow_up__lte=soon_limit))
    unassigned = open_leads.filter(assigned_to__isnull=True).count()
    hot_count = open_leads.filter(priority="hot").count()

    open_with_last = open_leads.annotate(last_interaction=Max("interactions__created_at"))
    stalled_leads = open_with_last.filter(
        Q(last_interaction__lt=stalled_before) |
        Q(last_interaction__isnull=True, created_at__lt=stalled_before)
    )
    stalled_count = stalled_leads.count()
    stalled_hot_count = stalled_leads.filter(priority="hot").count()

    new_month = leads_qs.filter(created_at__date__gte=month_start).count()
    won_month = leads_qs.filter(status="won", created_at__date__gte=month_start).count()

    candidates = {l.pk: l for l in overdue + due_today + due_soon}
    for l in open_leads.filter(priority="hot"):
        candidates.setdefault(l.pk, l)

    ranked = sorted(
        candidates.values(),
        key=lambda l: (
            PRIORITY_RANK.get(l.priority, 9),
            l.next_follow_up is None,
            l.next_follow_up or today,
            -float(l.estimated_value or 0),
        ),
    )

    top_count = thresholds.get("lead_top_priority_count", 3)
    top_leads = [_lead_row(l, today) for l in ranked[:top_count]]

    return {
        "entity_id": getattr(entity, "pk", None),
        "entity_name": getattr(entity, "name", ""),
        "open_total": open_leads.count(),
        "pipeline_value": pipeline_value,
        "overdue": len(overdue),
        "urgent_overdue": len(urgent_overdue),
        "due_today": len(due_today),
        "due_soon": len(due_soon),
        "hot_count": hot_count,
        "unassigned": unassigned,
        "stalled": stalled_count,
        "stalled_hot": stalled_hot_count,
        "new_month": new_month,
        "won_month": won_month,
        "top_leads": top_leads,
    }

