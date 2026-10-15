import io
import json
import time
import unittest

from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.http import JsonResponse
from django.shortcuts import redirect, render
from django.views.decorators.http import require_POST

from agent import chat
from agent.briefing import build_briefings, is_briefing_admin
from agent.providers import ProviderError, get_chain, get_config
from agent.providers.runtime import (
    MODES, clean_override, clear_override, get_stored_api_key, key_hint, load_override, save_override,
)


@login_required
def briefing_view(request):
    """Full briefing page (admins only)."""
    if not is_briefing_admin(request.user):
        raise PermissionDenied
    briefings = build_briefings("all")
    return render(request, "agent/briefing.html", briefings)


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
        if cleaned["mode"] in ("gemini", "auto") and not get_config()["gemini"].get("api_key"):
            messages.warning(request, "Tersimpan, tetapi GEMINI_API_KEY belum diset di environment server.")
        else:
            messages.success(request, "Pengaturan agent AI disimpan.")
    return redirect("agent:llm_status")


@login_required
@require_POST
def chat_view(request):
    """Dashboard chat about the reports (admins only). Body: {message, history[]}."""
    if not is_briefing_admin(request.user):
        raise PermissionDenied
    try:
        payload = json.loads(request.body.decode("utf-8") or "{}")
    except ValueError:
        return JsonResponse({"ok": False, "error": "Permintaan tidak valid."}, status=400)
    message = payload.get("message") if isinstance(payload, dict) else None
    if not isinstance(message, str) or not message.strip():
        return JsonResponse({"ok": False, "error": "Pertanyaan kosong."}, status=400)
    if len(message) > chat.MAX_QUESTION_CHARS:
        return JsonResponse({"ok": False, "error": "Pertanyaan terlalu panjang."}, status=400)
    if chat.rate_limited(request.user.pk):
        return JsonResponse({"ok": False, "error": "Terlalu banyak permintaan, coba sesaat lagi."}, status=429)
    result = chat.answer_question(message, payload.get("history"))
    return JsonResponse({"ok": True, **result})


@login_required
@require_POST
def llm_test_view(request):
    """Run a real generate() call against each configured provider."""
    if not is_briefing_admin(request.user):
        raise PermissionDenied
    chain = get_chain()
    if not chain:
        return JsonResponse({
            "ok": False,
            "error": "LLM mode is 'off'. Pilih mode lain di halaman ini (local, gemini, atau auto).",
        })
    results = []
    for provider in chain:
        started = time.monotonic()
        try:
            text = provider.generate("Reply with the single word: OK")
            results.append({
                "provider": provider.name,
                "model": getattr(provider, "model", ""),
                "ok": True,
                "response": text[:200],
                "seconds": round(time.monotonic() - started, 2),
            })
        except ProviderError as exc:
            results.append({
                "provider": provider.name,
                "model": getattr(provider, "model", ""),
                "ok": False,
                "error": str(exc),
                "seconds": round(time.monotonic() - started, 2),
            })
    return JsonResponse({"ok": all(r["ok"] for r in results), "results": results})


@login_required
@require_POST
def llm_test_suite_view(request):
    """Run unit tests from apps/agent/test_llm.py and return report."""
    if not is_briefing_admin(request.user):
        raise PermissionDenied
    from agent import test_llm
    suite = unittest.defaultTestLoader.loadTestsFromModule(test_llm)
    stream = io.StringIO()
    runner = unittest.TextTestRunner(stream=stream, verbosity=2)
    started = time.monotonic()
    result = runner.run(suite)
    duration = round(time.monotonic() - started, 2)
    return JsonResponse({
        "ok": result.wasSuccessful(),
        "tests_run": result.testsRun,
        "errors": len(result.errors),
        "failures": len(result.failures),
        "duration": duration,
        "output": stream.getvalue(),
    })
