---
name: backend-state-transition
description: Validate backend state machines, allowed transitions, preconditions, duplicate operations, and concurrency-sensitive mutations. Use for workflow, status, approval, lifecycle, or mutation tasks.
---

# Backend State Transition Validation

Treat state changes as explicit business contracts.

## Extract the state machine

Identify:

- states
- actions
- preconditions
- allowed transitions
- forbidden transitions
- resulting state
- side effects

Represent important flows as:

```text
CURRENT STATE + ACTION → NEXT STATE
```

## Validation matrix

Create a matrix for relevant transitions:

```text
| Current | Action | Allowed | Next | Side effect |
|---------|--------|---------|------|-------------|
```

Do not infer that an action is valid simply because the service method exists.

## Duplicate operations

For every mutation ask:

```text
What happens if this request/message executes twice?
```

Verify whether duplicate execution is:

- rejected
- idempotent
- safely ignored
- prevented by a constraint

If duplicate execution can create an incorrect state or duplicate side effect, FAIL unless explicitly accepted by the existing contract.

## Concurrency

Check whether two actors can perform the same transition concurrently.

Inspect available protection:

- optimistic locking
- pessimistic locking
- conditional update
- unique constraint
- transaction isolation
- atomic database operation

Do not treat `SELECT` followed by `UPDATE` as safe without considering races.

## Evidence

For every important transition record:

```text
Expected
Observed
Evidence
Status
```

## Result rules

Forbidden transition accepted: FAIL.

Required transition missing: FAIL.

Unsafe duplicate execution: FAIL unless explicitly documented.

Unverified concurrency behavior: UNKNOWN.

UNKNOWN is not PASS.

## Report

```text
## State Transition Validation

States: PASS/FAIL/UNKNOWN
Allowed transitions: PASS/FAIL/UNKNOWN
Forbidden transitions: PASS/FAIL/UNKNOWN
Duplicate execution: PASS/FAIL/UNKNOWN
Concurrency: PASS/FAIL/UNKNOWN
Side effects: PASS/FAIL/UNKNOWN

Overall: PASS / FAIL / PARTIAL
```
