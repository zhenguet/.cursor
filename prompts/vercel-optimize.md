# VERCEL OPTIMIZE

Read this file when the user asks to optimize a **deployed** Vercel project for cost, performance, caching, or billing — then **open and follow** `@.cursor/skills/vercel-optimize/SKILL.md` (citing this prompt alone is not enough).

Source: [vercel-labs/agent-skills — vercel-optimize](https://github.com/vercel-labs/agent-skills/tree/main/skills/vercel-optimize) (synced under `@.cursor/skills/vercel-optimize/`).

Cross-references:
- Vercel CLI auth / token setup → `@.cursor/skills/vercel-cli-with-tokens/SKILL.md`
- Deploy / preview URL → `@.cursor/skills/deploy-to-vercel/SKILL.md`
- Code-level React/Next perf (not metric-backed Vercel audit) → `@.cursor/prompts/frontend-vercel-skills.md` → `vercel-react-best-practices`

---

## WHEN TO READ

User signals (any match):

- optimize Vercel project / reduce Vercel bill / cost breakdown
- slow or expensive routes on Vercel
- Function Invocations, Build Minutes, Fast Data Transfer, ISR, middleware cost
- Core Web Vitals (Speed Insights), caching opportunities, Fluid compute, Bot Protection
- "optimize this Vercel project" (metrics-first audit per upstream skill)

**Do not** use for routine FE coding, local-only perf tweaks, or undeployed apps without user accepting a limited audit.

---

## HARD RULES (from SKILL.md)

1. **Metrics first** — run `collect-signals.mjs` → `merge-signals.mjs` and produce `signals.json` before reading source files.
2. **Deterministic gates** — only investigate candidates from `gate-investigations.mjs`; no repo-wide grep.
3. **Scope linkage** — project must be `vercel link`ed; resolve team/personal scope before `vercel metrics` / `vercel usage` / `vercel contract`.
4. **No token echo** — never put `VERCEL_TOKEN`, `--token`, or bearer tokens in commands that may appear in chat.
5. **Customer output** — print `final-message.json.body` verbatim after `render-report.mjs`; no debug fields in user-facing text.

---

## REQUIRED CONTEXT

1. Read `@.cursor/skills/vercel-optimize/SKILL.md` in full.
2. Confirm prerequisites: Node 20+, Vercel CLI v53+, `vercel login`, linked app directory, Observability Plus for route-level recommendations.
3. Run the pipeline from the linked app directory (use a fresh `RUN_DIR` per audit).
4. Stop on blockers (`frameworkSupportBlocker`, scope resolution, Observability Plus) per SKILL.md §1.1 — ask user before limited/code-only mode.
5. If implementation fixes are requested after the report, apply smallest diff per recommendation; use `frontend.md` / `backend.md` only for convention alignment in touched files.

---

## OUTPUT FORMAT

```
### Vercel Optimize — context
- Project / scope: …
- Framework support: …
- Observability Plus: …
- Run directory: …

### Pipeline status
(collect → gate → investigate → verify → render — note blockers or waivers)

### Report
(paste or path to report.md; print final-message body verbatim)

### Implementation (only if user asked to fix)
Brief diff summary per accepted recommendation.
```

If the audit cannot run (missing link, auth, quota): state blocker, residual options (limited audit / enable Observability Plus / fix scope), and do not invent metric-backed findings.

---

## DONE CHECKLIST

- [ ] `vercel-optimize/SKILL.md` read and pipeline followed
- [ ] `signals.json` exists before source investigation
- [ ] Scope/project linkage verified (no personal-vs-team metric mismatch)
- [ ] Blockers surfaced to user; no silent code-only fallback
- [ ] `render-report.mjs` output delivered; final message printed verbatim
- [ ] Recommendations cite allowed docs only; no invented savings figures
