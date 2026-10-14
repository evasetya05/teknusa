import io
import time
import unittest

from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.http import JsonResponse
from django.shortcuts import render
from django.views.decorators.http import require_POST

from agent.briefing import build_briefings, is_briefing_admin
from agent.providers import ProviderError, get_chain, get_config


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
        "enabled": bool(get_chain()),
    })


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
            "error": "LLM mode is 'off' (AGENT_LLM['mode']). Set it to 'local' or 'auto'.",
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
