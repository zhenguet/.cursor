# PROJECT INIT — Frontend

## Trigger

Use when initializing a new frontend application or extracting FE as an independent application.

## Ownership

Own only **frontend architecture, runtime, setup, and frontend-specific security decisions**.

- `project-init-contract.md` owns FE↔BE API contract semantics.
- `security-baseline.md` owns shared authentication, authorization, browser, secrets, and application-security policy.
- `frontend-vercel-skills.md` owns routing to upstream frontend skills.

Do not duplicate canonical rules owned elsewhere.

## Required setup

- Identify framework, runtime, package manager, build tool, and browser/device targets.
- Define entry point, routing, module boundaries, and state ownership.
- Define the API client boundary; keep raw HTTP out of UI components when a service/query layer exists.
- Define auth/session integration points and user-visible unauthorized/forbidden/expiry behavior.
- Define required environment variables and `.env.example` without secrets.
- Define lint/typecheck/test/build/run commands.
- Keep shared UI primitives limited to concrete initial reuse needs.

## Security boundary

Load `security-baseline.md` before making security-sensitive decisions or declaring initialization complete.

Resolve only the frontend-specific decisions it leaves open:

- authentication/session mechanism used by the frontend
- token/session storage strategy
- refresh, expiry, logout, and redirect behavior
- route protection and unauthorized/forbidden UX
- cookie/CSRF behavior when applicable
- safe browser handling of user-controlled content and URLs
- frontend environment-variable boundaries
- file upload/download behavior when applicable

Never treat frontend permission checks as authorization. Server-side enforcement is the security control.

Load a specialized security skill only when its trigger matches the current task. Use `security-baseline.md` for the shared verification contract.

## API boundary

When FE-facing behavior is required:

- Load `project-init-contract.md` as the canonical contract.
- Consume request/response names, types, nullability, enums, pagination, and errors exactly.
- Report unresolved contract decisions as `UNKNOWN`; never invent backend semantics.
- Load `cross-layer-contract` when FE↔BE schema, state, or behavior is part of the work.

## Frontend architecture

For React/Next.js work, load the applicable skills from `frontend-vercel-skills.md` rather than copying their rules into this prompt.

Load:

- `ui-interaction-contract` for interaction/state contracts.
- `ui-design-validator` for UI design validation.
- `ui-design-to-code` for implementing a design/reference into code.

Use the Vercel/React skills routed by `frontend-vercel-skills.md` only when their triggers apply.

Repository conventions and `.cursor/AGENTS.md` take precedence over generic upstream guidance.

## State and user-action safety

Define ownership for server state, client state, form state, and derived state.

For asynchronous secondary/derived data, verify that a user action cannot consume incomplete or stale derived state. Use one repository-approved contract:

- disable/block the action until required data is ready
- wait for the required data before executing
- compute the authoritative value at action time

Also verify stale responses from earlier requests cannot overwrite the current request's authoritative state.

## Verification

```text
install
→ lint
→ typecheck
→ test
→ security verification
→ build
→ run
→ smoke check
```

For UI work, use `ui-interaction-contract` and `ui-design-validator` when applicable. For React/Next.js work, apply the routed Vercel skills from `frontend-vercel-skills.md`.

Initialization is complete only when applicable checks pass and no required security invariant is FAIL/UNKNOWN.

## Output

```text
## FE Initialization
Framework:
Runtime:
Build:
State strategy:
API boundary:
Routing:
Authentication/session:
Security controls:
Security skills loaded:
UI foundation:
Testing:
Verification:
Unknowns:
```
