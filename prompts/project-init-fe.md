# PROJECT INIT — Frontend

## Trigger

Use when initializing a new frontend application or extracting FE as an independent application.

## Ownership

Own only **frontend architecture and runtime setup**.

`project-init-contract.md` owns FE↔BE API contract details. Do not redefine API field rules here.

## Required setup

- Identify framework, runtime, package manager, build tool, and browser targets.
- Define entry point, routing, module boundaries, and state ownership.
- Define the API client boundary; keep raw HTTP out of UI components when a service/query layer exists.
- Define auth/session handling, error/loading/empty/unauthorized/forbidden/retry/cancellation states.
- Define required environment variables and `.env.example` without secrets.
- Define lint/typecheck/test/build/run commands.
- Keep shared UI primitives limited to concrete initial reuse needs.

## API boundary

When FE-facing behavior is required:

- Load `project-init-contract.md` as the canonical contract.
- Consume request/response names, types, nullability, enums, pagination, and errors exactly.
- Report unresolved contract decisions as `UNKNOWN`; never invent backend semantics.

## Verification

```text
install
→ lint
→ typecheck
→ test
→ build
→ run
→ smoke check
```

Initialization is complete only when applicable checks pass.

## Output

```text
## FE Initialization
Framework:
Runtime:
Build:
State strategy:
API boundary:
Routing:
Auth/session:
UI foundation:
Testing:
Verification:
Unknowns:
```
