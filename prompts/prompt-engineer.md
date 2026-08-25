# PROMPT ENGINEER

## Trigger

Read this prompt when reviewing, restructuring, or rewriting system prompts, rules, workflows, `AGENTS.md`, or task prompts.

Global language, risk, scope, approval, and verification policies are defined only in `@.cursor/AGENTS.md`.

Workspace prompts, rules, and skills MUST be written in English. Preserve quoted external text, code identifiers, UI copy, paths, and specification text in their original language when required for fidelity.

---

## Establish context

Determine:

1. Target AI or agent runtime.
2. Use case and expected decisions.
3. Review-only or review-and-rewrite scope.
4. Files and sections allowed to change.
5. Required output or compatibility constraints.

Infer these from the request when clear. Ask only when a missing answer would materially change the result.

---

## Analysis dimensions

Evaluate each prompt against:

1. **Clarity** — one actionable interpretation.
2. **Consistency** — no contradictory or split definitions.
3. **Completeness** — inputs, stop conditions, fallbacks, and output are defined.
4. **Redundancy** — one canonical location per policy.
5. **Actionability** — every instruction can be executed with available tools and context.
6. **Structure** — trigger, context, workflow, output, and completion are ordered logically.
7. **Scope integrity** — rules apply only to the intended task and repository.
8. **Safety** — uncertainty, destructive actions, secrets, and approval boundaries are handled.
9. **Efficiency** — context load, instruction density, duplicate instructions, unnecessary mandatory steps, skill-loading overhead, and whether a rule can be triggered conditionally.

For code-agent prompts, also verify:

- Graph-first discovery is conditional on repository coverage.
- File scanning is a targeted fallback.
- Impact, flow, caller, and test evidence are included where relevant.
- Verification requirements match the risk level.
- Risk/Quick gates avoid full workflow for low-risk tasks.
- Global rules are not duplicated from `AGENTS.md`.

---

## Rewrite principles

1. Analyze before rewriting.
2. Preserve valid behavior and compatibility constraints.
3. Keep one canonical source for global policy (`AGENTS.md`).
4. Use specialized prompts as routers plus domain-specific rules.
5. Prefer progressive disclosure: load detailed skills or references only when triggered.
6. Remove copied guidance that is already canonical in another prompt or skill.
7. Replace vague instructions with observable actions and stop conditions.
8. Prefer positive instructions for important guidance; reserve hard negation for safety and scope.
9. Standardize MUST / SHOULD / MAY for rule strength.
10. Do not request hidden chain-of-thought; request concise plans, evidence, and decisions.
11. Do not retain an ineffective structure merely to minimize the diff.
12. Do not add complexity when a shorter rule is equally precise.
13. Do not copy upstream skill bodies into core prompts; route to `SKILL.md` instead.

Do not insert change-marker comments into production prompts unless the user explicitly requests an annotated version.

---

## Findings format

```text
## Prompt analysis

### Assumptions
- Target AI:
- Use case:
- Scope:

### Findings
| # | Dimension | Severity | Location | Issue | Recommended change |
|---|-----------|----------|----------|-------|--------------------|

### Strengths to preserve
- ...

### Risk summary
- Critical:
- High:
- Medium:
- Low:
```

Every finding must identify a specific location, failure mode, and correction.

---

## Rewrite output

When rewriting is requested:

1. Present the approval plan required by `AGENTS.md`.
2. Rewrite the affected prompt as a coherent document, not disconnected patches.
3. Re-read the result against all analysis dimensions.
4. Validate internal paths, cross-references, triggers, and output requirements.
5. Provide a concise changelog in the final report rather than embedding it in the prompt.

---

## Done

- [ ] Target runtime, use case, scope, and constraints established.
- [ ] All analysis dimensions evaluated (including Efficiency).
- [ ] Findings are location-specific and actionable.
- [ ] Valid behavior and strengths preserved.
- [ ] Global policy has one canonical source.
- [ ] Critical and high findings resolved.
- [ ] Rewritten prompt self-reviewed.
- [ ] Cross-references and formatting verified.
- [ ] Workspace prompt/rule/skill text is English unless preserving required source text.
