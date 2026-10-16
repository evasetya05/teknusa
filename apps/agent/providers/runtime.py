"""Manual, persistent LLM selection made from the /agent/llm/ page.

Stored as a small JSON file (no DB migration needed, shared by all containers
that mount the project). A Gemini API key entered in the UI is stored encrypted
(Fernet, key derived from Django's SECRET_KEY) and the file is chmod 0600; the
key is never rendered back to the browser. Changing SECRET_KEY makes the stored
key undecryptable, in which case it is treated as unset.
"""
import base64
import hashlib
import json
import os
import re
import tempfile

from cryptography.fernet import Fernet, InvalidToken
from django.conf import settings

MODES = ("off", "local", "gemini", "auto")
_MODEL_RE = re.compile(r"^[A-Za-z0-9._:\-/]{1,100}$")
_KEY_RE = re.compile(r"^[A-Za-z0-9_\-]{20,200}$")


def _fernet():
    digest = hashlib.sha256(("agent-llm|" + settings.SECRET_KEY).encode()).digest()
    return Fernet(base64.urlsafe_b64encode(digest))


def get_stored_api_key():
    """Decrypted UI-supplied Gemini key, or '' if none/undecryptable."""
    token = (load_override().get("gemini") or {}).get("api_key_enc")
    if not token:
        return ""
    try:
        return _fernet().decrypt(token.encode()).decode()
    except (InvalidToken, ValueError):
        return ""


def key_hint(key):
    return "…" + key[-4:] if key else ""


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
    cleaned = {
        "mode": mode,
        "local": {"url": url.rstrip("/"), "model": local_model, "timeout": local_timeout},
        "gemini": {"model": gemini_model, "timeout": gemini_timeout},
    }
    new_key = str(data.get("gemini_api_key", "")).strip().strip("'\"")
    if new_key:
        if not _KEY_RE.match(new_key):
            raise ValueError("Format API key Gemini tidak valid. Pastikan tidak ada spasi atau tanda kutip.")
        cleaned["_new_api_key"] = new_key
    elif str(data.get("clear_gemini_key", "")).lower() in ("1", "on", "true"):
        cleaned["_clear_api_key"] = True
    return cleaned


def save_override(cleaned):
    cleaned = dict(cleaned)
    new_key = cleaned.pop("_new_api_key", None)
    clear_key = cleaned.pop("_clear_api_key", False)
    existing = (load_override().get("gemini") or {}).get("api_key_enc")
    if new_key:
        cleaned["gemini"]["api_key_enc"] = _fernet().encrypt(new_key.encode()).decode()
    elif existing and not clear_key:
        cleaned["gemini"]["api_key_enc"] = existing
    path = override_path()
    directory = os.path.dirname(path)
    os.makedirs(directory, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=directory, suffix=".tmp")  # mkstemp creates 0600
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
