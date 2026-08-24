# TESTING

## Trigger

Read this prompt when creating, changing, diagnosing, or reviewing tests.

Global risk, approval, scope, verification, and dependency routing live in `@.cursor/AGENTS.md`.

## Conditional dependencies

Load only when triggered:

- `review-multi-source-state.md` when tests cover multiple sources for the same logical field at an action boundary.
- `tdd` when the user explicitly requests test-first/TDD or the approved workflow is test-first.
- Do not reload the domain prompt, review baseline, or reference workflow if already in context.

## Test-design gate

Before writing a test, establish:

1. Expected observable behavior.
2. The regression or contract risk protected by the test.
3. The existing framework, fixture, naming, and assertion convention.
4. The smallest test level that proves the behavior.

If behavior is already established by production code, spec, existing tests, or peers, investigate first. Ask only when a product decision remains unresolved.

## Test levels

| Type | Use when |
|---|---|
| Unit | One function, class, hook, or component can prove the behavior at its boundary. |
| Integration | Multiple real modules or a real infrastructure boundary must interact. |
| E2E | A user journey or deployed/dedicated environment behavior is the contract. |

Prefer one test level per file unless repository convention mixes levels.

## Required evidence

Read only what is needed:

1. Production code and direct execution flow.
2. One or two same-level peer tests.
3. Shared fixtures/helpers/base classes actually used by those peers.
4. Existing coverage for the failure/contract path.

Use graph coverage or `tests_for` when available for impacted shared/public behavior.

## Test design

Cover only applicable, evidence-backed cases:

- expected behavior
- error/dependency failure
- boundary/empty input
- state transition
- permission/contract boundary
- multi-source absent / present-empty / present-value semantics when applicable
- **async secondary/derived state still pending when the user can trigger the action**
- **primary data present but derived state incomplete, stale, cancelled, or replaced by a newer request**
- near-valid input that a shallow validator/parser could incorrectly accept
- normalization boundaries such as trimming, internal whitespace, Unicode/full-width forms, case folding, repeated delimiters, or equivalent representations when applicable

For async or multi-source UI state, test the action boundary rather than only the eventual state update. The regression test must prove the user cannot submit an incomplete derived state, or that the action recomputes the authoritative value synchronously, according to the product contract.

For validators, parsers, formatters, and normalizers, partition tests into these classes when the domain supports them:

```text
obviously valid
obviously invalid
near-valid / deceptively invalid
boundary / empty
normalization or representation variants
```

Do not assume a happy-path plus one obviously-invalid case proves a format rule.

Do not turn every concrete bug value into a permanent test catalog entry when the same regression is already represented by a reusable scenario class. Prefer one representative case per distinct failure class and keep feature-specific examples in the feature's own regression tests when needed.

Rules:

- Test behavior and contracts, not private implementation details.
- Prefer one behavioral reason to fail per test.
- Reuse existing fixtures and mocking patterns.
- Keep tests deterministic, isolated, and explicit about time/randomness.
- External services belong in E2E/integration only when repository policy requires them.
- Add test infrastructure only when existing tools are insufficient.
- Mock-call assertions are valid only when the interaction itself is the contract.

## Defect-prevention mapping

For each important implementation invariant, prefer a corresponding regression test when feasible:

```text
Invariant / counterexample
→ test level
→ test case
→ expected observable result
```

For asynchronous derived state, include the timing sequence in the mapping:

```text
primary data loaded → secondary lookup pending → user action
→ expected safe action behavior
```

Do not manufacture tests for behavior that has no evidence or contract.

## Output

Before test implementation:

```text
### Test design
Level: Unit | Integration | E2E
Protected risk: ...
Coverage:
- risk → test case
Assumptions: ...
```

For final reports, use the verification format in `AGENTS.md` and list remaining coverage gaps.

## Done

- [ ] Expected behavior and protected risk identified.
- [ ] Appropriate test level selected.
- [ ] Production path and peer tests inspected.
- [ ] Repository test conventions followed.
- [ ] Important applicable failure paths covered.
- [ ] Async derived-state/action-boundary races covered when applicable.
- [ ] Validators/parsers/normalizers include near-valid and normalization boundary cases when applicable.
- [ ] Assertions verify behavior rather than implementation details.
- [ ] Tests are deterministic and isolated.
- [ ] Tests executed or blocker + residual risk reported.
