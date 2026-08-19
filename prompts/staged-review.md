# STAGED REVIEW

## Trigger

Read when reviewing staged changes against an originating requirement.

Global risk, graph, evidence, safety, verification, and review-output policy live in `@.cursor/AGENTS.md` and `review-output-baseline.md`.

## Conditional dependencies

- `review-output-baseline.md` — always.
- Applicable domain prompt — only for changed code boundaries.
- `review-multi-source-state.md` — only when the same logical field is assembled from multiple sources at an action boundary.
- `codex-connector-review.md` — only for explicit high-intensity/connector-parity review.

Do not load another review path unless the current task requires it.

## Evidence gate

Establish:

1. Actual staged/selected diff.
2. Requirement and spec when available.
3. Relevant pre-change context.
4. Impacted flows/callers for shared/public changes.
5. Existing tests for changed high-risk behavior.
6. Risk-matched verification results.

Missing material evidence is `Unknown`; unresolved high-impact unknowns block approval.

## Review passes

### Requirement mapping

Map each requirement to diff evidence. Mark Done / Partial / Missing.

### Failure analysis

Challenge applicable cases:

- empty/null/invalid/boundary input
- dependency timeout/4xx/5xx
- permission mismatch
- double action/stale response/concurrency
- mutation then refetch after result-set shrink
- serialization/parsing/round-trip
- producer/consumer contract mismatch

### Invariant falsification

Use `review-output-baseline.md` for high-risk invariant/counterexample analysis.

### Impact

For shared modules, schemas, types, or APIs, inspect callers/consumers and changed assumptions outside the staged files.

### Verification

Run risk-matched checks and record results, skips, and residual risk.

### Self-challenge

Re-read the riskiest changed flow:

- What serious defect could still be hidden?
- Which important invariant remains unchallenged?
- Did the review test global failure modes or only the happy path?

## Output

Follow `review-output-baseline.md`; add only:

```text
## Staged review

### Requirement coverage
| Requirement | Status | Evidence |
|-------------|--------|----------|

### Out-of-scope changes
...

### Verification
- Commands:
- Results:
- Skipped checks + residual risk:

### Verdict
Approved | Approved with notes | Needs revision

### Change summary
...
```

Verdict follows the canonical review baseline and unresolved material risk rules.

## Done

- [ ] Requirement and selected diff read.
- [ ] Evidence gate completed or unknowns recorded.
- [ ] Failure analysis completed.
- [ ] High-risk invariants challenged.
- [ ] Shared/public impact checked.
- [ ] Verification evidence supports the verdict.
