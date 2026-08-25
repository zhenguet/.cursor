# PROJECT INIT — Backend

## Trigger

Use when initializing a new backend application or extracting BE as an independent application.

## Ownership

Own only **backend architecture, runtime, security, and operational setup**.

`project-init-contract.md` owns FE↔BE API contract details. Do not redefine request/response field rules here.

## Required setup

- Identify language/runtime/framework and build/dependency tooling.
- Define API style/versioning and authentication/authorization boundaries.
- Define domain/application/service/repository responsibilities for the selected stack.
- Define persistence technology, migrations, transaction ownership, connection configuration, and data-access boundaries.
- Define validation/error-handling architecture and observability without sensitive data.
- Define async/queue/job boundaries, idempotency, retry behavior, and health/readiness checks when applicable.
- Define tests and executable verification commands.
- Load `security-baseline.md` and verify all applicable security controls before implementation is considered complete.

## Security and authorization

`security-baseline.md` is the canonical shared security baseline. Apply it; do not duplicate its full policy here.

Before implementation, explicitly resolve:

- authentication mechanism and trust boundary
- session/token lifecycle and revocation where applicable
- authorization model: roles, permissions, ownership, tenant boundaries, or other policy
- protected resources and privileged operations
- enforcement point for every sensitive operation
- deny-by-default behavior
- `401` vs `403` semantics where applicable
- service-to-service credentials and least privilege
- secret storage and environment boundaries
- audit/security logging and redaction

For every protected operation, record:

```text
Actor → Resource → Action → Authorization decision → Enforcement point
```

Never rely on frontend checks or client-provided role/user/permission fields for authorization.

Explicitly challenge:

- unauthenticated access
- IDOR/BOLA
- horizontal privilege escalation
- vertical privilege escalation
- cross-tenant access
- mass assignment/over-posting
- injection and unsafe deserialization
- path traversal / SSRF where applicable
- unsafe file upload/download
- webhook forgery/replay
- rate-limit/resource-exhaustion paths
- sensitive information disclosure through errors, logs, or health endpoints

## API boundary

When FE-facing behavior is required:

- Load `project-init-contract.md` as the canonical API contract.
- Implement that contract exactly; preserve names, types, nullability, enums, pagination, and error semantics.
- Report ambiguity as `UNKNOWN`; do not invent business semantics.
- Load `cross-layer-contract` when FE↔BE behavior, schema, or state synchronization is part of the work.
- Load `backend-contract-validation` for behavior-changing backend work.

## Architecture and domain

When the project requires non-trivial domain modeling:

- Load `domain-modeling` when domain boundaries, aggregates, invariants, or ownership decisions are material.
- Load `codebase-design` when designing module interfaces, seams, or deep modules.
- Keep domain rules out of transport adapters where the selected architecture provides a domain/application layer.

Do not introduce speculative abstractions, layers, or framework wrappers without a concrete requirement.

## Database / transactions

Define only known requirements:

- schema ownership and migration mechanism
- indexes for known access patterns
- transaction boundaries
- consistency and isolation requirements when material
- seed/backup responsibilities when relevant
- trigger, retry, duplicate, and failure behavior for external side effects
- row/resource ownership checks for protected data

External non-transactional side effects MUST NOT be hidden inside a database transaction unless the architecture explicitly requires it. Define after-commit failure behavior when applicable.

## Async / reliability

For queues, workers, webhooks, scheduled jobs, and other retryable operations:

- Load `backend-state-transition` when lifecycle/state transitions are involved.
- Define idempotency and duplicate behavior.
- Define retry and dead-letter behavior.
- Define concurrency/race protection.
- Define transaction-to-side-effect ordering.

## Verification

```text
install
→ compile/typecheck
→ lint
→ tests
→ migration validation
→ security verification
→ build
→ start
→ health check
```

For backend contract or behavior changes, use `backend-contract-validation` and report PASS / FAIL / UNKNOWN for the checked invariants.

Initialization is complete only when applicable checks pass and no required security invariant is FAIL/UNKNOWN.

## Output

```text
## BE Initialization
Runtime:
Framework:
API boundary:
Authentication:
Authorization:
Security controls:
Domain structure:
Database:
Transactions:
Async/reliability:
Observability:
Testing:
Verification:
Unknowns:
```
