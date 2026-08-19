# UI Design Validation Examples

This document is an example library for UI design extraction and structural validation.

It is **reference material**, not a new policy owner. The canonical rules live in:

- `prompts/ui-design-to-code.md` — implementation workflow
- `skills/ui-design-validator/SKILL.md` — validation rules
- `contracts/ui-design-contract.schema.json` — machine-readable contract
- `scripts/ui/validate-design-contract.ps1` — executable structural validation

When adding a new example:

1. Keep it concrete and minimal.
2. Show `Expected`, `Observed`, and the validation result.
3. Identify the invariant that was violated.
4. Include an evidence hint when the mismatch requires browser/DOM inspection.
5. Do not add new policy here. Update the canonical skill/contract only when the example exposes a missing rule.

---

## 1. Same-row grid invariant

### Expected

```text
1 1 2 1 1 2
```

All six items belong to the same visual row.

### Observed

```text
1 1 2 1
1 2
```

The last two items wrapped to another row.

### Result

```text
FAIL
```

### Violated invariant

```text
sameRowGroups must remain in the same row
```

### Evidence hint

Inspect computed grid placement, row start/end, bounding boxes, and wrapping behavior.

---

## 2. Missing required field

### Expected

```text
Customer name
Email
Phone
Address
```

### Observed

```text
Customer name
Email
Address
```

### Result

```text
FAIL
```

### Violated invariant

```text
Every required visible element in the Design Contract must exist.
```

### Evidence hint

Compare the Design Contract element inventory with rendered DOM elements.

---

## 3. Extra unrequested field

### Expected

```text
Customer name
Email
Phone
```

### Observed

```text
Customer name
Email
Phone
Internal note
```

### Result

```text
FAIL
```

### Violated invariant

```text
Do not add visible elements that are not in the reference or requirements.
```

### Evidence hint

Compare element IDs/types/order against the Design Contract.

---

## 4. Correct elements, wrong order

### Expected

```text
1: Product
2: Quantity
3: Unit price
4: Total
```

### Observed

```text
1: Product
2: Unit price
3: Quantity
4: Total
```

### Result

```text
FAIL
```

### Violated invariant

```text
Required visual order must be preserved.
```

### Evidence hint

Validate DOM order and the contract `order` field. Do not rely only on visual similarity.

---

## 5. Wrong column span

### Expected

```text
Item A: column 1, span 2
Item B: column 3, span 1
```

### Observed

```text
Item A: column 1, span 1
Item B: column 2, span 1
```

### Result

```text
FAIL
```

### Violated invariant

```text
columnSpan must match the Design Contract.
```

### Evidence hint

Inspect `grid-column-start/end` or equivalent computed layout information.

---

## 6. Correct grid shape, wrong parent/hierarchy

### Expected

```text
Form
├── Customer section
│   ├── Name
│   └── Email
└── Billing section
    ├── Address
    └── VAT ID
```

### Observed

```text
Form
├── Customer section
│   ├── Name
│   └── Email
│   └── VAT ID
└── Billing section
    └── Address
```

### Result

```text
FAIL
```

### Violated invariant

```text
Element parent/hierarchy must match the Design Contract.
```

### Evidence hint

Inspect DOM parent/child relationships, not just the final pixels.

---

## 7. Correct structure, wrong responsive wrapping

### Expected at desktop

```text
A | B | C | D
```

### Observed at desktop

```text
A | B | C
D
```

### Result

```text
FAIL
```

when the reference specifies all four items on one row at that viewport.

### Violated invariant

```text
The layout must preserve the reference row structure at the specified viewport.
```

### Evidence hint

Validate the actual viewport, computed width, grid/flex settings, and bounding boxes.

---

## 8. Wrong visibility

### Expected

```text
Desktop:
Search | Advanced filters

Mobile:
Search
```

### Observed

```text
Desktop:
Search

Mobile:
Search | Advanced filters
```

### Result

```text
FAIL
```

### Violated invariant

```text
Visibility rules must match the Design Contract for each supported viewport.
```

### Evidence hint

Record viewport-specific observed evidence instead of treating a single viewport as universal.

---

## 9. Interaction state mismatch

### Expected

```text
User clicks Save
→ button disabled
→ spinner shown
→ request sent once
→ success feedback
```

### Observed

```text
User clicks Save
→ button remains enabled
→ two clicks send two requests
```

### Result

```text
FAIL
```

### Violated invariant

```text
A user action with an in-flight mutation must not allow unintended duplicate execution.
```

### Evidence hint

Use interaction/runtime evidence and the `ui-interaction-contract` capability.

---

## 10. FE/API contract mismatch

### Expected

```text
GET /customers
response:
{
  "items": [...],
  "total": 120
}
```

### Observed

```text
GET /customers
response:
{
  "data": [...],
  "count": 120
}
```

### Result

```text
FAIL
```

### Violated invariant

```text
FE and BE must consume the same public contract.
```

### Evidence hint

Run the cross-layer contract validator when machine-readable contract and observed evidence are available.

---

## 11. Post-mutation pagination regression

### Before

```text
Current filter result: 21 rows
Page size: 10
Current page: 3
```

### Mutation

Delete the last row on page 3.

### Expected

```text
Result shrinks to 20 rows
→ current page becomes 2
→ selection is reconciled
→ aggregate/summary is refreshed
```

### Observed

```text
Result shrinks to 20 rows
→ page remains 3
→ empty page shown
```

### Result

```text
FAIL
```

### Violated invariant

```text
A mutation that shrinks the active result set must preserve valid pagination state.
```

### Evidence hint

Trace mutation → state update → refetch/reconciliation → rendered page.

---

## 12. Example extension template

Use this format for future cases:

```text
## N. <short case name>

### Expected
...

### Observed
...

### Result
PASS | FAIL | UNKNOWN

### Violated / preserved invariant
...

### Evidence hint
...
```

Do not turn every observed mismatch into a new rule. First decide whether it is:

- already covered by an existing invariant,
- a missing example only, or
- evidence that the canonical skill/contract/validator needs a genuine update.
