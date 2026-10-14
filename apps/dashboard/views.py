from django.shortcuts import render
from django.contrib.auth.decorators import login_required

from agent.briefing import build_briefings, is_briefing_admin


@login_required
def dashboard_view(request):
    """
    Dashboard view that requires user to be logged in.
    Admins also see the daily finance & kanban briefing.
    """
    context = {}
    if is_briefing_admin(request.user):
        # Report per entity: always cover all active entities.
        context.update(build_briefings("all"))
        context['show_briefing'] = True
    return render(request, 'dashboard/dashboard.html', context)
