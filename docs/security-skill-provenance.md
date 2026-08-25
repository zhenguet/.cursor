# Security Skill Provenance

The workspace includes curated security skills derived from public repositories. They are conditionally routed and do not replace `.cursor/AGENTS.md`, `prompts/security-baseline.md`, or explicit product/security requirements.

| Local skill | Upstream source | Upstream license | Local status |
|---|---|---|---|
| `trailofbits-sharp-edges` | [Trail of Bits `sharp-edges`](https://github.com/trailofbits/skills/tree/main/plugins/sharp-edges) | CC BY-SA 4.0 | Adapted under CC BY-SA 4.0 |
| `trailofbits-variant-analysis` | [Trail of Bits `variant-analysis`](https://github.com/trailofbits/skills/tree/main/plugins/variant-analysis) | CC BY-SA 4.0 | Adapted under CC BY-SA 4.0 |
| `anthropic-devsecops-security-scanning` | [Anthropic-Cybersecurity-Skills `implementing-devsecops-security-scanning`](https://github.com/mukul975/Anthropic-Cybersecurity-Skills/tree/main/skills/implementing-devsecops-security-scanning) | Apache-2.0 | Adapted under Apache-2.0 |
| `anthropic-malicious-npm-package-triage` | [Anthropic-Cybersecurity-Skills `detecting-malicious-npm-packages`](https://github.com/mukul975/Anthropic-Cybersecurity-Skills/tree/main/skills/detecting-malicious-npm-packages) | Apache-2.0 | Adapted under Apache-2.0 |
| `anthropic-opa-policy-as-code` | [Anthropic-Cybersecurity-Skills `implementing-policy-as-code-with-open-policy-agent`](https://github.com/mukul975/Anthropic-Cybersecurity-Skills/tree/main/skills/implementing-policy-as-code-with-open-policy-agent) | Apache-2.0 | Adapted under Apache-2.0 |

## Adaptation policy

- These files are **adaptations**, not unmodified upstream copies.
- The Trail of Bits source is licensed under CC BY-SA 4.0; the local adaptations therefore retain the same license family.
- The Anthropic-Cybersecurity-Skills source repository is licensed under Apache-2.0; the local adaptations retain Apache-2.0.
- Preserve source attribution, source URL, license metadata, and the fact that the file was modified when changing an adapted skill.
- Do not imply endorsement by Trail of Bits or Anthropic/Cybersecurity-Skills.
- Upstream supporting files were intentionally not vendored unless required by the local adaptation. If a future skill depends on references/scripts/resources, import the complete dependency set or deliberately adapt the dependency and document the change here.

## Maintenance rules

- Keep local adaptations subordinate to `.cursor/AGENTS.md` and the canonical security baseline.
- Keep security routing in `AGENTS.md`, `prompts/`, and the inventory rather than embedding workspace policy into imported content.
- Re-check upstream license and provenance before adding more third-party skill content.
