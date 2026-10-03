# Leaf Lens API

The FastAPI service behind Leaf Lens's cloud diagnosis. The app sends it a leaf photo when the on-device model isn't confident. The service asks Claude for a diagnosis and returns a [`Diagnosis`](../contracts/diagnosis.schema.json).

> **Status: skeleton.** Only `GET /health` exists so far. `POST /v1/diagnose` arrives in Phase 4 (see [docs/PLAN.md](../docs/PLAN.md)).

## Setup

You need [uv](https://docs.astral.sh/uv/). It installs Python 3.14 for you if it's missing.

```bash
uv sync
```

```bash
cp .env.example .env
```

## Run

```bash
uv run uvicorn leaf_lens_api.main:app --reload
```

- Health check: http://localhost:8000/health
- Interactive API docs: http://localhost:8000/docs

## Checks

```bash
uv run ruff check . && uv run ruff format --check . && uv run pyright && uv run pytest
```

CI runs the same checks on every push or PR that touches `backend/` or `contracts/`.

## Configuration

Settings come from environment variables, or from a local `.env` file that git ignores:

| Variable | Default | Purpose |
|---|---|---|
| `ENVIRONMENT` | `local` | `local`, `staging` or `production` |
| `ANTHROPIC_API_KEY` | none | Claude API key. Required from Phase 4. |
