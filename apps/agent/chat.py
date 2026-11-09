"""Dashboard chat: answer questions about the briefing reports.

All figures come from the deterministic collectors/templates (Python). The LLM
only phrases an answer from those FACTS; any answer containing a number that is
not in the facts (or the user's own question) is rejected and a safe fallback
is returned. Nothing is persisted: history lives in the browser and is passed
back with each request.
"""
import logging

from django.core.cache import cache

from agent.collectors.finance import collect_finance
from agent.collectors.kanban import collect_board
from agent.collectors.leads import collect_leads
from agent.briefing import resolve_entities
from agent.llm_narrator import MAX_OUTPUT_CHARS, _numbers, build_facts
from agent.narrator import narrate_board, narrate_finance, narrate_leads
from agent.providers import ProviderError, get_chain
from agent.rules import finance_alerts, kanban_alerts, leads_alerts
from kanban.models import Board

logger = logging.getLogger(__name__)

MAX_QUESTION_CHARS = 500
MAX_HISTORY_TURNS = 6
MAX_FACTS_CHARS = 4000
MAX_ANSWER_CHARS = 900
RATE_LIMIT = 20            # requests per user per minute
RATE_WINDOW_SECONDS = 60

SOURCE_FALLBACK = "fallback"

PROMPT = (
    "You are the TekNusa business report assistant. Answer user questions in English, "
    "concise (maximum 4 sentences), strictly based ONLY on the FACTS below. "
    "Do not invent, round, recalculate, or add any numbers. "
    "If the answer is not present in the facts, state that the data is not available. "
    "Output plain text only.\n\nFACTS:\n{facts}\n\n"
    "{history}QUESTION: {question}\nANSWER:"
)


def build_chat_facts(session_entity_id="all", today=None):
    """Deterministic fact sheet (template text + alerts) for the dashboard reports."""
    entities = resolve_entities(session_entity_id)
    blocks = []
    for entity in entities:
        metrics = collect_finance(entity, today=today)
        alerts = finance_alerts(metrics)
        blocks.append(build_facts(narrate_finance(entity.name, metrics, alerts), alerts))
        for change in metrics["expense_changes"][:3]:
            blocks.append(
                f"- Expense {change['account']}: this month Rp {change['current']:,.0f}, "
                f"last month Rp {change['previous']:,.0f}."
            )
    for board in Board.objects.filter(entity__in=entities).order_by("name"):
        metrics = collect_board(board, today=today)
        alerts = kanban_alerts(metrics)
        blocks.append(build_facts(narrate_board(metrics, alerts), alerts))
    for entity in entities:
        leads_metrics = collect_leads(entity, today=today)
        l_alerts = leads_alerts(leads_metrics)
        blocks.append(build_facts(narrate_leads(entity.name, leads_metrics, l_alerts), l_alerts))
        for lead in leads_metrics["top_leads"][:2]:
            company_str = f" ({lead['company']})" if lead.get("company") else ""
            blocks.append(
                f"- Priority lead ({entity.name}): {lead['name']}{company_str}, "
                f"status {lead['status']}, value Rp {lead['estimated_value']:,.0f}."
            )
    return "\n".join(blocks)[:MAX_FACTS_CHARS]


def clean_history(history):
    """Keep the last few well-formed turns; drop anything else."""
    cleaned = []
    for turn in history if isinstance(history, list) else []:
        if not isinstance(turn, dict):
            continue
        role, text = turn.get("role"), turn.get("text")
        if role in ("user", "assistant") and isinstance(text, str) and text.strip():
            cleaned.append({"role": role, "text": text.strip()[:MAX_QUESTION_CHARS]})
    return cleaned[-MAX_HISTORY_TURNS:]


def _format_history(history):
    if not history:
        return ""
    lines = [
        ("User: " if t["role"] == "user" else "Assistant: ") + t["text"] for t in history
    ]
    return "HISTORY:\n" + "\n".join(lines) + "\n\n"


def is_valid_answer(answer, facts, question, history=()):
    if not answer or len(answer) > MAX_ANSWER_CHARS:
        return False
    allowed = _numbers(facts) | _numbers(question)
    for turn in history:
        if turn["role"] == "user":
            allowed |= _numbers(turn["text"])
    return _numbers(answer) <= allowed


def rate_limited(user_id):
    key = f"agent:chat:rate:{user_id}"
    cache.add(key, 0, RATE_WINDOW_SECONDS)
    try:
        return cache.incr(key) > RATE_LIMIT
    except ValueError:  # key expired between add and incr
        cache.set(key, 1, RATE_WINDOW_SECONDS)
        return False


def answer_question(question, history=None, facts=None, providers=None, session_entity_id="all"):
    """Return ``{"answer", "source"}``. ``source`` is a provider name or ``"fallback"``."""
    question = (question or "").strip()[:MAX_QUESTION_CHARS]
    history = clean_history(history)
    chain = get_chain() if providers is None else providers
    try:
        facts = build_chat_facts(session_entity_id=session_entity_id) if facts is None else facts
    except Exception as exc:
        logger.exception("Error building chat facts: %s", exc)
        facts = "Report data is currently unavailable."

    if not chain:
        return {
            "answer": "AI Agent is currently disabled (off mode). Enable it on the Agent AI & LLM page. "
                      "Current report summary:\n" + facts,
            "source": SOURCE_FALLBACK,
        }

    prompt = PROMPT.format(facts=facts, history=_format_history(history), question=question)
    for provider in chain:
        try:
            output = provider.generate(prompt).strip()
        except ProviderError as exc:
            logger.warning("Chat provider %s failed: %s", provider.name, exc)
            continue
        if is_valid_answer(output, facts, question, history):
            return {"answer": output, "source": provider.name}
        logger.warning("Chat provider %s output rejected by validation", provider.name)

    return {
        "answer": "Sorry, I cannot answer safely right now (AI provider is unavailable or returned "
                  "unverified figures). Current report summary:\n" + facts,
        "source": SOURCE_FALLBACK,
    }
