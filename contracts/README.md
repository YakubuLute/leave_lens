# Contracts

The source of truth for data the **app** and the **backend** exchange. Neither side defines these shapes on its own. Both conform to the schemas here, and both test against the same fixtures.

| File | What |
|---|---|
| `diagnosis.schema.json` | The `Diagnosis` result (JSON Schema 2020-12). Returned by `POST /v1/diagnose` and produced on-device. |
| `fixtures/valid/*.json` | One valid example per status. Every reader **must** accept all of them. |
| `fixtures/invalid/*.json` | Examples that **must** be rejected. Each file name says which rule it breaks. |

## Rules for `Diagnosis`

- **Every field is always present.** `null` means it doesn't apply.
- **Status rules:**
  - `diseased` requires `crop` and `disease`.
  - `healthy` and `not_a_leaf` have no `disease`, `pathogen` or `severity`.
  - `not_a_leaf` also has no `crop` and no `treatment`.
- **Readers ignore unknown fields.** This is what makes adding a field safe.

## Who tests what

| Side | Test | Status |
|---|---|---|
| Backend | `backend/tests/test_contract.py`: valid fixtures pass the schema and parse into the Pydantic model; invalid fixtures fail both | Active |
| App | Dart `Diagnosis` model tests parse every valid fixture | Added with the model in Phase 1 |

## Changing a contract

1. **Decide whether it's breaking.**
   - **Breaking:** removing or renaming a field, changing a type, tightening a rule, or adding a required field.
   - **Non-breaking:** adding an optional field, or adding an enum value that clients handle with a fallback.
2. In **one PR**:
   - Update the schema.
   - Update or add fixtures, including an invalid one for any new rule.
   - Update the backend models and the app models.
3. **For a breaking change:**
   - Bump the version in `$id` (`…:v1` → `…:v2`) and serve it at a new path (`/v2/diagnose`).
   - Keep `/v1` working until old app versions are retired. Installed apps can't be forced to update.
4. Run the checks for **both** `app/` and `backend/`. See the root [CLAUDE.md](../CLAUDE.md) §4.
