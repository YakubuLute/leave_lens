"""The backend's `Diagnosis` model must agree with `contracts/` exactly."""

import json
from pathlib import Path
from typing import Any

import pytest
from jsonschema import Draft202012Validator
from jsonschema.protocols import Validator
from pydantic import ValidationError

from leaf_lens_api.domain.diagnosis import Diagnosis

CONTRACTS = Path(__file__).resolve().parents[2] / "contracts"
SCHEMA: dict[str, Any] = json.loads(
    (CONTRACTS / "diagnosis.schema.json").read_text(encoding="utf-8")
)
VALIDATOR: Validator = Draft202012Validator(SCHEMA)

VALID = sorted((CONTRACTS / "fixtures" / "valid").glob("*.json"))
INVALID = sorted((CONTRACTS / "fixtures" / "invalid").glob("*.json"))


def _load(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def test_schema_is_valid_json_schema() -> None:
    Draft202012Validator.check_schema(SCHEMA)


def test_fixtures_exist() -> None:
    assert VALID, "no valid fixtures found"
    assert INVALID, "no invalid fixtures found"


@pytest.mark.parametrize("path", VALID, ids=lambda p: p.stem)
def test_valid_fixture_passes_schema(path: Path) -> None:
    VALIDATOR.validate(_load(path))


@pytest.mark.parametrize("path", VALID, ids=lambda p: p.stem)
def test_valid_fixture_parses_into_model(path: Path) -> None:
    Diagnosis.model_validate(_load(path))


@pytest.mark.parametrize("path", VALID, ids=lambda p: p.stem)
def test_model_output_passes_schema(path: Path) -> None:
    """What the API will send must satisfy the contract, not just what it reads."""
    emitted = Diagnosis.model_validate(_load(path)).model_dump(mode="json")
    VALIDATOR.validate(emitted)


@pytest.mark.parametrize("path", INVALID, ids=lambda p: p.stem)
def test_invalid_fixture_fails_schema(path: Path) -> None:
    assert not VALIDATOR.is_valid(_load(path))


@pytest.mark.parametrize("path", INVALID, ids=lambda p: p.stem)
def test_invalid_fixture_is_rejected_by_model(path: Path) -> None:
    with pytest.raises(ValidationError):
        Diagnosis.model_validate(_load(path))


def test_unknown_fields_are_ignored() -> None:
    """Additive contract changes must not break this reader."""
    data = _load(VALID[0]) | {"added_in_a_future_version": True}
    Diagnosis.model_validate(data)
