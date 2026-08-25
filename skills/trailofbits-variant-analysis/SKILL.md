---
name: trailofbits-variant-analysis
description: >-
  Finds other instances of a known vulnerability, logic bug, or bad pattern by
  extracting its root cause and systematically generalizing the search pattern.
  Use after a concrete defect is found to prevent the same root cause from
  remaining elsewhere. Adapted from Trail of Bits variant-analysis.
source: https://github.com/trailofbits/skills/tree/main/plugins/variant-analysis
source-license: Apache-2.0
---

# Variant Analysis

Use this skill after a concrete defect is known. The goal is to generalize the
root cause rather than add another one-off bug example to workspace prompts.

## When to Use

- A vulnerability or logic bug has been confirmed and similar instances may exist.
- A new bug exposes a reusable failure pattern.
- A CodeQL or Semgrep rule should be generalized from a known instance.
- A review needs to determine whether a regression exists elsewhere in the codebase.

## When NOT to Use

- Initial vulnerability discovery with no known defect.
- Generic code review without a concrete pattern.
- Product-intent clarification.
- Fix recommendations before the root cause is understood.

## Workflow

### 1. Extract the root cause

Describe why the original code is wrong, not merely what value or file triggered it.
Identify:

- violated invariant
- trust boundary
- unsafe assumption
- input/state pattern
- missing validation or authorization
- concurrency or lifecycle condition

### 2. Create an exact match

Build the narrowest search that matches the known instance. Confirm that it finds the original defect before generalizing.

### 3. Generalize one dimension at a time

Change one element of the pattern per iteration. Review every match after each change. Stop when noise dominates the result set.

Useful dimensions include:

- alternate identifiers
- equivalent API calls
- different data types
- different lifecycle states
- equivalent validation omissions
- alternate callers or resource boundaries

### 4. Triage candidates

Classify each candidate as:

- confirmed variant
- false positive
- requires additional evidence

Do not convert similarity into a finding without evidence.

### 5. Prevent recurrence

When the root cause is reusable, update the canonical rule owner, test, validator, or security skill. Do not add a permanent list of concrete bug examples to general prompts.

## Failure modes to avoid

- Searching only the original module.
- Searching for one concrete value instead of the root cause.
- Generalizing multiple dimensions at once.
- Treating every look-alike as a vulnerability.
- Stopping after the first matching variant.
- Adding every discovered value to a global prompt instead of improving the rule.

## Output

```text
### Variant Analysis

Original finding: ...
Root cause: ...
Invariant violated: ...
Search pattern: ...
Variants checked: ...
Confirmed variants: ...
False positives: ...
Unknowns: ...
Canonical rule/test updated: ...
```
