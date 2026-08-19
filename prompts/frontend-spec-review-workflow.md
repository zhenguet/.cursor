# FRONTEND SPEC REVIEW

## Trigger

Read when auditing a frontend implementation against a specification or explicit requirement.

Global risk, scope, approval, verification, context, and routing live in `@.cursor/AGENTS.md`.

## Conditional dependencies

Load only when triggered:

- `review-output-baseline.md` — review finding/severity/output contract.
- `review-multi-source-state.md` — same logical field from multiple sources at an action boundary.
- `frontend-vercel-skills.md` — frontend skill selection is required.
- `web-design-guidelines` — explicit UX/a11y review.
- `vercel-react-best-practices` — React/Next rendering, fetching, state, bundle, or performance behavior is in scope.
- `frontend.md` — fixes are explicitly requested.

Do not load generic frontend skills merely because the target is frontend code.

## Review gate

Establish:

```text
Spec/version:
Implementation/build:
Environment:
Target routes/components:
Runtime evidence: available / unavailable
```

Then:

1. Read the relevant specification.
2. Complete the reference workflow required by `AGENTS.md`.
3. Trace the real component → hook/state → API/store flow.
4. Use graph/runtime evidence only when it changes confidence or impact.
5. Load only skills triggered by the review scope.

If required evidence is unavailable, mark the conclusion `Unknown`.

## Requirement verification

Convert each requirement into a verifiable item:

```text
Requirement → Expected → Actual → Evidence → Status
```

Do not infer product requirements from implementation when the specification is explicit.

## Review passes

### Core behavior

- main user flow
- request/response behavior
- state/persistence updates
- navigation/action result

### Failure and boundary behavior

- validation and server error mapping
- loading/empty/retry/failure
- permission/unauthorized
- relevant boundary/malformed/max input

### Defect patterns

Challenge only applicable flows:

- serialization/round-trip integrity
- multi-source absent/present-empty/present-value
- double action/stale response/async ordering
- post-mutation page/cursor/selection/aggregate consistency
- producer/consumer contract compatibility
- timeout/partial failure

### Invariant falsification

Use the invariant falsification protocol from `review-output-baseline.md` for each high-risk flow.

### UI quality

Run UI/a11y checks only when requested or triggered by the review scope.

## Output

Follow `review-output-baseline.md`. Add only the spec-specific sections needed:

```text
## Review context
...

## Requirement checklist
| ID | Requirement | Evidence | Status |
|----|-------------|----------|--------|

## Reference files crosscheck
...

## Agent skills gate
...

## Verification evidence
...

## Final assessment
- Spec coverage: ...
- Release recommendation: ...

## Change summary
...
```

Every finding must contain requirement, expected/actual behavior, evidence, failure mechanism, impact, and smallest safe fix direction.

## Re-check after fixes

Preserve the original finding, add new evidence, update status, and re-run the relevant invariant/verification check.

## Done

- [ ] Requirements converted to verifiable checks.
- [ ] Required reference workflow completed.
- [ ] Only triggered skills loaded.
- [ ] Real implementation flow traced.
- [ ] Applicable defect patterns challenged.
- [ ] High-risk invariants falsified.
- [ ] Unknowns and runtime limitations reported.
- [ ] Review output follows the canonical baseline.
