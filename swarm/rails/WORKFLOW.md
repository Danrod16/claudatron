# Agent Workflow

Every task starts with **architect**. Architect inspects the codebase, produces a plan with a safety assessment (`SAFE` / `REVIEW` / `BLOCKED`), and delegates to the right agents.

## Patterns

| Type | Flow |
|------|------|
| Backend feature | architect → backend → tests |
| Frontend feature | architect → frontend → tests |
| Full-stack feature | architect → backend → frontend → tests |
| Bugfix | architect → tests (reproduce) → backend/frontend (fix) → tests (verify) |
| Test coverage | architect → tests |
| Refactor | architect → backend/frontend → tests (verify no regressions) |

## Final Handoff

Every completed task must report:
- Files changed
- Tests added or updated
- Verification commands run and results
- Remaining risks or anything needing human review
