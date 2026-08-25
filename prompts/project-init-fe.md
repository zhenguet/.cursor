# PROJECT INIT — Frontend

## Trigger

Use when initializing a new frontend application or extracting FE as an independent application.

## Ownership

Own only **frontend architecture, runtime, security, and application setup**.

`project-init-contract.md` owns FE↔BE API contract details. Do not redefine API field rules here.

## Required setup

- Identify framework, runtime, package manager, build tool, and browser/device targets.
- Define entry point, routing, module boundaries, and state ownership.
- Define the API client boundary; keep raw HTTP out of UI components when a service/query layer exists.
- Define auth/session handling, error/loading/empty/unauthorized/forbidden/retry/cancellation states.
- Define required environment variables and `.env.example` without secrets.
- Define lint/typecheck/test/build/run commands.
- Keep shared UI primitives limited to concrete initial reuse needs.
- Load `security-baseline.md` and verify all applicable frontend security controls before initialization is complete.

## Security, authentication, and permissions

`security-baseline.md` is the canonical shared security baseline. Apply it; do not duplicate its full policy here.

Before implementation, explicitly resolve:

- authentication mechanism and session/token lifecycle
- token/session storage strategy
- refresh, expiry, logout, and unauthorized-session behavior
- route protection
- roles/permissions available to the UI
- frontend permission checks and their UX purpose
- backend enforcement boundary for every protected operation
- cookie/CSRF behavior when cookie-based authentication is used
- XSS/unsafe HTML boundaries
- frontend environment-variable and secret boundaries
- file upload/download security
- security-sensitive URL/query/hash handling

Important rule:

```text
Frontend permission check = UX behavior
Backend authorization check = security control
```

Never place backend secrets, private credentials, signing keys, or privileged API tokens in browser-delivered code.

Explicitly challenge:

- client-controlled role/permission/user/resource identifiers
- unauthorized route access
- stale permission/session state
- privilege escalation through UI state manipulation
- cross-user/tenant resource access through crafted URLs or API requests
- sensitive data persisted in unsafe browser storage
- XSS through user-controlled content
- CSRF for cookie-authenticated mutations
- unsafe redirects
- unsafe file handling
- secrets exposed through source maps, bundles, environment variables, or logs

## Security skill routing

Load specialized security skills when their task signal applies. Do not load all security skills by default.

- `trailofbits-sharp-edges` — security-sensitive client/API configuration, authentication/session interfaces, dangerous defaults, and fail-open behavior.
- `trailofbits-variant-analysis` — after a confirmed frontend security defect or reusable bad pattern, search for equivalent instances across the codebase.
- `anthropic-devsecops-security-scanning` — frontend CI/CD security gates, secrets scanning, dependency/SAST scanning, or DAST setup.
- `anthropic-malicious-npm-package-triage` — when vetting or investigating npm dependencies for supply-chain compromise.
- `anthropic-opa-policy-as-code` — only when frontend deployment/infrastructure is governed by OPA/Gatekeeper policies.

These skills supplement `security-baseline.md`; they do not override `.cursor/AGENTS.md`, product requirements, or repository policy.

## API boundary

When FE-facing behavior is required:

- Load `project-init-contract.md` as the canonical contract.
- Consume request/response names, types, nullability, enums, pagination, and errors exactly.
- Report unresolved contract decisions as `UNKNOWN`; never invent backend semantics.
- Load `cross-layer-contract` when FE↔BE schema, state, or behavior is part of the work.

## Frontend architecture

For React/Next.js work, load the applicable skills from `frontend-vercel-skills.md` rather than copying their rules into this prompt:

- `vercel-composition-patterns` for component composition and architecture.
- `vercel-react-best-practices` for React/Next.js performance and implementation patterns.
- `web-design-guidelines` for web UX/accessibility guidance.
- `vercel-react-view-transitions` when motion/view-transition behavior is involved.
- `vercel-react-native-skills` only for React Native projects.

Load `ui-interaction-contract` for interaction/state contracts and `ui-design-validator` for UI design validation when their task signals apply.

Load `ui-design-to-code` when implementing a design/reference into code.

Do not blindly apply a third-party skill: repository requirements and `.cursor/AGENTS.md` take precedence, and `UNKNOWN` must be reported when the skill guidance does not resolve the product requirement.

## State and user-action safety

Define ownership for server state, client state, form state, and derived state.

For asynchronous secondary/derived data, explicitly verify that a user action cannot consume incomplete or stale derived state. Use one of the repository-approved contracts:

- disable/block the action until required data is ready
- wait for the required data before executing
- compute the authoritative value at action time

Also verify stale responses from earlier requests cannot overwrite or masquerade as the current request's completed state.

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
Authorization/permissions:
Security controls:
Security skills loaded:
UI foundation:
Testing:
Verification:
Unknowns:
```
