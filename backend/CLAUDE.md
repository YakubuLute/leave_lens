# CLAUDE.md: Backend

Rules for the Leaf Lens **FastAPI service** in `backend/`. Run all commands below from this folder.

The repo-wide rules in the [root CLAUDE.md](../CLAUDE.md) also apply. They cover planning before implementation, the shared contract and git.

**What this service does:** it receives a leaf photo from the app, asks Claude for a diagnosis, and returns a `Diagnosis` that conforms to [`contracts/diagnosis.schema.json`](../contracts/diagnosis.schema.json). It holds the API key so the app never does. See [docs/PLAN.md](../docs/PLAN.md) §2.3.

---

## 1. Structure

```
src/leaf_lens_api/
  main.py          # create_app() factory + module-level `app` for uvicorn
  config.py        # Settings (pydantic-settings), env only
  api/             # routers — thin HTTP layer
  domain/          # Pydantic models + interfaces; no FastAPI/HTTP imports
  services/        # (Phase 4) implementations, e.g. the Claude client
tests/             # pytest, mirrors src/
```

### Layering
- **Dependencies point one way:** `api → domain ← services`.
  - Route handlers parse input, call a service, and return a domain model. Business rules never live in a handler.
  - `domain/` imports nothing from `api/` or `services/`, and nothing from FastAPI.
  - Services implement interfaces (`typing.Protocol`) declared in `domain/`. Handlers receive them through FastAPI dependencies, so tests can swap in fakes.
- **One responsibility per module.** Keep files under about 300 lines.

---

## 2. Code practices

- **Python 3.14** (pinned in `.python-version`). Use modern syntax: `X | None`, `match`, `StrEnum`, `Self`.
- **Typed everywhere.** `pyright` runs in **strict** mode and must report zero errors.
  - No `Any` unless the data really is arbitrary JSON, and then only at the edges.
  - If a third-party library has no types, add its `types-*` stubs. Don't silence the error.
- **Lint and format with `ruff`.** `ruff check` and `ruff format --check` must both be clean. Don't add `# noqa` without a comment explaining why.
- **Pydantic models are the API boundary.**
  - Domain models are `frozen=True`.
  - Response models are explicit, never raw dicts.
- **Config comes only from the environment** (`config.Settings`).
  - Never hard-code URLs, thresholds or keys.
  - Secrets are `SecretStr`.
  - Only `.env.example` is tracked. `.env` is git-ignored.
- **Errors:**
  - Raise typed exceptions from services and map them to HTTP responses in one place.
  - Never return raw exception text or stack traces to clients.
  - Never log image bytes or secrets.
- **Privacy:** don't store uploaded images by default (PLAN §2.3).

### Contract
- `domain/diagnosis.py` mirrors `contracts/diagnosis.schema.json`, and the schema wins any disagreement.
- `tests/test_contract.py` must keep passing. It checks that:
  - Every valid fixture parses.
  - Every invalid fixture is rejected.
  - Whatever the model emits passes the schema.
- To change the contract, follow the [contract rules](../CLAUDE.md#3-shared-contract) and [contracts/README.md](../contracts/README.md).

### Testing
- `pytest`. Use `fastapi.testclient.TestClient` against `create_app(Settings(...))`, so each test gets a fresh app.
- Never call the real Claude API in tests. Fake the service behind its `Protocol`.
- A bug fix comes with a test that reproduces it.

---

## 3. Commands

```bash
uv sync                                          # install deps (creates .venv)
uv run uvicorn leaf_lens_api.main:app --reload   # run locally on :8000
uv run ruff check .                              # lint
uv run ruff format .                             # format
uv run pyright                                   # type-check (strict)
uv run pytest                                    # test
uv add <pkg>  /  uv add --dev <pkg>              # add a dependency
```

Every commit that touches `backend/` or `contracts/` must pass `ruff check`, `ruff format --check`, `pyright` and `pytest`.
