# BACKEND — Node / Express / Prisma

## Trigger

Use for Node.js/Express, REST/JSON, middleware, handlers, services, repositories, Prisma, transactions, queues/jobs, and external integrations.

For Java/Spring/GraphQL use `backend.md`.

### Conditional skills

- `backend-contract-validation`: behavior, API/data contract, persistence, transaction, async, external integration, or performance-sensitive changes.
- `backend-state-transition`: workflow/status/approval/lifecycle or concurrency-sensitive mutations.
- `cross-layer-contract`: FE/API/BE boundary changes.
- `review-multi-source-state`: multiple sources represent one logical field at an action boundary.

Global risk, approval, evidence, context, and verification policy lives in `AGENTS.md`.

## Context gate

Before editing:

1. Resolve repository, module, public boundary, and target flow.
2. Standard/High: complete the `Implementation Risk Contract` in `reference-crosscheck.md`.
3. Standard/High: inspect full target, direct execution flow, relevant callers/consumers, and a structural peer when needed.
4. Trivial/Quick: use targeted reads; expand only when evidence shows broader impact.
5. Trace route/middleware → handler → service → Prisma/data-access.
6. Identify state, transaction, external/async, and persistence-write boundaries.
7. Load only triggered skills.

For behavior-changing work, every important invariant/counterexample must have a verification path or explicit residual risk before implementation.

## Node/Prisma conventions

- Routes/middleware own HTTP wiring and auth hooks; keep business orchestration out.
- Handlers/controllers map input/output and remain thin.
- Services own business orchestration and transaction boundaries.
- Prisma client/repository modules own persistence queries.
- Use `prisma.$transaction` for multi-write units of work at the established service boundary.
- Reuse existing validation schemas, error helpers, logging, and data-access patterns.
- Preserve public routes, request/response shapes, DTO/schema contracts, nullability, enums, auth, ownership, and error mapping unless explicitly approved.
- Prefer parameterized queries; never concatenate untrusted SQL.
- Avoid N+1/query loops, unbounded request-path loading, connection churn, and long-running transaction work.

## Defect prevention before coding

Challenge only applicable categories:

| Category | Pre-code challenge |
|---|---|
| State/lifecycle | forbidden transition, duplicate/concurrent execution |
| Transaction/async | commit ordering, failure, retry/redelivery |
| Persistence | row/cardinality change, constraints, existing-data impact |
| Public API | producer/consumer compatibility, nullability, enums, errors |
| External integration | timeout, retry, duplicate side effect |

Consume the canonical validation skills for detailed checks; do not duplicate their checklists here.

## Done

- [ ] Correct risk/context depth used.
- [ ] Applicable validation skills loaded before editing.
- [ ] Important failure modes challenged before coding.
- [ ] Invariants/counterexamples mapped to verification or residual risk.
- [ ] Layering, transaction, public-contract, security, and data semantics preserved.
- [ ] Risk-matched verification completed; blockers/unknowns reported.
