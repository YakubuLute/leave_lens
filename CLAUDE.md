# CLAUDE.md

Instructions for Claude, and for any contributor, working on **Leaf Lens**. It's a mobile app that diagnoses leaf health from a photo. If a leaf is unhealthy, the app names the disease and explains how to treat it.

- Product context: [README.md](README.md)
- Architecture and roadmap: [docs/PLAN.md](docs/PLAN.md). Read it before starting any feature.

This file holds the **repo-wide** rules. Each part of the monorepo has its own `CLAUDE.md` with rules specific to it. Read both before working in a folder.

---

## 1. Repository map

| Folder | What | Rules |
|---|---|---|
| `app/` | Flutter app: design system, screens, on-device inference | [app/CLAUDE.md](app/CLAUDE.md) |
| `backend/` | FastAPI service: cloud diagnosis proxy to Claude | [backend/CLAUDE.md](backend/CLAUDE.md) |
| `contracts/` | Shared JSON Schema and fixtures for data the app and backend exchange | §3 below, [contracts/README.md](contracts/README.md) |
| `docs/` | `PLAN.md` (architecture and roadmap) and `plans/` (feature plans) | n/a |
| `ml/` | *(Phase 2)* Model training. It gets its own Python environment, separate from `backend/`. | n/a |

The parts are independent: each has its own tooling and dependencies, and its own CI workflow in `.github/workflows/`. Code is never imported across parts. They talk only through the contracts in `contracts/`.

---

## 2. Plan before you implement

**No implementation starts without an agreed plan.** This applies to every feature, refactor or non-trivial fix, in any part of the repo.

1. **Understand.** Read the relevant parts of `docs/PLAN.md`, the existing code and the rules for that part. Ask about anything unclear before you assume.
2. **Write the plan.** Small tasks get a short plan in chat. Larger features get a doc at `docs/plans/<feature>.md`. Either way, cover:
   - **Goal:** what the user will see and be able to do.
   - **Files:** which ones you'll create and which you'll change.
   - **Design:** which design system components it uses, and any new components or tokens it needs (app work).
   - **Data and state:** models, providers, services and endpoints involved.
   - **Contract impact:** does it change anything in `contracts/`? (See §3.)
   - **Edge cases:** errors, offline, empty states, loading, and permission denied.
   - **Tests:** what you'll test and how.
   - **Open questions.**
3. **Get approval.** Wait for the user to confirm the plan before you write code.
4. **Implement in small steps.** Each step should leave every part of the repo in a working state.
5. **Verify.** Run the checks for every part you touched (§4). Then summarise what changed and anything you deferred.

If the work turns out to be different from the plan, **stop and update the plan** instead of drifting quietly.

---

## 3. Shared contract

`contracts/` is the single source of truth for data that crosses between the app and the backend. Today that's the `Diagnosis` result (`diagnosis.schema.json`).

- **Both sides conform to the schema.** The backend's Pydantic models and the app's Dart models must accept every file in `contracts/fixtures/`, and each side has tests that check this.
- **A contract change touches everything in one PR:** the schema, the fixtures, the backend models and the app models. Never change one side alone.
- **Breaking changes bump the API version.** Removing or renaming a field, tightening a type or adding a required field all count. The new version lives at a new path (`/v1/…` → `/v2/…`), and the old one keeps working until old app versions are retired, because installed apps can't be updated on demand.
- **Additive changes are safe:** new optional fields, or new enum values that clients handle with a fallback.

---

## 4. Verification commands

Run the checks for every part you changed. Each part's own `CLAUDE.md` has the details.

```bash
# app/
cd app && flutter analyze && flutter test

# backend/
cd backend && uv run ruff check . && uv run ruff format --check . && uv run pyright && uv run pytest
```

A change to `contracts/` must pass **both**.

---

## 5. Git

- Make small commits that each focus on one thing, with imperative messages: "Add StatusBadge component".
- Prefer one part of the repo per commit. A contract change is the exception: it spans every part by design (§3).
- Don't commit generated files, secrets, `.env` files or large model binaries unless we agree to. Only `.env.example` files are tracked.
- Every commit must pass the checks in §4 for the parts it touches.
