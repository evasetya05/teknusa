from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.shortcuts import render

from agent.briefing import is_briefing_admin
from agent.providers import get_chain, get_config
from agent.providers.runtime import (
    MODES,
    get_stored_api_key,
    key_hint,
    load_override,
)


@login_required
def llm_status_view(request):
    """Page showing LLM config with a button to run a live test (admins only)."""
    if not is_briefing_admin(request.user):
        raise PermissionDenied
    config = get_config()
    return render(request, "agent/llm_status.html", {
        "mode": config.get("mode"),
        "local": config.get("local"),
        "gemini": config.get("gemini"),
        "gemini_key_set": bool(config["gemini"].get("api_key")),
        "gemini_key_source": config["gemini"].get("key_source"),
        "gemini_key_hint": key_hint(get_stored_api_key()),
        "modes": MODES,
        "overridden": bool(load_override()),
        "enabled": bool(get_chain()),
        "chain": [p.name for p in get_chain()],
    })

