"""The `Diagnosis` result.

Mirrors `contracts/diagnosis.schema.json` — the schema is the source of truth.
`tests/test_contract.py` checks that every valid fixture parses here, every
invalid one is rejected, and everything this model emits passes the schema.
"""

from enum import StrEnum
from typing import Annotated, Self

from pydantic import BaseModel, ConfigDict, Field, StringConstraints, model_validator

NonEmptyStr = Annotated[str, StringConstraints(min_length=1)]


class DiagnosisStatus(StrEnum):
    """Overall outcome of a scan."""

    HEALTHY = "healthy"
    DISEASED = "diseased"
    UNCERTAIN = "uncertain"
    NOT_A_LEAF = "not_a_leaf"


class Severity(StrEnum):
    """How advanced a disease is."""

    MILD = "mild"
    MODERATE = "moderate"
    SEVERE = "severe"


class DiagnosisSource(StrEnum):
    """Which engine produced the result."""

    ON_DEVICE = "on_device"
    CLOUD = "cloud"


class Treatment(BaseModel):
    """Guidance grouped by approach. Lists may be empty."""

    model_config = ConfigDict(frozen=True)

    immediate: list[NonEmptyStr]
    organic: list[NonEmptyStr]
    chemical: list[NonEmptyStr]
    prevention: list[NonEmptyStr]


class Diagnosis(BaseModel):
    """Result of analysing one leaf photo.

    Every field is required but may be `None`, matching the contract's
    "always present, null when not applicable" rule. Unknown fields are
    ignored so additive contract changes stay non-breaking.
    """

    model_config = ConfigDict(frozen=True, extra="ignore")

    status: DiagnosisStatus
    crop: NonEmptyStr | None
    disease: NonEmptyStr | None
    pathogen: NonEmptyStr | None
    confidence: Annotated[float, Field(ge=0, le=1)]
    severity: Severity | None
    source: DiagnosisSource
    symptoms: list[NonEmptyStr]
    treatment: Treatment | None
    disclaimer: NonEmptyStr

    @model_validator(mode="after")
    def _check_status_rules(self) -> Self:
        """Enforce the schema's per-status rules (its `allOf` block)."""
        match self.status:
            case DiagnosisStatus.DISEASED:
                if self.disease is None or self.crop is None:
                    msg = "a diseased result needs both crop and disease"
                    raise ValueError(msg)
            case DiagnosisStatus.HEALTHY | DiagnosisStatus.NOT_A_LEAF:
                if any(f is not None for f in (self.disease, self.pathogen)):
                    msg = f"a {self.status} result cannot name a disease or pathogen"
                    raise ValueError(msg)
                if self.severity is not None:
                    msg = f"a {self.status} result cannot have a severity"
                    raise ValueError(msg)
            case DiagnosisStatus.UNCERTAIN:
                pass
        if self.status is DiagnosisStatus.NOT_A_LEAF and (
            self.crop is not None or self.treatment is not None
        ):
            msg = "a not_a_leaf result cannot have a crop or treatment"
            raise ValueError(msg)
        return self
