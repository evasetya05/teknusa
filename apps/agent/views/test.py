import io
import time
import unittest

from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.http import JsonResponse
from django.views.decorators.http import require_POST

from agent.briefing import is_briefing_admin
from agent.providers import GeminiProvider, OllamaProvider, ProviderError, get_chain, get_config


@login_required
@require_POST
def llm_test_view(request):
    """Run a real generate() call against each configured provider, or a targeted provider."""
    if not is_briefing_admin(request.user):
        raise PermissionDenied
    target = (request.POST.get("provider") or "").strip().lower()
    config = get_config()

    if target == "gemini":
        gem = config["gemini"]
        # Allow testing an unsaved key typed into the form, or fall back to stored key
        input_key = str(request.POST.get("gemini_api_key") or "").strip().strip("'\"")
        api_key = input_key or gem.get("api_key")
        model = str(request.POST.get("gemini_model") or "").strip() or gem.get("model") or "gemini-1.5-flash"
        raw_timeout = request.POST.get("gemini_timeout")
        try:
            timeout = int(raw_timeout) if raw_timeout else gem.get("timeout", 30)
        except (ValueError, TypeError):
            timeout = gem.get("timeout", 30)

        if not api_key:
            return JsonResponse({
                "ok": False,
                "error": "API Key Gemini belum diisi. Masukkan API key pada kolom Gemini lalu klik Simpan atau Test.",
            })
        chain = [GeminiProvider(api_key=api_key, model=model, timeout=timeout)]
    elif target == "local":
        loc = config["local"]
        url = str(request.POST.get("local_url") or "").strip() or loc.get("url")
        model = str(request.POST.get("local_model") or "").strip() or loc.get("model")
        raw_timeout = request.POST.get("local_timeout")
        try:
            timeout = int(raw_timeout) if raw_timeout else loc.get("timeout", 20)
        except (ValueError, TypeError):
            timeout = loc.get("timeout", 20)
        chain = [OllamaProvider(url=url, model=model, timeout=timeout)]
    else:
        chain = get_chain()
        if not chain:
            return JsonResponse({
                "ok": False,
                "error": "LLM mode saat ini 'off'. Pilih mode lain di form (Lokal, Gemini, atau Auto) lalu Simpan.",
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

