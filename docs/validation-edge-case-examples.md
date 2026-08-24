# Validation Edge-Case Examples

This is a small **reference example library**, not a policy source.

Canonical rules live in the applicable prompt/skill. Use this file only when a concrete example makes a general rule easier to understand or test.

## General rule

For validators, parsers, formatters, sanitizers, and normalizers, test the **decision boundary** rather than collecting isolated bug values:

```text
obviously valid
→ obviously invalid
→ near-valid false positive
→ boundary / empty
→ normalization / representation variant
```

The examples below are representative classes. Do not copy them into prompts merely because a future bug looks similar.

## Representative examples

### 1. Grammar with internal whitespace

If a field grammar does not allow internal whitespace:

```text
"user@example.com"      → valid
"  user@example.com  "  → normalize then validate, when trimming is part of the contract
"user name@example.com" → invalid
"user@example com"      → invalid
```

### 2. Unicode / full-width representation

If a contract requires ASCII-style syntax:

```text
"user@example.com" → valid
"user＠example.com" → invalid
```

If Unicode is permitted by the actual contract, these values must instead be evaluated according to that contract. Never infer acceptance rules from this example alone.

### 3. Delimited identifier

If exactly one separator is allowed between segments:

```text
"ABC-123"  → valid
"ABC--123" → invalid
"-ABC123"  → invalid
"ABC123-"  → invalid
```

### 4. Numeric boundary

For a contract such as `1 <= value <= 100`:

```text
1   → valid
100 → valid
0   → invalid
101 → invalid
```

### 5. Normalization order

If the contract limits the normalized value to 10 characters:

```text
"  1234567890  "
→ trim according to contract
→ "1234567890"
→ length 10
→ valid
```

A different contract may intentionally count raw input. The implementation must follow the actual contract, not this example.

## Async/state example class

Concrete bugs are not limited to validators. For any UI flow that derives an actionable value from asynchronous secondary data:

```text
primary data visible
+ secondary lookup pending
+ action enabled
→ unsafe: action may consume incomplete derived state
```

Safe behavior must be defined by the product contract, typically one of:

```text
disable/block action until required data is ready
OR
wait for required data at action time
OR
read authoritative data synchronously at action time
```

Also test stale-response and failed/cancelled lookup cases when the secondary data can affect the action result.

## Extension template

```text
## N. <general failure class>

### Rule
...

### Representative valid values
...

### Near-valid / deceptive invalid values
...

### Boundary / normalization / async-state variants
...

### Expected behavior
PASS | FAIL | UNKNOWN

### Why a shallow implementation may miss it
...

### Canonical owner
<prompt / skill / contract path>
```

### Maintenance rule

When a new bug is found:

1. Identify the **general failure class**.
2. Check whether an existing canonical rule already covers it.
3. If not, update the canonical owner.
4. Add a representative example here only if it materially improves understanding.
5. Do not add ticket-specific, screen-specific, or one-off values just to remember a past bug.
