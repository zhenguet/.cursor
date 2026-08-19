---
name: ui-interaction-contract
description: Define and validate user-visible interaction flows for frontend mutations, forms, navigation, loading, success, failure, and async state. Use when a UI action crosses client state and server behavior.
---

# UI Interaction Contract

Treat important user actions as observable contracts, not only rendered controls.

## Flow

For each relevant action define:

```text
Action
→ Preconditions
→ Loading
→ Request
→ Success
→ Failure
→ State update
→ Navigation / feedback
```

## Contract fields

Capture where applicable:

- trigger and control identity
- enabled/disabled conditions
- validation/preconditions
- request method/operation
- request payload
- loading behavior
- duplicate-click behavior
- success response
- failure response/error code
- toast/message/modal behavior
- cache/refetch/state update
- navigation
- focus restoration

## Mutation safety

For create/update/delete/approve/reject/status-change actions verify:

- repeated submission behavior
- disabled/loading state
- server idempotency expectations
- stale selection handling
- pagination/filter state after mutation
- dependent aggregate refresh

## Evidence

Record:

```text
Expected
Observed
Evidence
Status
```

`PASS` requires evidence. `UNKNOWN` is not PASS.

## Report

```text
## Interaction Contract

Trigger: PASS/FAIL/UNKNOWN
Preconditions: PASS/FAIL/UNKNOWN
Loading: PASS/FAIL/UNKNOWN
Request: PASS/FAIL/UNKNOWN
Success: PASS/FAIL/UNKNOWN
Failure: PASS/FAIL/UNKNOWN
State update: PASS/FAIL/UNKNOWN
Navigation/feedback: PASS/FAIL/UNKNOWN
Duplicate submission: PASS/FAIL/UNKNOWN

Overall: PASS / FAIL / PARTIAL
```
