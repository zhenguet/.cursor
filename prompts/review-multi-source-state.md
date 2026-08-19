# MULTI-SOURCE STATE (REVIEW & IMPLEMENT)

Read this file when code reads or merges values from **more than one source of truth** for the **same logical field/value** at the action boundary (especially on submit, save, or search).

Applies across Frontend and Backend. Do not tie checks to a specific screen, field name, or feature.

Do not require this prompt merely because multiple variables exist.

Apply it only when multiple sources represent the same logical field/value at the action boundary.

---

## WHEN THIS APPLIES (SIGNALS)

Read this prompt if the diff or traced flow includes any of:

- Submit / save / search handler that combines **form or store state** with **another source** (ref/imperative API, uncontrolled input, URL/query, session, draft buffer, `getPending*`, `read*`, DOM value, etc.) for the same field.
- A **merge / resolve / normalize** helper that picks between sources for the same logical value (e.g. `pending ?? form`, ternary on empty string, spread of partial overrides).
- Comments or names implying **lag**, **pending**, **sync**, or **authoritative at action time**.
- Tests that pass both a “primary” state object and a secondary override object for the same fields.

If none of the above: skip this file.

---

## CORE SEMANTICS (GLOBAL)

At the **action boundary** (submit, save, search, API call), each field must follow an explicit contract:

| Secondary / override signal | Meaning | Typical mistake |
|----------------------------|---------|-----------------|
| **Absent** (`undefined`, key omitted, source not wired) | That source was not consulted — use the primary source (form/store/defaults) per design. | Treating absent like “user cleared”. |
| **Present, empty** (`""`, `[]`, `null` if empty means clear) | User or UI explicitly cleared — **must not** restore a stale value from a lagging primary source. | `if (!secondary) use primary` or `secondary !== "" ? secondary : primary` when secondary is `""`. |
| **Present, non-empty** | Authoritative for that action — must win over a lagging primary when they disagree. | Only testing “secondary fills empty primary”, not “secondary empty clears stale primary”. |

**Anti-pattern (any language):** using falsy checks (`!x`, `x || fallback`, `x ? x : fallback` when `x` can be `""`) to mean “no override” — empty string is a valid override.

**Required:** distinguish **absent** vs **present-empty** vs **present-value** in types and merge logic.

---

## REVIEW CHECKLIST (RUN AT ACTION BOUNDARY)

Trace the full path: **UI control → all sources → merge helper → payload / API**. Do not review the merge helper in isolation.

For **each merged field**, verify these scenarios (names are generic; map to the actual sources in the diff):

| # | Scenario | Expected at action time |
|---|----------|-------------------------|
| 1 | Secondary has new value, primary empty or stale | Secondary value used |
| 2 | Secondary explicitly empty, primary still has old value | Empty / cleared — **not** primary stale value |
| 3 | Secondary absent (not passed / ref unavailable) | Primary (or default) used |
| 4 | Only some fields use a secondary source | Per-field contract; no cross-field fallback |
| 5 | User triggers action immediately after clear or edit | Same as rows 1–2 (no debounce assumption unless spec requires it) |

Pass 5 self-challenge (mandatory when this file applies):

- “Where does **present-empty** get treated as absent and fall back to stale primary state?”
- “Was the submit/save path traced end-to-end?”

---

## IMPLEMENTATION (FRONTEND)

When adding or changing merge-at-submit behavior:

1. Type secondary overrides as `T | undefined`, not `T` with `""` meaning “skip”.
2. Merge with explicit branches: absent → primary; defined (including empty) → normalize and use.
3. After resolve, sync primary state if the product expects form and UI to match (only when repo already does this).
4. Add or extend tests for scenarios **1–3** at the merge helper or submit contract level.

---

## IMPLEMENTATION (BACKEND)

When merging request body with session, cache, or prior row:

- Same absent vs present-empty vs present-value rules.
- Do not treat empty string in the request as “field not sent” if the API uses empty to clear.
- Document which source wins on conflict.

---

## TESTING (WHEN TESTS EXIST OR ARE IN SCOPE)

For each merge helper or submit contract, include at least:

- Secondary present, primary stale → secondary wins.
- Secondary present-empty, primary stale → cleared result.
- Secondary absent → primary unchanged.

Do not only test the “fill lagging primary” direction.

---

## REPORTING

When this file applied during review, state in the report:

- **Multi-source state:** checked yes / not applicable
- Sources identified: [list]
- Scenario rows verified: [1–5] or which were N/A and why
- Finding (if any): file + line + which scenario failed
