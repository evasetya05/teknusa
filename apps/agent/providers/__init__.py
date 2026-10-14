"""Provider selection from settings.AGENT_LLM.

Modes:
  off   - no LLM; template text only (default)
  local - Ollama only
  auto  - ordered chain; external providers are added in a later phase
"""
from django.conf import settings

from .base import NarrationProvider, ProviderError  # noqa: F401
from .ollama import OllamaProvider

DEFAULT_CONFIG = {
    "mode": "off",
    "local": {"url": "http://ollama:11434", "model": "llama3.2:1b", "timeout": 20},
}


def get_config():
    config = dict(DEFAULT_CONFIG)
    config.update(getattr(settings, "AGENT_LLM", {}) or {})
    local = dict(DEFAULT_CONFIG["local"])
    local.update(config.get("local") or {})
    config["local"] = local
    return config


def get_chain():
    """Return providers to try, in order. Empty list means template only."""
    config = get_config()
    mode = (config.get("mode") or "off").lower()
    if mode in ("local", "auto"):
        local = config["local"]
        return [
            OllamaProvider(
                url=local["url"], model=local["model"], timeout=local["timeout"]
            )
        ]
    return []
