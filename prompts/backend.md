# BACKEND — Java / Spring / GraphQL

## Trigger

Use for Java/Spring, GraphQL/REST, services, repositories, mappers, domains, adapters, transactions, queues/events, batch, and external integrations.

For Node/Express/Prisma use `backend-node.md`.

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
5. Trace controller/resolver → service/application → repository/adapter.
6. Identify state, transaction, external/async, and persistence-write boundaries.
7. Load only triggered skills.

For behavior-changing work, every important invariant/counterexample must have a verification path or explicit residual risk before implementation.

## Java/Spring conventions

- Controllers/resolvers own routing, mapping, and response shaping; keep business orchestration out.
- Services/application layers own business orchestration and transaction boundaries.
- Repositories/adapters own persistence/external integration.
- Place `@Transactional` at the established service/application boundary unless repository evidence requires otherwise.
- Reuse existing mappers, validators, predicates, exceptions, logging, and repository patterns.
- Preserve public API, GraphQL schema, DTO, and shared-service contracts unless explicitly approved.
- Preserve repository conventions for null/default/enum, authorization, and error mapping.
- Keep transaction scope narrow when compatible with existing architecture.
- Keep irreversible external side effects outside DB transactions unless explicitly required.
- Avoid N+1/query loops, connection churn, unbounded request-path loading, and unnecessary eager associations.

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
