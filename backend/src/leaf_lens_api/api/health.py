"""Liveness endpoint for the hosting platform and uptime checks."""

from typing import Literal

from fastapi import APIRouter
from pydantic import BaseModel

from leaf_lens_api import __version__

router = APIRouter(tags=["health"])


class HealthResponse(BaseModel):
    """Body of `GET /health`."""

    status: Literal["ok"]
    version: str


@router.get("/health")
def health() -> HealthResponse:
    """Report that the service is up, and which version is running."""
    return HealthResponse(status="ok", version=__version__)
