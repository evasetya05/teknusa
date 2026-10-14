"""LLM narration with validation, caching and a guaranteed template fallback.

The LLM only rewrites facts we computed. Any output that contains a number that
is not present in those facts is rejected and the template text is used instead.
"""
import hashlib
import logging
import re

from django.core.cache import cache

from agent.providers import ProviderError, get_chain

logger = logging.getLogger(__name__)

TEMPLATE_SOURCE = "template"
CACHE_SECONDS = 6 * 60 * 60
PROVIDER_DOWN_SECONDS = 60
MAX_OUTPUT_CHARS = 600
_NUMBER_RE = re.compile(r"\d[\d.,]*")

PROMPT = (
    "You are a concise business assistant. Rewrite the FACTS below as a short, "
    "clear status update in English, at most 3 sentences. Use ONLY the facts "
    "given. Do not invent, round, or add any numbers. Do not give advice that "
    "is not implied by the facts. Output plain text only.\n\nFACTS:\n{facts}\n"
)


def _numbers(text):
    """Normalised numeric tokens (separators removed) found in text."""
    return {re.sub(r"[.,]", "", token) for token in _NUMBER_RE.findall(text)} - {""}


def build_facts(template_text, alerts):
    lines = [template_text]
    lines.extend(f"- {a.message}" for a in alerts)
    return "\n".join(lines)


def is_valid_output(output, facts):
    if not output or len(output) > MAX_OUTPUT_CHARS:
        return False
    return _numbers(output) <= _numbers(facts)


def narrate(template_text, alerts, providers=None):
    """Return (text, source). ``source`` is a provider name or ``"template"``."""
    chain = get_chain() if providers is None else providers
    if not chain:
        return template_text, TEMPLATE_SOURCE

    facts = build_facts(template_text, alerts)
    prompt = PROMPT.format(facts=facts)

    for provider in chain:
        key = "agent:narr:" + hashlib.sha256(
            f"{provider.name}|{getattr(provider, 'model', '')}|{prompt}".encode()
        ).hexdigest()
        cached = cache.get(key)
        if cached:
            return cached, provider.name
        down_key = f"agent:down:{provider.name}"
        if cache.get(down_key):
            continue
        try:
            output = provider.generate(prompt).strip()
        except ProviderError as exc:
            logger.warning("Narration provider %s failed: %s", provider.name, exc)
            cache.set(down_key, True, PROVIDER_DOWN_SECONDS)
            continue
        if is_valid_output(output, facts):
            cache.set(key, output, CACHE_SECONDS)
            return output, provider.name
        logger.warning("Narration provider %s output rejected by validation", provider.name)

    return template_text, TEMPLATE_SOURCE
