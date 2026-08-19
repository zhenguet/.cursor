---
name: cross-layer-contract
description: Validate contracts crossing frontend, API, backend, persistence, asynchronous processing, and external systems. Use for features spanning FE and BE boundaries.
---

# Cross-Layer Contract Validation

Validate the complete flow rather than reviewing FE and BE independently.

## Canonical contract

When a machine-readable contract exists, use `contracts/cross-layer-contract.schema.json` as the canonical shape and `scripts/cross-layer/validate-contract.ps1` as the deterministic validator.

The validator compares contract expectations with observed evidence. Do not replace a validator result with subjective review.

## Flow

Trace:

```text
UI action
→ client state
→ request
→ API/GraphQL contract
→ authentication/authorization
→ backend validation
→ business service
→ database/state transition
→ external/async side effects
→ response/event
→ client state
→ user-visible result
```

## Contract checks

Validate:

- request fields and types
- response fields and types
- required/optional and nullability
- enums/status values
- validation rules
- authorization
- error codes/statuses/retryability
- loading/success/failure behavior
- pagination/filter/sort semantics
- state transitions
- retry/idempotency behavior
- async completion semantics

## Evidence

For every important boundary record:

```text
Expected
Observed
Evidence
Status
```

Preferred observed evidence can come from:

- FE request/response inspection
- API schema/introspection
- backend handler/service inspection
- tests
- runtime logs or traces without secrets
- read-only DB evidence when necessary

Do not assume FE and BE agree merely because both compile or their local tests pass.

## Mutation flow

For mutations verify:

```text
user action
→ loading
→ request
→ server mutation
→ commit/state change
→ side effect
→ response
→ UI update/toast/navigation
```

Check failure behavior at every boundary.

## Compatibility

Flag:

- FE field not accepted by BE
- BE response field not consumed as expected
- enum mismatch
- nullable/non-null mismatch
- required/optional mismatch
- error contract mismatch
- stale client assumptions
- pagination mismatch
- inconsistent status transition
- asynchronous result treated as synchronous
- retryable operation without duplicate-safe semantics

## Deterministic validation

When both files exist:

```text
contracts/cross-layer-contract.schema.json
scripts/cross-layer/validate-contract.ps1
```

run the validator against the contract and observed evidence before declaring the cross-layer contract verified.

Example:

```powershell
pwsh ./scripts/cross-layer/validate-contract.ps1 `
  -ContractPath ./cross-layer-contract.json `
  -ObservedPath ./cross-layer-observed.json
```

A validator failure blocks PASS.

## PASS / FAIL

Any confirmed contract mismatch is FAIL.

UNKNOWN is not PASS.

A complete E2E flow requires evidence from both sides where available.

## Report

```text
## Cross-Layer Contract

Request: PASS/FAIL/UNKNOWN
Response: PASS/FAIL/UNKNOWN
Validation: PASS/FAIL/UNKNOWN
Authorization: PASS/FAIL/UNKNOWN
State transition: PASS/FAIL/UNKNOWN
Persistence: PASS/FAIL/UNKNOWN
Side effects: PASS/FAIL/UNKNOWN
Error contract: PASS/FAIL/UNKNOWN
Async semantics: PASS/FAIL/UNKNOWN
UI result: PASS/FAIL/UNKNOWN
Deterministic validator: PASS/FAIL/NOT RUN

Overall: PASS / FAIL / PARTIAL
```
