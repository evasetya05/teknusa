import json
from unittest import mock

from django.core.cache import cache
from django.test import SimpleTestCase, override_settings

from agent.llm_narrator import (
    TEMPLATE_SOURCE,
    build_facts,
    is_valid_output,
    narrate,
)
from agent.providers import ProviderError, get_chain
from agent.providers.base import NarrationProvider
from agent.providers.ollama import OllamaProvider
from agent.rules import Alert

TEMPLATE = "Alpha: net profit for 2026-10 is Rp 6,000,000 (revenue Rp 10,000,000, expenses Rp 4,000,000)."
ALERTS = [Alert("warning", "unposted", "3 journal(s) are waiting to be posted.")]


class FakeProvider(NarrationProvider):
    name = "fake"

    def __init__(self, output=None, error=None):
        self.output = output
        self.error = error
        self.calls = 0

    def generate(self, prompt):
        self.calls += 1
        if self.error:
            raise self.error
        return self.output


class ValidationTests(SimpleTestCase):
    def setUp(self):
        self.facts = build_facts(TEMPLATE, ALERTS)

    def test_accepts_numbers_from_facts_in_any_format(self):
        self.assertTrue(is_valid_output("Net profit is Rp 6000000 and 3 journals wait.", self.facts))

    def test_rejects_invented_numbers(self):
        self.assertFalse(is_valid_output("Net profit is Rp 7,500,000.", self.facts))

    def test_rejects_empty_and_too_long(self):
        self.assertFalse(is_valid_output("", self.facts))
        self.assertFalse(is_valid_output("x" * 700, self.facts))


class NarrateTests(SimpleTestCase):
    def setUp(self):
        cache.clear()

    def test_no_providers_returns_template(self):
        self.assertEqual(narrate(TEMPLATE, ALERTS, providers=[]), (TEMPLATE, TEMPLATE_SOURCE))

    def test_valid_output_is_used_and_cached(self):
        provider = FakeProvider(output="Profit is Rp 6,000,000 this month.")
        first = narrate(TEMPLATE, ALERTS, providers=[provider])
        second = narrate(TEMPLATE, ALERTS, providers=[provider])
        self.assertEqual(first, ("Profit is Rp 6,000,000 this month.", "fake"))
        self.assertEqual(second, first)
        self.assertEqual(provider.calls, 1)

    def test_invented_number_falls_back_to_template(self):
        provider = FakeProvider(output="Profit is Rp 9,999,999.")
        self.assertEqual(narrate(TEMPLATE, ALERTS, providers=[provider]), (TEMPLATE, TEMPLATE_SOURCE))

    def test_provider_error_falls_back_and_is_skipped_briefly(self):
        provider = FakeProvider(error=ProviderError("down"))
        self.assertEqual(narrate(TEMPLATE, ALERTS, providers=[provider]), (TEMPLATE, TEMPLATE_SOURCE))
        narrate(TEMPLATE, ALERTS, providers=[provider])
        self.assertEqual(provider.calls, 1)

    def test_chain_tries_next_provider(self):
        bad = FakeProvider(error=ProviderError("down"))
        bad.name = "bad"
        good = FakeProvider(output="Profit is Rp 6,000,000.")
        good.name = "good"
        self.assertEqual(narrate(TEMPLATE, ALERTS, providers=[bad, good])[1], "good")


class ProviderConfigTests(SimpleTestCase):
    @override_settings(AGENT_LLM={"mode": "off"})
    def test_off_has_no_providers(self):
        self.assertEqual(get_chain(), [])

    @override_settings(AGENT_LLM={"mode": "local", "local": {"model": "llama3.2:1b", "url": "http://x:1"}})
    def test_local_builds_ollama(self):
        chain = get_chain()
        self.assertEqual(len(chain), 1)
        self.assertIsInstance(chain[0], OllamaProvider)
        self.assertEqual(chain[0].url, "http://x:1")

    def test_default_is_off(self):
        with override_settings(AGENT_LLM={}):
            self.assertEqual(get_chain(), [])


class OllamaProviderTests(SimpleTestCase):
    def _response(self, body):
        resp = mock.MagicMock()
        resp.read.return_value = json.dumps(body).encode()
        resp.__enter__.return_value = resp
        return resp

    def test_returns_text(self):
        with mock.patch("urllib.request.urlopen", return_value=self._response({"response": " Hello "})):
            self.assertEqual(OllamaProvider().generate("p"), "Hello")

    def test_empty_response_raises(self):
        with mock.patch("urllib.request.urlopen", return_value=self._response({"response": ""})):
            with self.assertRaises(ProviderError):
                OllamaProvider().generate("p")

    def test_network_error_raises(self):
        import urllib.error

        with mock.patch("urllib.request.urlopen", side_effect=urllib.error.URLError("refused")):
            with self.assertRaises(ProviderError):
                OllamaProvider().generate("p")

    def test_timeout_raises(self):
        with mock.patch("urllib.request.urlopen", side_effect=TimeoutError("timed out")):
            with self.assertRaises(ProviderError):
                OllamaProvider().generate("p")

    def test_http_error_raises(self):
        import urllib.error

        err = urllib.error.HTTPError("http://x", 500, "boom", {}, None)
        with mock.patch("urllib.request.urlopen", side_effect=err):
            with self.assertRaises(ProviderError):
                OllamaProvider().generate("p")

    def test_invalid_json_raises(self):
        resp = mock.MagicMock()
        resp.read.return_value = b"not json"
        resp.__enter__.return_value = resp
        with mock.patch("urllib.request.urlopen", return_value=resp):
            with self.assertRaises(ProviderError):
                OllamaProvider().generate("p")

    def test_non_object_json_raises(self):
        with mock.patch("urllib.request.urlopen", return_value=self._response(["x"])):
            with self.assertRaises(ProviderError):
                OllamaProvider().generate("p")

    def test_request_targets_generate_with_model_and_no_stream(self):
        with mock.patch("urllib.request.urlopen", return_value=self._response({"response": "ok"})) as urlopen:
            OllamaProvider(url="http://h:1/", model="m1", timeout=7).generate("p")
        request = urlopen.call_args.args[0]
        self.assertEqual(request.full_url, "http://h:1/api/generate")
        self.assertEqual(urlopen.call_args.kwargs["timeout"], 7)
        payload = json.loads(request.data)
        self.assertEqual(payload["model"], "m1")
        self.assertIs(payload["stream"], False)


class AutoModeAndEnvTests(SimpleTestCase):
    @override_settings(AGENT_LLM={"mode": "auto", "local": {"url": "http://x:1", "model": "m2", "timeout": 5}})
    def test_auto_builds_ollama_with_config(self):
        chain = get_chain()
        self.assertEqual(len(chain), 1)
        self.assertEqual((chain[0].url, chain[0].model, chain[0].timeout), ("http://x:1", "m2", 5))

    def test_auto_falls_back_to_template_when_provider_fails(self):
        cache.clear()
        provider = FakeProvider(error=ProviderError("down"))
        self.assertEqual(narrate(TEMPLATE, ALERTS, providers=[provider]), (TEMPLATE, TEMPLATE_SOURCE))

    def test_settings_read_environment(self):
        import importlib.util
        import os

        from django.conf import settings as dj_settings

        env = {"AGENT_LLM_MODE": "local", "OLLAMA_URL": "http://172.18.0.1:11434", "OLLAMA_MODEL": "llama3.2:1b"}
        spec = importlib.util.find_spec(dj_settings.SETTINGS_MODULE)
        module = importlib.util.module_from_spec(spec)
        with mock.patch.dict(os.environ, env):
            spec.loader.exec_module(module)
        self.assertEqual(module.AGENT_LLM["mode"], "local")
        self.assertEqual(module.AGENT_LLM["local"]["url"], "http://172.18.0.1:11434")
        self.assertEqual(module.AGENT_LLM["local"]["model"], "llama3.2:1b")


class LiveOllamaIntegrationTests(SimpleTestCase):
    """Real call to Ollama (no mocks). Skipped when the configured server is unreachable."""

    def setUp(self):
        import urllib.request

        from agent.providers import get_config

        local = get_config()["local"]
        self.provider = OllamaProvider(url=local["url"], model=local["model"], timeout=max(local["timeout"], 60))
        try:
            urllib.request.urlopen(f"{self.provider.url}/api/version", timeout=3).read()
        except Exception as exc:
            self.skipTest(f"Ollama not reachable at {self.provider.url}: {exc}")

    def test_real_generate_returns_text(self):
        text = self.provider.generate("Balas dengan satu kata: OK")
        self.assertTrue(text.strip())
