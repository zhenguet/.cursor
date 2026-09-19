# UI Design Planning

## Trigger

Read this workflow when planning a new frontend page/component from a screenshot, Figma, mockup, wireframe, or explicit UI layout requirements.

For UI implementation, this workflow feeds `ui-design-to-code.md`; the resulting plan is the implementation handoff artifact.

## Goal

Produce a standalone Markdown implementation plan that lets another agent implement the UI without reopening the original design to infer basic layout structure.

The plan MUST convert the visual reference into explicit, testable layout constraints. Do not write a generic component checklist.

## Required output artifact

Create a standalone Markdown file:

`<feature-name>.plan.md`

Use the repository's existing planning directory when one exists. If no convention exists, use:

`docs/plans/ui/<feature-name>.plan.md`

The plan file MUST contain:

1. Design reference
2. Target page/component
3. Visible element inventory
4. Exact section hierarchy
5. Exact row-by-row layout specification
6. A Markdown wireframe derived from the design
7. Grid/Flex constraints
8. Same-row / From-To grouping constraints
9. DOM/component hierarchy proposal
10. Existing implementation references
11. Business logic / binding preservation constraints
12. Responsive behavior when determinable
13. UI Design Contract mapping
14. Verification checklist
15. Unknowns / assumptions

## Design extraction rules

Treat the supplied design image/Figma/mockup as authoritative for observable UI structure.

Extract, explicitly:

- every visible field/control/button/tab
- visual order
- grouping
- section boundaries
- row membership
- column membership
- column/row spans
- same-row relationships
- From-To relationships
- approximate width proportions when visually determinable
- alignment rules
- important gaps/padding
- controls that must never wrap
- controls that may wrap
- viewport dimensions when known

Never replace an observed layout with a generic `grid-cols-3`, `space-between`, or auto-wrap interpretation merely because it is simpler.

When the reference is ambiguous, record the ambiguity as `UNKNOWN` or `ASSUMPTION`; do not silently invent a layout.

## Mandatory wireframe

The plan MUST contain a human-readable Markdown/ASCII wireframe.

The wireframe is a structural representation, not an artistic recreation. It must make row/column relationships obvious to an implementation agent.

Example:

```text
┌──────────────────────────────────────────────────────────────────────────────┐
│ 検索条件                                                                     │
├────────────────────┬──────────────────────┬──────────────────┬───────────────┤
│ 対象年月            │ 発注先名              │ 発注先コード       │ 発注担当部署    │
│ [📅 YYYY/MM]       │ [________________]  │ [▼ code]         │ [▼ 部署]       │
│                    │                      │                  │ 発注担当者 [▼] │
├────────────────────┼──────────────────────┼──────────────────┤               │
│ 発注番号            │ 発注日               │ 発注金額           │               │
│ [____________]     │ [📅 From] ~ [📅 To] │ [From] ~ [To]    │               │
├────────────────────┼──────────────────────┼──────────────────┤               │
│ 検収番号            │ 検収日               │ 検収金額           │               │
│ [____________]     │ [📅 From] ~ [📅 To] │ [From] ~ [To]    │               │
├────────────────────┼──────────────────────┼──────────────────┤               │
│ 工事注文書 送信状況   │ 検収明細通知書 送信状況   │ 支払通知書 送信状況 │               │
│ [▼]                │ [▼]                  │ [▼]              │               │
├────────────────────┼──────────────────────┼──────────────────┤               │
│ 検収状況            │ 請書受領状況            │ 完了報告書受領状況 │               │
│ [▼]                │ [▼]                  │ [▼]              │               │
├────────────────────┼──────────────────────┼──────────────────┤               │
│ 表示順1             │ 表示順2               │ 表示順3            │               │
│ [▼ field] ○昇順 ○降順│ [▼ field] ○昇順 ○降順 │ [▼ field] ○昇順 ○降順│               │
└────────────────────┴──────────────────────┴──────────────────┴───────────────┘

[検索] [CSV出力] [工事注文書を再送信]                         表示件数 [20件 ▼]

[発注] [検収] [支払]
┌──────────────────────────────────────────────────────────────────────────────┐
│ table header ...                                                             │
└──────────────────────────────────────────────────────────────────────────────┘
```

The actual wireframe MUST be adapted to the supplied design. Do not copy the example literally.

For layouts with precise grid spans, add a machine-readable layout matrix beside the wireframe, for example:

```text
Search row 1:  [対象年月:1] [発注先名:1] [発注先コード:1] [担当部署+担当者:1]
Search row 2:  [発注番号:1] [発注日:1] [発注金額:1]
Search row 3:  [検収番号:1] [検収日:1] [検収金額:1]
Search row 4:  [工事注文書送信状況:1] [検収明細通知書送信状況:1] [支払通知書送信状況:1]
Search row 5:  [検収状況:1] [請書受領状況:1] [完了報告書受領状況:1]
Search row 6:  [表示順1:1] [表示順2:1] [表示順3:1]
```

## Component/DOM plan

For every major section, define the intended hierarchy:

```text
Page
├── SearchSection
│   ├── SearchRow1
│   │   ├── TargetMonth
│   │   ├── SupplierName
│   │   ├── SupplierCode
│   │   └── OrderingStaffGroup
│   ├── SearchRow2
│   │   ├── OrderNumber
│   │   ├── OrderDateRange
│   │   └── OrderAmountRange
│   └── ...
├── ActionToolbar
└── DataTabs + Table
```

Use actual component names from the repository when known. Otherwise use descriptive proposed names.

## Layout contract

Every important layout relationship MUST be stated as a constraint.

Examples:

- `OrderDateRange` is one horizontal block containing From, `~`, and To.
- From/To controls MUST NOT become separate grid rows at the reference desktop viewport.
- Search rows MUST preserve the visual row boundaries from the design.
- `表示順1/2/3` are three equal horizontal groups.
- Each sort radio group stays adjacent to its corresponding select.
- Toolbar action buttons share one horizontal row and remain left-aligned.
- `表示件数` is right-aligned within the toolbar row.
- Tabs appear immediately above the table header.

Prefer explicit CSS/Grid terminology:

```text
display: grid
grid-template-columns: ...
grid-template-rows: ...
column-span: ...
same-row group: ...
display: flex
flex-direction: row
flex-wrap: nowrap
```

Do not mandate exact pixel values unless they can be established from the reference or existing design system.

## UI Design Contract mapping

Map the plan to `contracts/ui-design-contract.schema.json`.

At minimum identify:

- element IDs/types
- order
- parent section
- row/column
- columnSpan/rowSpan
- grid/flex containers
- sameRowGroups
- expectedItemOrder
- reference viewport

The implementation agent should be able to turn this section directly into the machine-readable Design Contract before coding.

## Existing implementation references

Inspect the target page/component and one structurally relevant peer.

Record:

| Reference | Purpose | Reuse | Do not copy |
|---|---|---|---|
| path | existing layout/component pattern | ... | ... |

Preserve:

- existing data binding
- hooks/state behavior
- validation
- API contracts
- event handlers
- existing shared components

Unless the requirement explicitly changes them.

## Verification checklist

The implementation agent MUST verify:

- [ ] Every visible design element exists.
- [ ] No unrequested visible elements were added.
- [ ] DOM order matches the plan.
- [ ] Parent/child hierarchy matches the plan.
- [ ] Every specified row contains exactly the planned groups.
- [ ] From/To pairs remain on one horizontal row.
- [ ] `~` remains between From and To.
- [ ] Required grid spans match.
- [ ] No unexpected wrapping occurs at the reference viewport.
- [ ] Toolbar buttons share one row.
- [ ] Result-count control is aligned to the right.
- [ ] Tabs sit directly above the table.
- [ ] Existing data binding and business logic remain unchanged unless explicitly requested.
- [ ] Structural evidence is collected with DOM/computed-style inspection where available.
- [ ] Unknown requirements remain marked `UNKNOWN`, not assumed `PASS`.

## Handoff

The implementation agent should read the generated `*.plan.md` first, then:

1. inspect the target code
2. create/update the machine-readable UI Design Contract
3. implement the layout
4. render/inspect the page
5. validate against the contract
6. correct structural mismatches
7. report remaining UNKNOWN items

The plan is an implementation contract, not merely a task summary.
