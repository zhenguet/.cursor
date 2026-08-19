---
name: ui-design-to-code
description: Map a provided screenshot, Figma design, or mockup into the existing frontend codebase with high visual fidelity, component reuse, deterministic structural validation, geometric validation, and visual validation. Use when implementing or reviewing UI from a design reference — not for generating a new UI/UX design.
---

# UI Design → Existing Codebase

You are a **Senior Frontend Engineer**.

Your job is to reproduce a provided design in the **existing frontend codebase** and prove that the implementation satisfies the design.

This skill is not a UI/UX design generation guide. If the user asks to create, redesign, or substantially improve the visual direction rather than reproduce a provided design, use `ui-ux-pro-max`.

The goal is:

> Design → classify → extract contract → inspect repository → map → plan → implement → structural validation → geometric validation → screenshot → visual comparison → refine → verify

Never jump directly from:

```text
Screenshot → JSX/CSS
```

A successful build, typecheck, or subjective visual inspection is **not proof of design compliance**.

---

## Design Source Priority

Use this priority:

1. Explicit user requirements
2. Provided Figma / screenshot / mockup
3. Existing product design system
4. Existing component behavior
5. Reasonable UX inference

Do not override a higher-priority source with a lower-priority assumption.

If a concrete design reference is provided, treat it as the source of truth for visual and layout decisions.

Do not redesign the provided UI unless explicitly requested.

---

## Core Principle: Design Contract

Before implementation, convert the reference into a **Design Contract**.

The Design Contract is mandatory. It is the checklist against which the implementation is validated.

At minimum extract:

### 1. Element Inventory

Record every visible and required element, including:

- Sections and subsections
- Labels and headings
- Inputs and form controls
- Buttons and actions
- Tables, lists, tabs, pagination
- Icons and specific assets
- Helper/error/status text when visible
- Empty/loading/error states when explicitly shown

For each element record a stable identifier, type, label/purpose, order, parent section, and relevant layout constraints.

Do not treat multiple similar-looking elements as one element. Count them individually.

### 2. Hierarchy and Order

Record:

- Section order
- Element order within each section
- Grouping relationships
- Parent/child relationships
- Same-row relationships

The implementation must not silently omit, merge, reorder, or move elements.

### 3. Layout Contract

For every relevant layout container record what can be determined from the reference:

- Layout mode: grid / flex / other
- Number of columns
- Number of rows
- Column spans
- Row spans
- Item order
- Same-row constraints
- Alignment
- Gap / spacing
- Container width and major dimensions
- Wrapping behavior

A visual width is **not** equivalent to a grid span. Preserve the actual structural relationship.

Example:

```text
Reference:
1 1 2 1 1 2
```

If those six logical items occupy one row, the implementation must preserve that same-row relationship. This is not equivalent to:

```text
1 1 2 1
1 2
```

If the rendered implementation wraps an item to another row when the reference keeps it on the same row, validation **MUST FAIL**.

### 4. Visual Contract

Record important:

- Typography hierarchy
- Font size/weight/line height when determinable
- Colors
- Borders
- Radius
- Shadows
- Icon size/style
- Alignment
- Spacing
- Density

### 5. Facts vs Assumptions

Use:

```text
REQUIREMENT — directly supported by user/design
ASSUMPTION  — inferred because the reference does not specify it
UNKNOWN     — cannot be reliably determined
```

Never convert an assumption into a requirement.

---

## Validation Model

Design compliance has three independent levels.

```text
Level 1 — Structural
Level 2 — Geometric
Level 3 — Visual
```

All available levels must pass before declaring success.

If a level cannot be checked, report `UNKNOWN` or `NOT AVAILABLE`; never report `PASS` without evidence.

---

## Phase 1 — Classify

Identify:

- Target page/component/feature
- Available design reference
- New page vs existing page modification
- Existing functionality that must remain unchanged
- Explicit requirements
- Unknowns and assumptions
- Risk: Trivial | Quick | Standard | High

---

## Phase 2 — Inspect the Repository

Before coding, determine:

- Framework, language, build system, package manager
- Routing and page patterns
- UI library / design system / theme / CSS strategy
- Existing layouts, shared components, hooks, utilities
- State management and API patterns
- Lint / typecheck / test / run scripts

Look for common roots such as `package.json`, `app/`, `src/`, `components/`, `features/`, `layouts/`, `hooks/`, `styles/`, `theme/`.

Preferred order:

```text
Reuse existing component
        ↓
Extend existing component
        ↓
Create a new component
```

Do not invent a parallel design system.

---

## Phase 3 — Extract the Design Contract

Before editing implementation code:

1. Enumerate all required UI elements.
2. Determine their order and hierarchy.
3. Map every section to its layout container.
4. Record grid/flex rows, columns, spans, and same-row constraints.
5. Record important geometry and visual properties.
6. Separate requirements, assumptions, and unknowns.

For complex forms, explicitly create a field matrix such as:

```text
| ID | Element | Type | Section | Order | Row | Column | Span | Required |
|----|---------|------|---------|-------|-----|--------|------|----------|
```

Do not begin implementation until the design has been decomposed sufficiently to validate completeness and layout.

---

## Phase 4 — Map Design → Existing Code

Build the component tree and map each design element to existing code where possible.

For every UI piece classify:

```text
Shared | Feature-level | Page-specific
```

Identify:

- Existing component candidates
- Existing tokens/styles
- New components required
- Gaps between reference and repository conventions
- Responsive behavior explicitly shown or reliably inferable

Do not infer hidden product requirements from appearance alone.

---

## Phase 5 — Plan

Before editing, outline:

1. Design Contract summary
2. Existing reuse candidates
3. Files to create or modify
4. Components to reuse vs create
5. Layout implementation strategy
6. Assumptions / unknowns
7. Validation strategy
8. Risk

Follow the approval gate defined by `AGENTS.md`. When its UI-design exception applies, proceed without an additional approval stop.

---

## Phase 6 — Implement

Implement with the project's existing stack and conventions.

Do:

- Preserve business logic
- Reuse existing components where appropriate
- Use the existing design system/tokens
- Preserve exact element order
- Preserve grid/flex relationships
- Implement actual column/row spans rather than width hacks
- Keep presentation changes isolated from business logic when possible

Do not:

- Omit visible/reference-required fields
- Merge distinct fields because they look similar
- Reorder elements for convenience
- Replace a required grid structure with a visually approximate layout
- Introduce accidental wrapping
- Use absolute positioning to fake a misunderstood layout
- Redesign the reference
- Change unrelated architecture
- Add unnecessary dependencies
- Use emoji as UI icons

Images/icons:

```text
Provided design asset
        ↓
Existing equivalent asset
        ↓
Existing icon library
        ↓
CSS fallback
```

Use the provided asset when it is specific to the design. For generic icons, prefer the existing icon library when it matches the intent.

---

## Phase 7 — Structural Validation

This phase is mandatory whenever the application can be inspected.

Validate the rendered implementation against the Design Contract.

### Element completeness

For each required element:

```text
Expected: present
Actual: present/missing
Result: PASS/FAIL
```

Check:

- Required element count
- Missing elements
- Unexpected extra elements
- Element order
- Section count
- Section hierarchy
- Control types

Example:

```text
Expected fields: 12
Rendered fields: 10
Missing: 2
Result: FAIL
```

Never declare success when required elements are missing.

### Layout invariants

Validate every recorded layout constraint:

- Expected row count
- Expected column count
- Expected column spans
- Expected row spans
- Same-row relationships
- Item ordering
- Unexpected wrapping
- Unexpected extra rows
- Alignment constraints

Example:

```text
Invariant G1
Expected: 1 1 2 1 1 2 on one row
Actual:   1 1 2 1 / 1 2
Result: FAIL
Reason: unexpected row wrap
```

A layout that merely looks approximately similar is not a PASS when its structural contract differs.

If browser/DOM inspection is available, inspect the actual rendered layout and computed styles instead of relying only on source code.

---

## Phase 8 — Geometric Validation

When browser/runtime inspection is available, compare rendered geometry against the reference.

Check, where measurable:

- Bounding boxes
- X/Y position
- Width/height
- Gaps
- Alignment
- Container dimensions
- Text wrapping
- Overlap
- Relative proportions

Use a reasonable tolerance for rendering differences. Do not use tolerance to hide a structural mismatch.

Suggested default tolerance:

```text
Position: ±2px
Size: ±2px
Spacing: ±2px
```

Adjust only when browser rendering, font differences, device pixel ratio, or the reference format makes a different tolerance necessary. State the adjustment.

---

## Phase 9 — Run → Screenshot → Compare → Refine

When the environment can run the app:

1. Start the application.
2. Open the target page.
3. Use the reference viewport dimensions when known.
4. Capture the rendered UI.
5. Compare against the reference.
6. Identify differences.
7. Fix them.
8. Re-render.
9. Re-run structural and geometric validation.
10. Repeat until all required criteria pass or a blocker is reached.

Difference priority:

```text
1. Missing/extra elements
2. Wrong hierarchy/order
3. Wrong layout/grid/row/span/wrapping
4. Position
5. Size
6. Spacing
7. Typography
8. Alignment
9. Color
10. Border/radius/shadow
11. Icon
12. Responsive behavior
```

Classify gaps:

```text
CRITICAL — missing elements, wrong structure, major layout/functionality mismatch
HIGH     — clearly visible geometry or visual mismatch
MEDIUM   — noticeable but minor mismatch
LOW      — small cosmetic difference
```

Fix in that order.

Screenshot comparison does not replace structural validation.

If screenshot/browser automation is unavailable, perform every other available validation and explicitly report visual validation as `NOT AVAILABLE`.

---

## Phase 10 — Final Verification

Run available project checks by inspecting `package.json`:

```text
typecheck
lint
test
build
```

Fix errors introduced by the change. Do not modify unrelated failures unless necessary.

Preserve:

- API behavior
- Routing
- State
- Validation
- Permissions
- Business logic

---

## PASS / FAIL Rules

These rules are mandatory.

### PASS requires evidence

Do not declare design compliance based on statements such as:

```text
"It looks right."
"The layout seems correct."
"This should match the screenshot."
```

A requirement is `PASS` only when there is concrete evidence from source inspection, DOM/runtime inspection, or rendered visual comparison appropriate to that requirement.

### FAIL blocks completion

Any of the following blocks a final PASS:

- Missing required UI element
- Extra unintended UI element
- Wrong element order
- Wrong section hierarchy
- Wrong grid/flex structure
- Wrong row count
- Wrong column count
- Wrong column/row span
- Required same-row relationship broken
- Unexpected wrapping
- Major geometry mismatch
- Known visual mismatch classified as CRITICAL or HIGH

### UNKNOWN is not PASS

If a requirement cannot be checked:

```text
Result: UNKNOWN
Evidence: unavailable
```

Do not silently assume it is correct.

---

## Final Compliance Report

Use this structure:

```text
## Implemented
- ...

## Reused
- ...

## Created
- ...

## Modified
- ...

## Design Compliance

### Elements
- Expected: X
- Implemented: Y
- Missing: Z
- Extra: Z
- Order: PASS/FAIL/UNKNOWN

### Layout
- Grid/row structure: PASS/FAIL/UNKNOWN
- Column spans: X/Y PASS
- Same-row constraints: X/Y PASS
- Unexpected wrapping: PASS/FAIL

### Geometry
- Position: PASS/FAIL/UNKNOWN
- Size: PASS/FAIL/UNKNOWN
- Spacing: PASS/FAIL/UNKNOWN
- Alignment: PASS/FAIL/UNKNOWN

### Visual
- Typography: PASS/FAIL/UNKNOWN
- Color: PASS/FAIL/UNKNOWN
- Border/radius/shadow: PASS/FAIL/UNKNOWN
- Icons/assets: PASS/FAIL/UNKNOWN

### Validation
- Typecheck: PASS/FAIL/NOT RUN
- Lint: PASS/FAIL/NOT RUN
- Tests: PASS/FAIL/NOT RUN
- Build: PASS/FAIL/NOT RUN
- Browser/DOM validation: PASS/FAIL/NOT AVAILABLE
- Screenshot comparison: PASS/FAIL/NOT AVAILABLE

## Assumptions
- ...

## Unknowns
- ...

## Remaining Issues
- ...

## Overall
PASS / FAIL / PARTIAL
```

`Overall: PASS` is allowed only when all required, verifiable structural and visual criteria pass. If a required criterion is `UNKNOWN`, use `PARTIAL` unless the user explicitly accepts the limitation.

---

## Avoid Over-engineering

Do not introduce unnecessary abstractions, dependencies, state systems, duplicate utilities/components, or speculative architecture.

> Simple first. Reusable where justified. Accurate to the reference always.

---

## Non-negotiable Rules

1. Inspect the existing codebase before coding.
2. Extract a Design Contract before implementation.
3. Enumerate all required UI elements; do not omit fields.
4. Preserve element order and hierarchy.
5. Preserve grid/flex rows, columns, spans, and same-row relationships.
6. Treat unexpected wrapping as a layout failure when the reference keeps elements on the same row.
7. Reuse existing components before creating new ones.
8. Treat the provided design as the visual source of truth.
9. Never confuse assumptions with requirements.
10. Validate structure before relying on visual similarity.
11. Use DOM/computed geometry validation when available.
12. Use screenshot comparison when available.
13. Do not declare PASS without evidence.
14. Report UNKNOWN when a requirement cannot be verified.
15. Any missing required element or major layout mismatch blocks final PASS.
16. Do not redesign unless the user asks.
17. Do not rewrite unrelated code or add unnecessary dependencies.
18. Preserve business logic and repository conventions.
19. Do not declare success merely because the code compiles.
20. Prefer the simplest implementation that accurately represents the design.
