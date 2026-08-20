# Validation Edge-Case Examples

This is a reusable example library for validators, parsers, formatters, sanitizers, and normalization logic.

It is **reference material, not policy**. The rules live in:

- `prompts/reference-crosscheck.md` — pre-implementation risk analysis
- `prompts/testing.md` — test partitioning
- `prompts/review-output-baseline.md` — review expectations
- `prompts/frontend.md` / backend prompts — stack-specific application

When a new validation bug is found, add the smallest concrete case here first. Update a canonical rule only when the case exposes a missing general rule.

---

## 1. Email: internal whitespace

### Rule

An email field may allow surrounding whitespace to be trimmed, but internal whitespace remains invalid when the accepted format does not allow it.

### Expected

```text
"  user@example.com  " → normalized to "user@example.com"
"user@example.com"     → valid
```

### Invalid near-valid values

```text
"user name@example.com"
"user@example com"
```

### Expected result

```text
FAIL validation
```

### Why this matters

A shallow validator can pass both invalid values if it only checks:

```text
contains one '@'
local part is non-empty
 domain part is non-empty
```

---

## 2. Email: Unicode / full-width variants

### Expected

```text
"user@example.com" → valid
```

### Invalid when the contract requires ASCII-style mail syntax

```text
"user＠example.com"
"ユーザー@example.com"
```

### Expected result

```text
FAIL validation
```

---

## 3. Delimited identifier: repeated separator

### Rule

A value may allow a single separator between segments.

### Expected

```text
"ABC-123" → valid
```

### Invalid near-valid values

```text
"ABC--123"
"-ABC123"
"ABC123-"
```

### Expected result

```text
FAIL validation
```

---

## 4. Numeric range: just outside the boundary

### Rule

Accepted range:

```text
1 <= value <= 100
```

### Expected

```text
1    → valid
100  → valid
```

### Invalid boundary values

```text
0
101
```

### Expected result

```text
FAIL validation
```

---

## 5. Length limit: normalization order

### Rule

The product contract limits the normalized value to 10 characters.

### Case

```text
Input: "  1234567890  "
```

### Expected

```text
Trim first
→ "1234567890"
→ length 10
→ valid
```

A different contract might intentionally count raw input instead. The important point is to define the order explicitly and test both the boundary and normalization behavior.

---

## Extension template

```text
## N. <validation case>

### Rule
...

### Expected valid values
...

### Near-valid / deceptive invalid values
...

### Boundary / normalization variants
...

### Expected result
PASS | FAIL | UNKNOWN

### Why a shallow implementation may miss it
...
```
