"""Provider selection from settings.AGENT_LLM, optionally overridden manually.

Modes:
  off    - no LLM; template text only (default)
  local  - Ollama only
  gemini - Google Gemini API only
  auto   - ordered chain: local Ollama first, then Gemini (if an API key is set)

Precedence: defaults < settings.AGENT_LLM (environment) < manual override saved
from the /agent/llm/ page (see ``runtime``). A Gemini key saved from the UI
(stored encrypted) wins over GEMINI_API_KEY in the environment.
"""
from django.conf import settings

from .base import NarrationProvider, ProviderError  # noqa: F401
from .gemini import GeminiProvider
from .ollama import OllamaProvider
from .runtime import get_stored_api_key, load_override

DEFAULT_CONFIG = {
    "mode": "off",
    "local": {"url": "http://ollama:11434", "model": "llama3.2:1b", "timeout": 20},
    "gemini": {"api_key": "", "model": "gemini-3.8-flash", "timeout": 30},
}


def get_config():
    config = dict(DEFAULT_CONFIG)
    config.update(getattr(settings, "AGENT_LLM", {}) or {})
    override = load_override()
    if override.get("mode"):
        config["mode"] = override["mode"]
    for section in ("local", "gemini"):
        merged = dict(DEFAULT_CONFIG[section])
        merged.update(config.get(section) or {})
        for key, value in (override.get(section) or {}).items():
            if key not in ("api_key", "api_key_enc"):
                merged[key] = value
        config[section] = merged
    stored_key = get_stored_api_key()
    if stored_key:
        config["gemini"]["api_key"] = stored_key
    config["gemini"]["key_source"] = (
        "ui" if stored_key else ("env" if config["gemini"].get("api_key") else "none")
    )
    return config


def get_chain():
    """Return providers to try, in order. Empty list means template only."""
    config = get_config()
    mode = (config.get("mode") or "off").lower()
    chain = []
    if mode in ("local", "auto"):
        local = config["local"]
        chain.append(
            OllamaProvider(
                url=local["url"], model=local["model"], timeout=local["timeout"]
            )
        )
    if mode in ("gemini", "auto"):
        gem = config["gemini"]
        # In auto mode a missing key just means Gemini is skipped.
        if mode == "gemini" or gem.get("api_key"):
            chain.append(
                GeminiProvider(
                    api_key=gem.get("api_key"), model=gem["model"], timeout=gem["timeout"]
                )
            )
    return chain
