from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.shortcuts import redirect
from django.views.decorators.http import require_POST

from agent.briefing import is_briefing_admin
from agent.providers import get_config
from agent.providers.runtime import (
    clean_override,
    clear_override,
    save_override,
)


@login_required
@require_POST
def llm_settings_view(request):
    """Manually choose the LLM mode/provider (admins only). ``reset`` returns to env defaults."""
    if not is_briefing_admin(request.user):
        raise PermissionDenied
    if request.POST.get("action") == "reset":
        clear_override()
        messages.success(request, "Pengaturan manual dihapus; kembali ke konfigurasi environment.")
        return redirect("agent:llm_status")
    try:
        cleaned = clean_override(request.POST)
        save_override(cleaned)
    except ValueError as exc:
        messages.error(request, str(exc))
    except OSError as exc:
        messages.error(request, f"Gagal menyimpan pengaturan: {exc.__class__.__name__}")
    else:
        cfg = get_config()
        mode = cleaned["mode"]
        if mode in ("gemini", "auto") and not cfg["gemini"].get("api_key"):
            messages.warning(request, f"Pengaturan disimpan (mode {mode.upper()}), tetapi API Key Gemini belum terpasang.")
        else:
            mode_display = {
                "off": "Off (Template)",
                "local": "Lokal (Ollama)",
                "gemini": "API (Gemini)",
                "auto": "Auto (Ollama lalu Gemini)",
            }.get(mode, mode)
            messages.success(request, f"Pengaturan agent AI berhasil disimpan. Mode aktif: {mode_display}.")
    return redirect("agent:llm_status")

