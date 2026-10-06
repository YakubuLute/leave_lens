"""Settings, read only from the environment (or a local, untracked `.env`)."""

from functools import lru_cache
from typing import Literal

from pydantic import SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Runtime configuration. Never hard-code secrets; see `.env.example`."""

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    environment: Literal["local", "staging", "production"] = "local"

    # Optional until `/v1/diagnose` lands in Phase 4; required from then on.
    anthropic_api_key: SecretStr | None = None


@lru_cache
def get_settings() -> Settings:
    """Process-wide settings, loaded once."""
    return Settings()
