"""ASGI entry point: `uvicorn leaf_lens_api.main:app`."""

from fastapi import FastAPI

from leaf_lens_api import __version__
from leaf_lens_api.api import health
from leaf_lens_api.config import Settings, get_settings


def create_app(settings: Settings | None = None) -> FastAPI:
    """Build the application. Tests pass their own `settings`."""
    app = FastAPI(title="Leaf Lens API", version=__version__)
    app.state.settings = settings or get_settings()
    app.include_router(health.router)
    return app


app = create_app()
