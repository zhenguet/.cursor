# PROJECT INIT — API Contract

## Trigger

Use when FE and BE are separate applications and an integration contract is required before implementation.

## Ownership

This file is the **canonical owner** of FE↔BE interface semantics for project initialization. Do not duplicate these field rules in FE/BE init prompts.

## Contract

For each operation define:

```text
Operation
→ Request
→ Validation
→ Authorization
→ Response
→ Errors
→ State changes
→ Async effects
```

For each field:

- name
- type
- required/optional
- nullable/non-null
- enum values
- semantic meaning
- validation constraints

For collections:

- pagination
- sorting/filtering
- total/count semantics
- stable ordering

For errors:

- HTTP/GraphQL representation
- machine-readable code
- user-visible message policy
- retryability

## Rules

1. FE and BE consume the same contract.
2. Do not maintain contradictory duplicate contract definitions.
3. Contract changes identify affected consumers.
4. Breaking changes require explicit approval or versioning.
5. Screenshots/designs are never API contracts.
6. Never infer missing business semantics from FE convenience.

## Verification

```text
FE request
↔ contract
BE validation/response
↔ contract
FE response/error handling
↔ contract
```

Check names, types, nullability, enums, pagination, and error semantics exactly.

## Output

```text
## API Contract
Operations: ...
Request/response: ...
Errors: ...
State changes: ...
Async effects: ...
FE verification: PASS/FAIL/UNKNOWN
BE verification: PASS/FAIL/UNKNOWN
Overall: PASS/FAIL/PARTIAL
```
