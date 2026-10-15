"""Manual, persistent LLM selection made from the /agent/llm/ page.

Stored as a small JSON file (no DB migration needed, shared by all containers
that mount the project). It never contains secrets: API keys stay in the
environment.
"""
import json
import os
import re
import tempfile

from django.conf import settings

MODES = ("off", "local", "gemini", "auto")
_MODEL_RE = re.compile(r"^[A-Za-z0-9._:\-/]{1,100}$")


def override_path():
    default = os.path.join(str(settings.BASE_DIR), "private", "agent_llm.json")
    return getattr(settings, "AGENT_LLM_OVERRIDE_FILE", None) or default


def load_override():
    try:
        with open(override_path(), encoding="utf-8") as fh:
            data = json.load(fh)
    except (OSError, ValueError):
        return {}
    return data if isinstance(data, dict) else {}


def clean_override(data):
    """Validate user input; return a sanitized dict or raise ValueError."""
    mode = str(data.get("mode", "")).lower()
    if mode not in MODES:
        raise ValueError("Mode tidak valid.")
    url = str(data.get("local_url", "")).strip()
    if not re.match(r"^https?://[^\s/]+(:\d+)?/?$", url):
        raise ValueError("URL Ollama harus berformat http(s)://host:port.")
    local_model = str(data.get("local_model", "")).strip()
    gemini_model = str(data.get("gemini_model", "")).strip()
    if not _MODEL_RE.match(local_model) or not _MODEL_RE.match(gemini_model):
        raise ValueError("Nama model tidak valid.")
    try:
        local_timeout = int(data.get("local_timeout"))
        gemini_timeout = int(data.get("gemini_timeout"))
    except (TypeError, ValueError):
        raise ValueError("Timeout harus berupa angka.")
    if not (1 <= local_timeout <= 300 and 1 <= gemini_timeout <= 300):
        raise ValueError("Timeout harus antara 1 dan 300 detik.")
    return {
        "mode": mode,
        "local": {"url": url.rstrip("/"), "model": local_model, "timeout": local_timeout},
        "gemini": {"model": gemini_model, "timeout": gemini_timeout},
    }


def save_override(cleaned):
    path = override_path()
    directory = os.path.dirname(path)
    os.makedirs(directory, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=directory, suffix=".tmp")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as fh:
            json.dump(cleaned, fh)
        os.replace(tmp, path)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise


def clear_override():
    try:
        os.unlink(override_path())
    except FileNotFoundError:
        pass
