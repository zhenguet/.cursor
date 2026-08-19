---
name: backend-contract-validation
description: Validate backend implementations against business, API, data, transaction, side-effect, concurrency, idempotency, and performance contracts. Use for backend feature/fix/review work that changes behavior, persistence, async processing, external integrations, or public contracts.
---

# Backend Contract Validation

The goal is not only to make backend code compile or tests pass. The goal is to prove that the implementation preserves the intended business and system behavior.

Use this workflow:

```text
Requirements / existing behavior
        ↓
Business Contract
        ↓
Implementation
        ↓
Contract Validation
        ↓
Tests / runtime / data evidence
        ↓
PASS / FAIL / UNKNOWN
```

## 1. Build the Contract

Before implementation, extract the decision-relevant contract:

### Business flow

Record:

- entry point
- actor and authorization requirements
- input validation
- preconditions/current-state checks
- business state transitions
- persistence changes
- transaction boundary
- external side effects
- asynchronous boundaries
- response/result semantics
- error behavior

### API contract

Record, where applicable:

- method and route / GraphQL operation
- request fields, types, nullability, defaults
- response fields, types, nullability
- status/error mapping
- authorization behavior
- compatibility constraints

### Data contract

For DB/persistence changes record:

- tables/entities/models affected
- fields and types
- nullable/default/unique constraints
- relationships
- migration requirements
- existing-data assumptions
- indexes/query implications

### Side-effect contract

For every side effect record:

```text
Effect | Timing | Retry | Idempotent? | Failure behavior
```

Include queues, events, email, notifications, external APIs, files, cache invalidation, and other non-transactional effects.

## 2. Validate Invariants

The following are default invariants. Repository-specific rules and explicit requirements take precedence.

### Transaction

- Database transaction boundaries MUST be identified.
- Transaction scope SHOULD be as narrow as practical.
- External side effects MUST NOT be placed inside a DB transaction when that side effect cannot be rolled back, unless the architecture explicitly requires it.
- If an external effect occurs after commit, its failure behavior MUST be defined.

### Idempotency

For every retryable or duplicate-prone operation ask:

```text
If this operation executes twice, what happens?
```

Check message handlers, webhooks, scheduled jobs, batch workers, notifications, and mutation endpoints.

If duplicate execution can create an incorrect result, require an existing idempotency key, state guard, unique constraint, conditional update, deduplication record, or another repository-approved mechanism.

### Concurrency

Identify whether two actors/workers can execute the operation concurrently.

Check the repository's existing strategy:

- optimistic locking
- pessimistic locking
- conditional UPDATE
- unique constraints
- transaction isolation
- queue serialization

Do not assume a preceding SELECT prevents a race.

### Errors

Trace:

```text
failure source → exception/error type → mapper → API/worker result
```

Verify that expected business errors, authorization failures, not-found/conflict cases, retries, and unexpected failures follow repository conventions.

Do not expose internal stack traces or sensitive data.

### Performance

Check the touched flow for:

- N+1 / query-in-loop
- unbounded reads
- missing pagination
- oversized eager loads
- repeated connection creation
- unnecessary full-collection processing
- long-running work inside request transactions
- retry amplification
- excessive external calls

For performance claims, use measurement or clearly label the conclusion as `UNKNOWN`.

## 3. Evidence

Prefer evidence in this order:

1. Existing specification / contract
2. Existing tests that encode the behavior
3. Repository peer implementation
4. Source/data-flow inspection
5. Runtime or read-only DB evidence
6. Reasoned inference

Do not treat inference as proof when stronger evidence is available.

## 4. Adversarial Validation

Actively attempt to falsify correctness.

Check for:

- missing business step
- bypassed authorization
- wrong state transition
- transaction boundary regression
- side effect before commit
- duplicate side effect on retry
- race condition
- incompatible API change
- incorrect null/default handling
- migration/data compatibility issue
- unbounded query
- error swallowed or incorrectly remapped

The objective is to find violations, not to confirm the implementation feels reasonable.

## 5. Result Rules

Every checked invariant must be one of:

```text
PASS     = concrete evidence supports the requirement
FAIL     = evidence shows a violation
UNKNOWN  = the requirement could not be verified
```

`UNKNOWN` is not PASS.

Any required FAIL blocks completion.

If a required invariant remains UNKNOWN, overall status is `PARTIAL` unless the user explicitly accepts the verification limitation.

## 6. Final Report

```text
## Backend Contract

### Business Flow
- Entry/auth: PASS/FAIL/UNKNOWN
- Validation/preconditions: PASS/FAIL/UNKNOWN
- State transition: PASS/FAIL/UNKNOWN
- Persistence: PASS/FAIL/UNKNOWN

### API/Data
- Request/response contract: PASS/FAIL/UNKNOWN
- Data/schema compatibility: PASS/FAIL/UNKNOWN

### Transactions
- Boundary: PASS/FAIL/UNKNOWN
- External side effects: PASS/FAIL/UNKNOWN
- Failure after commit: PASS/FAIL/UNKNOWN

### Reliability
- Idempotency: PASS/FAIL/UNKNOWN
- Concurrency: PASS/FAIL/UNKNOWN
- Retry/error behavior: PASS/FAIL/UNKNOWN

### Performance
- Query/data volume: PASS/FAIL/UNKNOWN
- External call amplification: PASS/FAIL/UNKNOWN

### Verification
- Tests: PASS/FAIL/NOT RUN
- Runtime: PASS/FAIL/NOT AVAILABLE
- Read-only DB evidence: PASS/FAIL/NOT AVAILABLE

## Overall
PASS / FAIL / PARTIAL
```

Overall PASS requires all required, verifiable contracts to pass.
