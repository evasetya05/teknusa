import json

from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.views.decorators.http import require_POST

from agent import chat
from agent.briefing import is_briefing_admin


@login_required
@require_POST
def chat_view(request):
    """Dashboard chat about the reports (admins only). Body: {message, history[]}."""
    if not is_briefing_admin(request.user):
        return JsonResponse(
            {"ok": False, "error": "Access denied: report chat is restricted to administrators."},
            status=403,
        )
    try:
        payload = json.loads(request.body.decode("utf-8") or "{}")
    except (ValueError, UnicodeDecodeError):
        return JsonResponse({"ok": False, "error": "Invalid request."}, status=400)
    message = payload.get("message") if isinstance(payload, dict) else None
    if not isinstance(message, str) or not message.strip():
        return JsonResponse({"ok": False, "error": "Empty question."}, status=400)
    if len(message) > chat.MAX_QUESTION_CHARS:
        return JsonResponse({"ok": False, "error": "Question is too long."}, status=400)
    if chat.rate_limited(request.user.pk):
        return JsonResponse({"ok": False, "error": "Too many requests. Please try again in a moment."}, status=429)
    session_entity_id = request.session.get("selected_entity_id", "all")
    result = chat.answer_question(message, payload.get("history"), session_entity_id=session_entity_id)
    return JsonResponse({"ok": True, **result})

