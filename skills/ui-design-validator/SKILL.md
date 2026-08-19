---
name: ui-design-validator
description: Validate a rendered frontend implementation against a machine-readable or documented UI Design Contract using DOM, computed CSS, geometry, and visual evidence. Use when implementation must be proven to match an existing design.
---

# UI Design Validator

Validate the implementation; do not redesign it.

## Canonical contract and validator

When a machine-readable contract exists, use:

```text
contracts/ui-design-contract.schema.json
scripts/ui/validate-design-contract.ps1
```

The contract is the source of expected structure. The observed evidence is the source of actual structure. The validator decides deterministic structural PASS/FAIL; visual review does not override it.

## Core rule

Convert every available design requirement into an observable assertion.

```text
Expected → Observed → Evidence → PASS / FAIL / UNKNOWN
```

Never infer PASS from visual confidence.

## Validation order

1. Element completeness
2. Element identity/type/order/parent
3. Layout/grid structure
4. Row/column/span invariants
5. Reference viewport
6. Geometry
7. Interaction states when specified
8. Visual comparison

Structural failures block visual PASS.

## Element validation

For every contract element verify:

- exists
- unique identity where required
- correct element/control type
- correct order
- correct parent/section
- required/optional state when specified
- visible state when specified

The executable validator checks the machine-readable portion of these requirements.

## Grid validation

When the contract specifies a grid, inspect the rendered DOM and computed styles where possible.

Validate:

- grid container
- `grid-template-columns`
- `grid-template-rows`
- `grid-column-start/end`
- `grid-row-start/end`
- item order
- column spans
- row spans
- item bounding boxes
- same-row relationships
- unexpected wrapping

Do not replace a structural check with visual similarity.

Example:

```text
Expected: 1 1 2 1 1 2 on one row
Observed: 1 1 2 1 / 1 2
Status: FAIL
Reason: same-row invariant violated
```

## Deterministic validation

After observed evidence is collected, run:

```powershell
pwsh ./scripts/ui/validate-design-contract.ps1 `
  -ContractPath ./design-contract.json `
  -ObservedPath ./design-observed.json
```

A validator failure blocks PASS.

The validator is intentionally separate from browser tooling: Chrome DevTools, Playwright, or another runtime tool produces observed evidence; the PowerShell validator evaluates the evidence against the contract.

## Geometry

Use browser evidence when available. Compare:

- x/y
- width/height
- gap
- alignment
- container dimensions
- text wrapping
- overlap

Default tolerance:

```text
position ±2px
size ±2px
spacing ±2px
```

Tolerance must never hide wrong rows, spans, missing elements, or incorrect hierarchy.

## Reference viewport

Validate at the reference viewport when known.

Record:

```text
viewport width
viewport height
DPR/zoom when relevant
```

Do not classify a layout as responsive success merely because it wraps at a different viewport.

## Visual validation

After structural and geometric checks, compare the rendered result with the reference.

Prioritize:

1. missing/extra elements
2. structure/layout
3. geometry
4. typography
5. spacing
6. color/borders/radius/shadows
7. icons/assets

## Interaction validation

When the design or contract specifies behavior, use `ui-interaction-contract` for the behavioral flow. Do not duplicate its detailed checklist here.

## Adversarial pass

Actively attempt to falsify the implementation.

Search for:

- missing fields
- duplicated fields
- reordered controls
- wrapped items
- wrong spans
- hidden elements
- overflow/clipping
- wrong viewport behavior
- visually similar but structurally different layouts

## Result rules

`PASS` requires evidence.

`FAIL` blocks completion.

`UNKNOWN` is not PASS.

If a required assertion is UNKNOWN, overall status is `PARTIAL` unless the user explicitly accepts the limitation.

## Report

```text
## UI Validation

### Elements
Expected: X
Observed: Y
Missing: ...
Extra: ...
Status: PASS/FAIL/UNKNOWN

### Structure
Hierarchy: PASS/FAIL/UNKNOWN
Type: PASS/FAIL/UNKNOWN
Order: PASS/FAIL/UNKNOWN
Parent: PASS/FAIL/UNKNOWN

### Layout
Rows: PASS/FAIL/UNKNOWN
Columns: PASS/FAIL/UNKNOWN
Spans: PASS/FAIL/UNKNOWN
Same-row: PASS/FAIL/UNKNOWN
Wrapping: PASS/FAIL/UNKNOWN

### Geometry
Position: PASS/FAIL/UNKNOWN
Size: PASS/FAIL/UNKNOWN
Spacing: PASS/FAIL/UNKNOWN

### Visual
Status: PASS/FAIL/UNKNOWN/NOT AVAILABLE

### Interaction
Status: PASS/FAIL/UNKNOWN/NOT APPLICABLE

### Deterministic validator
PASS/FAIL/NOT RUN

### Overall
PASS / FAIL / PARTIAL
```
