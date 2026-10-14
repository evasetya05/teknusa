from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.shortcuts import render

from agent.briefing import build_briefings, is_briefing_admin


@login_required
def briefing_view(request):
    """Full briefing page (admins only)."""
    if not is_briefing_admin(request.user):
        raise PermissionDenied
    briefings = build_briefings(request.session.get("current_entity_id"))
    return render(request, "agent/briefing.html", briefings)
