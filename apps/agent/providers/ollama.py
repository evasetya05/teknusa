"""Local provider: Ollama HTTP API (e.g. llama3.2:1b). Uses only the standard library."""
import json
import urllib.error
import urllib.request

from .base import NarrationProvider, ProviderError


class OllamaProvider(NarrationProvider):
    name = "ollama"

    def __init__(self, url="http://ollama:11434", model="llama3.2:1b", timeout=20, max_tokens=160):
        self.url = url.rstrip("/")
        self.model = model
        self.timeout = timeout
        self.max_tokens = max_tokens

    def generate(self, prompt):
        payload = json.dumps(
            {
                "model": self.model,
                "prompt": prompt,
                "stream": False,
                "options": {"temperature": 0.2, "num_predict": self.max_tokens},
            }
        ).encode("utf-8")
        request = urllib.request.Request(
            f"{self.url}/api/generate",
            data=payload,
            headers={"Content-Type": "application/json"},
            method="POST",
        )
        try:
            with urllib.request.urlopen(request, timeout=self.timeout) as response:
                body = json.loads(response.read().decode("utf-8"))
        except (urllib.error.URLError, TimeoutError, OSError, ValueError) as exc:
            raise ProviderError(f"ollama request failed: {exc}") from exc

        if not isinstance(body, dict):
            raise ProviderError("ollama returned an unexpected response format")
        raw = body.get("response") or ""
        if not isinstance(raw, str):
            raise ProviderError("ollama returned a non-text response")
        text = raw.strip()
        if not text:
            raise ProviderError("ollama returned an empty response")
        return text
