# UI Design to Code

## Trigger

Read this workflow when implementing a frontend page or component from a screenshot, Figma, mockup, or other existing visual reference.

Use `ui-design-to-code` as the implementation skill and `ui-design-validator` as the independent validation skill. When the implementation contains user-visible actions, add `ui-interaction-contract`; when the flow crosses FE/API/BE, add `cross-layer-contract`.

For frontend behavior, state, data-flow, or component architecture, also load `frontend.md`. The design workflow does not replace FE conventions or defect-prevention rules.

## Input

Design reference:

[ATTACH DESIGN / SCREENSHOT / FIGMA HERE]

Implementation target:

[PAGE / COMPONENT / FEATURE]

Additional requirements:

[OPTIONAL REQUIREMENTS]

## Scope

Implement the provided design in the existing frontend codebase.

Treat the design reference as the authoritative source for observable UI requirements. Do not rely on memory, generic UI conventions, or subjective visual similarity when the reference provides concrete information.

## Context gate

Before implementation:

1. Load `frontend.md` for FE implementation conventions and defect-prevention gates.
2. Inspect the target page/component and relevant existing FE patterns.
3. For Standard/High behavior changes, use the `Implementation Risk Contract` required by `AGENTS.md` / `reference-crosscheck.md`.
4. Load only interaction, cross-layer, runtime, or upstream skills whose triggers are active.

The design workflow does not require a separate approval pause for explicit screenshot/Figma/mockup implementation, but the defect-prevention and verification gates still apply.

## Design extraction

Before implementation, create a concise **Design Contract** containing the information required to implement and validate the design:

- complete visible element inventory
- element order and grouping
- section hierarchy
- layout model and important grid/flex relationships
- row/column/span relationships when determinable
- reference viewport when known
- important geometry/spacing constraints
- explicit requirements vs assumptions

For important or repeated layouts, prefer machine-readable constraints, for example:

```json
{
  "layout": {
    "rows": [
      { "items": [1, 1, 2, 1, 1, 2] }
    ]
  }
}
```

The contract is the implementation input and validation baseline; it is not optional documentation.

## Implementation rules

- Preserve existing business logic and repository conventions.
- Reuse existing components where appropriate.
- Do not omit, merge, reorder, or invent UI elements unless explicitly required.
- Do not reinterpret a concrete layout merely because another layout looks visually similar.
- Preserve same-row and span relationships from the reference.
- Do not redesign the provided UI unless explicitly requested.
- Apply the FE defect-prevention gates from `frontend.md` for state, data flow, interaction, navigation, API boundaries, and UI behavior.

## Validation handoff

After implementation:

1. Pass the Design Contract and rendered implementation to `ui-design-validator`.
2. Use `ui-interaction-contract` only when user-visible interaction is in scope.
3. Use `cross-layer-contract` only when the flow crosses the FE/API/BE boundary.
4. Use browser/DOM/computed-style evidence when available.
5. Do not substitute a subjective visual inspection for structural validation.

A successful build, typecheck, or visual impression is not sufficient to declare design compliance.

If a requirement cannot be verified, report `UNKNOWN`, not `PASS`.

## Done

- [ ] `frontend.md` loaded for FE implementation work.
- [ ] Design Contract extracted.
- [ ] Existing implementation patterns inspected.
- [ ] UI implemented without unrequested redesign.
- [ ] Applicable FE defect-prevention risks challenged before coding.
- [ ] `ui-design-validator` run when contract + observed evidence are available.
- [ ] Interaction/cross-layer validation loaded only when triggered.
- [ ] Structural and visual evidence reported.
