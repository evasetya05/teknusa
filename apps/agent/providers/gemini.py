"""API provider: Google Gemini (generateContent). Uses only the standard library.

The API key is sent in a header (never in the URL) so it cannot leak into logs
or exception messages.
"""
import json
import urllib.error
import urllib.request

from .base import NarrationProvider, ProviderError

BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models"


class GeminiProvider(NarrationProvider):
    name = "gemini"

    def __init__(self, api_key, model="gemini-2.5-flash", timeout=30, max_tokens=400):
        self.api_key = api_key
        self.model = model
        self.timeout = timeout
        self.max_tokens = max_tokens

    def generate(self, prompt):
        if not self.api_key:
            raise ProviderError("gemini API key is not configured (GEMINI_API_KEY)")
        generation_config = {"temperature": 0.2, "maxOutputTokens": self.max_tokens}
        if "flash" in self.model:
            # Avoid hidden "thinking" tokens consuming the small output budget.
            generation_config["thinkingConfig"] = {"thinkingBudget": 0}
        payload = json.dumps(
            {
                "contents": [{"parts": [{"text": prompt}]}],
                "generationConfig": generation_config,
            }
        ).encode("utf-8")
        request = urllib.request.Request(
            f"{BASE_URL}/{self.model}:generateContent",
            data=payload,
            headers={"Content-Type": "application/json", "x-goog-api-key": self.api_key},
            method="POST",
        )
        try:
            with urllib.request.urlopen(request, timeout=self.timeout) as response:
                body = json.loads(response.read().decode("utf-8"))
        except urllib.error.HTTPError as exc:
            raise ProviderError(f"gemini HTTP error {exc.code}") from exc
        except (urllib.error.URLError, TimeoutError, OSError, ValueError) as exc:
            raise ProviderError(f"gemini request failed: {exc}") from exc

        try:
            parts = body["candidates"][0]["content"]["parts"]
            text = "".join(p.get("text", "") for p in parts).strip()
        except (KeyError, IndexError, TypeError, AttributeError) as exc:
            raise ProviderError("gemini returned an unexpected response format") from exc
        if not text:
            raise ProviderError("gemini returned an empty response")
        return text
