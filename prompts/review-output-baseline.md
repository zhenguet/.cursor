# REVIEW OUTPUT BASELINE

Use this baseline for all review/audit prompts unless a prompt explicitly overrides a section.

Output order, finding bar, severity model, and invariant falsification live **only** here. Specialized review prompts add task-specific passes and must not restate these sections. `AGENTS.md` owns risk classification and verification policy only.

---

## Core review order (mandatory)

1. Findings first, sorted by severity (Critical -> High -> Medium -> Low, or `P0` -> `P3` when connector parity is active).
2. Open questions / assumptions / unknowns affecting confidence.
3. Task-specific evidence and coverage sections.
4. Verification evidence and verdict or final assessment.
5. Change summary as the final, secondary section.

Do not start with broad summary before findings.
If no findings, state that explicitly and include residual risk/test gaps.

---

## Finding bar

A finding requires a concrete negative consequence (wrong behavior, regression, contract break, security/data risk, or maintainability failure with clear impact).

Do not produce a finding solely because a preferred pattern was not used.

Style, preference, or alternative-architecture notes belong in residual observations only when they do not meet the finding bar.

---

## Severity model

Default scale:

| Severity | Meaning |
|----------|---------|
| Critical | Release blocker: data loss, security failure, outage, or crash |
| High | Clear correctness or contract bug in a core flow; fix before merge/release |
| Medium | Real defect with bounded impact or a workaround; should fix |
| Low | Minor valid risk; can defer |

When `codex-connector-review.md` is active, use `P0`–`P3` mapped 1:1 to Critical–Low.

---

## Invariant falsification

For every high-risk change or flow:

1. State one must-hold invariant (contract, state, ordering, or data semantics).
2. Attempt at least one concrete counterexample: adversarial input, timing sequence, or dependency failure.
3. Record the result — Holds, Violated, or Unknown — with evidence.

A finding derived from this protocol must name the invariant and the counterexample.

---

## Evidence minimum

Each finding must include:

- Location (file + symbol/line or flow boundary).
- Concrete failure mechanism.
- Impact scope.
- Smallest safe fix direction.

If evidence is missing, mark the conclusion as unknown rather than asserting pass/fail.

---

## Verification minimum

Match verification to the risk introduced (see `AGENTS.md` risk → verification table), not merely the files changed.

- Report which checks were run (lint/type/test/build/runtime as applicable) and results.
- If checks are skipped: state reason + residual risk.

---

## Common review checklist

- [ ] Findings are evidence-based and severity-ordered
- [ ] No style-only findings without concrete negative consequence
- [ ] Unknowns/assumptions are explicitly listed
- [ ] Verification evidence is included (or skip reasons + risk)
- [ ] Change summary is present and secondary
