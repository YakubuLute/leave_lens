from fastapi.testclient import TestClient

from leaf_lens_api import __version__
from leaf_lens_api.config import Settings
from leaf_lens_api.main import create_app


def test_health_reports_ok_and_version() -> None:
    client = TestClient(create_app(Settings()))

    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok", "version": __version__}


def test_create_app_uses_given_settings() -> None:
    settings = Settings(environment="staging")

    app = create_app(settings)

    assert app.state.settings is settings
