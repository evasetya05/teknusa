"""Narration providers. Each takes a prompt and returns text, or raises ProviderError."""


class ProviderError(Exception):
    """Raised when a provider cannot produce usable text."""


class NarrationProvider:
    name = "base"

    def generate(self, prompt):
        raise NotImplementedError
