# PROJECT INIT — Backend

## Trigger

Use when initializing a new backend application or extracting BE as an independent application.

## Ownership

Own only **backend architecture and runtime setup**.

`project-init-contract.md` owns FE↔BE API contract details. Do not redefine request/response field rules here.

## Required setup

- Identify language/runtime/framework and build/dependency tooling.
- Define API style/versioning and authentication/authorization boundaries.
- Define domain/application/service/repository responsibilities for the selected stack.
- Define persistence technology, migrations, transaction ownership, and connection configuration.
- Define validation/error-handling architecture and observability without sensitive data.
- Define async/queue/job boundaries and health/readiness checks when applicable.
- Define tests and executable verification commands.

## API boundary

When FE-facing behavior is required:

- Load `project-init-contract.md` as the canonical API contract.
- Implement that contract exactly; preserve names, types, nullability, enums, pagination, and error semantics.
- Report ambiguity as `UNKNOWN`; do not invent business semantics.

## Database / async

Define only known requirements:

- schema ownership and migration mechanism
- indexes for known access patterns
- transaction boundaries
- seed/backup responsibilities when relevant
- trigger, retry, duplicate, and failure behavior for external side effects

Do not introduce speculative tables, indexes, abstractions, or integrations.

## Verification

```text
install
→ compile/typecheck
→ lint
→ tests
→ migration validation
→ build
→ start
→ health check
```

Initialization is complete only when applicable checks pass.

## Output

```text
## BE Initialization
Runtime:
Framework:
API boundary:
Auth:
Domain structure:
Database:
Transactions:
Async:
Observability:
Testing:
Verification:
Unknowns:
```
