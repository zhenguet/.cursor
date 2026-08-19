# PROJECT INIT — Split FE / BE

## Trigger

Use when a new project must be initialized as two independently runnable applications: a frontend and a backend.

## Role

This is the **FE/BE orchestration workflow**. It owns the boundary and execution order; the focused FE, BE, and API-contract prompts own their respective details.

Read only the child prompts needed for the current initialization:

- `project-init-fe.md` when the FE application is being initialized.
- `project-init-be.md` when the BE application is being initialized.
- `project-init-contract.md` only when concrete FE↔BE API operations or contract semantics are being defined in this run. It is not required merely to scaffold two independently runnable applications.

Do not bulk-load every project-init prompt when the current run does not require it.

## Prompt budget

This orchestrator and its directly selected child workflows form one initialization workflow family. Keep the active set minimal:

- FE foundation only → this file + `project-init-fe.md`
- BE foundation only → this file + `project-init-be.md`
- FE + BE foundation → this file + both child foundation prompts
- FE/BE API operation design → add `project-init-contract.md` only for that contract-design step, then carry forward the resulting contract summary instead of re-reading the prompt

Do not load the API contract prompt solely because the repository has both FE and BE directories.

## Required execution order

```text
Scope
→ FE/BE boundary
→ FE foundation and/or BE foundation
→ API contract when concrete cross-layer operations are in scope
→ Local integration
→ End-to-end verification
```

Do not start cross-layer feature implementation before the required API contract decisions are established.

## Repository topology

Preferred monorepo shape:

```text
project/
├── frontend/
├── backend/
├── contracts/          # API/schema only; no business implementation
├── infrastructure/     # only when required
└── docs/
```

Separate repositories when organizational or deployment requirements justify them:

```text
project-frontend/
project-backend/
project-contracts/      # optional
```

Do not create `shared/` merely to avoid a small amount of duplication. Shared code requires explicit ownership and versioning.

## Ownership boundary

### Frontend owns

- presentation
- routing
- client state
- user interaction
- API consumption
- accessibility
- browser concerns

### Backend owns

- authentication/authorization enforcement
- business rules
- domain state
- persistence
- transactions
- server-side validation
- async processing
- external integrations

### Contract owns

- request/response shape
- field types and nullability
- enums/statuses
- error representation
- pagination/filter/sort semantics
- compatibility/versioning rules

The contract contains interface semantics, not implementation-specific business logic.

## Prohibited shortcuts

- FE directly accessing DB
- BE owning UI/presentation concerns
- FE and BE defining contradictory API contracts
- copying persistence/domain models into FE without an explicit mapping decision
- creating shared packages solely to remove small duplication
- starting cross-layer implementation while required contract decisions remain unresolved

## Integration verification

When both sides are initialized, verify:

```text
FE starts independently
BE starts independently
FE request matches API contract when an API operation exists
BE validates request according to contract when an API operation exists
BE performs the intended business operation when an API operation exists
BE returns contract-compliant success/error when an API operation exists
FE maps response to the expected UI state when an API operation exists
```

Where async behavior exists, additionally verify completion semantics, retry/duplicate behavior, and user-visible pending/failure states.

## Output

```text
## Split FE/BE Initialization

Repository topology: monorepo / separate repos
Frontend foundation: PASS/FAIL/UNKNOWN
Backend foundation: PASS/FAIL/UNKNOWN
API contract: PASS/FAIL/UNKNOWN/N/A
Auth boundary: ...
Persistence boundary: ...
Async boundary: ...
Local development: ...
CI/CD: ...
End-to-end verification: PASS/FAIL/UNKNOWN
Unknowns / assumptions: ...
```

Do not declare the split complete until every initialized application passes its own checks and every in-scope FE/BE boundary has been verified.
