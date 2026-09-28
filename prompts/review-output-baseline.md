# REVIEW OUTPUT BASELINE

Use this baseline for all review/audit prompts unless a prompt explicitly overrides a section.

Output order, finding bar, severity model, and invariant falsification live **only** here. Specialized review prompts add task-specific passes and must not restate these sections.

`AGENTS.md` owns risk classification and verification policy only.

---

## Core review order (mandatory)

1. Findings first, sorted by severity (Critical -> High -> Medium -> Low, or `P0` -> `P3` when connector parity is active).
2. Open questions / assumptions / unknowns affecting confidence.
3. Task-specific evidence and coverage sections.
4. Verification evidence and verdict or final assessment.
5. Change summary as the final, secondary section.

Do not start with broad summary before findings.
If no findings, state that explicitly and include residual risk/test gaps.

## Finding bar

A finding requires a concrete negative consequence (wrong behavior, regression, contract break, security/data risk, or maintainability failure with clear impact).

Do not produce a finding solely because a preferred pattern was not used.

Style, preference, or alternative-architecture notes belong in residual observations only when they do not meet the finding bar.

## Severity model

Default scale:

| Severity | Meaning |
|----------|---------|
| Critical | Release blocker: data loss, security failure, outage, or crash |
| High | Clear correctness or contract bug in a core flow; fix before merge/release |
| Medium | Real defect with bounded impact or a workaround; should fix |
| Low | Minor valid risk; can defer |

When `codex-connector-review.md` is active, use `P0`–`P3` mapped 1:1 to Critical–Low.

## Invariant falsification

For every high-risk change or flow:

1. State one must-hold invariant (contract, state, ordering, or data semantics).
2. Attempt at least one concrete counterexample: adversarial input, timing sequence, or dependency failure.
3. Record the result — Holds, Violated, or Unknown — with evidence.

For UI flows that load primary data and then asynchronously derive or enrich action-relevant state, explicitly challenge this timing sequence:

```text
primary data loaded → derived state pending → user action
```

The action must not consume incomplete derived state. Acceptable safe contracts are product-dependent: block/disable the action, wait for the lookup, or recompute the authoritative value at action time.

For concurrent requests, also challenge:

```text
request A starts → request B starts → B completes → A completes late
```

A late result must not overwrite the current request's authoritative state unless the contract explicitly permits it.

A finding derived from this protocol must name the invariant and the counterexample.

## End-to-end flow and semantic contract review

For every changed behavior that crosses a function, component, state, route, API, persistence, file, queue, or external-service boundary, verify the complete semantic flow:

```
trigger / caller
→ handler / entry point
→ arguments
→ transformations / mapping / normalization
→ destination / consumer
→ required contract
→ observable result / terminal behavior
```

Do not stop at type compatibility or syntactic correctness. The purpose is to detect cases where every individual step appears valid but the combined flow is wrong.

### Mandatory checks

1. **Required-context propagation**
   - Identify every value the downstream operation requires to behave correctly.
   - Verify those values originate from the correct source and survive every transformation/boundary.
   - A destination being reachable is not sufficient if it cannot operate with the generated state.

2. **Semantic identity preservation**
   - Distinct entities, action modes, document/resource types, scopes, variants, or user intents must remain distinguishable through the flow.
   - Challenge accidental collapse where different inputs produce the same downstream operation, request, resource, or result.
   - If two inputs intentionally converge, verify that equivalence is explicit and safe.

3. **Input consumption**
   - Every behavior-significant argument passed into a handler, mapper, callback, route, API, or service must either affect the intended behavior or be proven intentionally irrelevant.
   - Treat ignored, renamed-away, hard-coded, defaulted, or overwritten inputs as review targets.

4. **Destination/consumer contract**
   - Read the actual consumer, not only the caller.
   - Verify required parameters, preconditions, state, permissions, and expected data shape at the destination.
   - For routes/navigation, inspect what the destination actually requires.
   - For APIs/services, inspect what the implementation actually uses, not only the schema/type.

5. **Terminal behavior**
   - A visible action must reach its advertised outcome: correct screen, mutation, file/resource, state change, or explicit supported result.
   - A handler that only shows an error, returns early, no-ops, or reaches an unsupported path is not an implemented action unless the UI explicitly represents that state.
   - Verify loading, success, failure, and cancellation behavior where applicable.

6. **Round-trip / reversibility where applicable**
   - For upload/download, encode/decode, create/read, serialize/deserialize, route/restore, or similar paired flows, verify that the output corresponds to the same semantic object/resource that entered the flow.
   - Challenge cases where metadata or identity is lost between the two directions.

7. **Cross-boundary cardinality and selection**
   - Verify that the selected entity, resource, row, document, or scope remains the same after mapping/filtering/pagination/lookup.
   - Challenge empty, multiple-match, duplicate, stale, and missing-target cases where applicable.

8. **State preconditions**
   - Verify that the downstream operation's required state is actually established before the action executes.
   - Challenge action timing when required derived, fetched, or persisted state is incomplete or stale.

### Generic counterexample families

For each applicable flow, attempt at least one counterexample from the relevant classes:

- required downstream value omitted
- required value replaced by a default or stale value
- caller passes a value that the handler ignores
- two semantically different actions collapse into one downstream operation
- destination receives syntactically valid but semantically incomplete state
- UI advertises an action whose terminal operation is unavailable or unreachable
- selected entity changes during mapping/filtering/pagination
- paired operation acts on a different resource than the one displayed/selected
- intermediate transformation silently drops or rewrites business-significant meaning
- action executes before required secondary state is ready

These are reusable failure classes. Do not encode feature-specific field names, ticket numbers, or one-off bug examples into the global prompt.

A flow is not considered fully reviewed merely because its types compile, its handler exists, or its immediate API call succeeds.

### Finding rule

When a flow violates one of these checks, report the concrete broken invariant and the smallest safe fix direction. Do not report the category alone.

## Validation and parsing review

Whenever a change adds or modifies a validator, parser, formatter, sanitizer, normalization rule, or user-input acceptance condition, review the **decision boundary**, not only the obvious happy path.

At minimum, consider applicable partitions:

```text
obviously valid
obviously invalid
near-valid false positive
empty / boundary
normalization / representation variant
```

Explicitly try at least one value that a shallow implementation could incorrectly accept. Examples include:

- internal whitespace in a token that allows only non-whitespace characters
- repeated, leading, or trailing separators
- just-inside vs just-outside numeric or length limits
- Unicode/full-width characters in an ASCII-only field
- case variants when comparison is normalized
- visually similar but semantically different characters

These are reusable **failure classes**, not a requirement to maintain a catalog of individual bug values in the general review prompt.

A validation change is not considered thoroughly reviewed merely because unit tests cover one valid value and one obviously invalid value.

## Evidence minimum

Each finding must include:

- Location (file + symbol/line or flow boundary).
- Concrete failure mechanism.
- Impact scope.
- Smallest safe fix direction.

If evidence is missing, mark the conclusion as unknown rather than asserting pass/fail.

## Verification minimum

Match verification to the risk introduced (see `AGENTS.md` risk → verification table), not merely the files changed.

- Report which checks were run (lint/type/test/build/runtime as applicable) and results.
- If checks are skipped: state reason + residual risk.

For validation/parser changes, include the relevant boundary/partition tests or state the missing coverage explicitly.

For async derived-state changes, include action-boundary timing coverage or state the missing race coverage explicitly.

## Common review checklist

- [ ] High-risk changed flows were traced end-to-end from trigger/caller to terminal behavior
- [ ] Required downstream context is propagated through every boundary
- [ ] Semantic identity is preserved; distinct intents/resources do not collapse accidentally
- [ ] Behavior-significant inputs are consumed or intentionally proven irrelevant
- [ ] Destination/consumer preconditions and contracts were inspected
- [ ] User-visible actions reach their advertised terminal behavior
- [ ] Paired/round-trip flows preserve the same semantic resource when applicable

- [ ] Findings are evidence-based and severity-ordered
- [ ] No style-only findings without concrete negative consequence
- [ ] Unknowns/assumptions are explicitly listed
- [ ] Verification evidence is included (or skip reasons + risk)
- [ ] High-risk timing/state flows challenge incomplete async derived state and stale late results when applicable
- [ ] Validation/parser changes include near-valid and boundary analysis when applicable
- [ ] Change summary is present and secondary
