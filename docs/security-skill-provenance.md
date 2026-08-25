# Security Skill Provenance

The workspace includes curated security skills derived from public repositories. They are conditionally routed and do not replace `.cursor/AGENTS.md`, `prompts/security-baseline.md`, or explicit product/security requirements.

| Local skill | Upstream source | License | Adaptation |
|---|---|---|---|
| `trailofbits-sharp-edges` | Trail of Bits `sharp-edges` | CC BY-SA 4.0 | Condensed and made Cursor-workspace-specific; upstream supporting reference files were not vendored. |
| `trailofbits-variant-analysis` | Trail of Bits `variant-analysis` | CC BY-SA 4.0 | Condensed into a workspace-specific root-cause/variant workflow; upstream supporting files were not vendored. |
| `anthropic-devsecops-security-scanning` | Anthropic-Cybersecurity-Skills `implementing-devsecops-security-scanning` | Apache-2.0 | Curated for the workspace's conditional security-gate workflow. |
| `anthropic-malicious-npm-package-triage` | Anthropic-Cybersecurity-Skills `detecting-malicious-npm-packages` | Apache-2.0 | Curated for defensive npm dependency triage; destructive/offensive use is out of scope. |
| `anthropic-opa-policy-as-code` | Anthropic-Cybersecurity-Skills `implementing-policy-as-code-with-open-policy-agent` | Apache-2.0 | Curated for policy-as-code enforcement in Kubernetes/IaC/CI/CD. |

## Maintenance rules

- Preserve source URL and license information when changing an adapted skill.
- Keep local adaptations subordinate to `.cursor/AGENTS.md` and the canonical security baseline.
- Do not claim that an adapted skill is an unmodified upstream copy.
- If future work requires upstream supporting files or scripts, import the complete dependency set or deliberately adapt the skill and document the change here.
- Re-check upstream license and provenance before adding more third-party skill content.
