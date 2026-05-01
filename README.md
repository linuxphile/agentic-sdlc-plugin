# agentic-sdlc

**End-to-end agentic SDLC: brief → blast radius → ARB → bolt → compliant PR**

This plugin encodes a production-grade agentic software development lifecycle based on the BCG Dark Factory model, Instructure's 90%+ Claude Code adoption experience, and Fortune 500 best practices as of April 2026. It gives you a structured pipeline where a work item enters as a brief and exits as a compliant, tested pull request — with human oversight at every critical gate.

---

## The Model

Bolts replace sprints. A bolt is a compressed delivery unit: brief-in to PR-merged, measured in hours or days. The orchestrator dispatches specialist agents in parallel, enforces compliance gates unconditionally, convenes the Architecture Review Board for High+ blast radius changes, and commits institutional knowledge back to the repository after every bolt.

```
Brief → Blast Radius → [ARB] → [Human Gate] → Parallel Agents → Quality Gate → PR → Memory Write
```

---

## Commands

| Command | What it does |
|---------|-------------|
| `/brief` | Socratic dialogue to produce a `brief-schema.yaml` |
| `/bolt` | Execute the full pipeline from brief to PR |
| `/arb` | Convene a manual Architecture Review Board session |
| `/topology` | Initialize or view the project `topology.yaml` |

---

## Skills

| Skill | Triggers on |
|-------|-------------|
| `sdlc-orchestration` | Bolt execution, phase guidance, compliance architecture, audit log schema |
| `git-standards` | Branch naming, commit format, PR structure, merge strategy |
| `memory-system` | Writing/reading `.claude/memory/`, decision records, lessons, standards registry |

---

## Agents

| Agent | Role | Model |
|-------|------|-------|
| `orchestrator` | End-to-end pipeline coordination | Opus |
| `arb-architect` | System design, standards compliance, Round 3 chair | Sonnet |
| `arb-senior-engineer` | Implementation feasibility, tech debt | Sonnet |
| `arb-data-engineer` | Data model, migration safety, pipelines | Sonnet |
| `arb-infosec` | Threat model, auth, secrets, compliance | Sonnet |
| `arb-sre` | Observability, rollback, SLO impact | Sonnet |
| `arb-qa` | Testability, acceptance criteria, regression risk | Sonnet |

---

## Hooks

| Hook | Event | What it does |
|------|-------|-------------|
| `pre-write-check.sh` | PreToolUse (Write/Edit) | Blocks secrets file writes; validates branch naming |
| `pre-commit-check.sh` | PreToolUse (Bash) | Enforces ticket reference in git commit messages |
| PostToolUse prompt | PostToolUse (Write/Edit) | Secondary secrets scan on written content |
| `session-start.sh` | SessionStart | Surfaces memory index, topology, and active brief |

---

## Installation

This is a [Claude Code plugin](https://docs.claude.com/en/docs/claude-code/plugins). Install it by adding this repository as a plugin marketplace, then installing the plugin from it.

From inside Claude Code:

```
/plugin marketplace add linuxphile/agentic-sdlc-plugin
/plugin install agentic-sdlc@agentic-sdlc-plugin
```

To install from a local clone instead:

```bash
git clone https://github.com/dwmccarthy/agentic-sdlc-plugin.git
```

Then, in Claude Code:

```
/plugin marketplace add /path/to/agentic-sdlc-plugin
/plugin install agentic-sdlc@agentic-sdlc-plugin
```

Verify the install with `/plugin` — you should see `agentic-sdlc` listed as enabled, and `/brief`, `/bolt`, `/arb`, and `/topology` available as commands.

### Updating

```
/plugin marketplace update agentic-sdlc-plugin
/plugin update agentic-sdlc@agentic-sdlc-plugin
```

### Uninstalling

```
/plugin uninstall agentic-sdlc@agentic-sdlc-plugin
```

---

## Setup

### 1. Initialize your project topology

```
/topology init
```

This creates `topology.yaml` — the single file that tells every agent which tools you're using (GitHub vs. GitLab, Jira vs. Linear, etc.).

### 2. Create your first brief

```
/brief
```

The agent conducts a Socratic dialogue and writes `brief-schema.yaml`.

### 3. Run the bolt

```
/bolt
```

The orchestrator takes it from there: blast radius, ARB (if triggered), implementation, tests, PR.

---

## Toolchain Support

This plugin is toolchain-agnostic. See `CONNECTORS.md` for the full list of supported tools. Configure your toolchain by running `/topology init` — the plugin adapts to whatever you declare there.

---

## Compliance

The pipeline enforces SOC 1/2, ISO 27001, NIST AI RMF, EU AI Act, and HIPAA-compatible controls by default:

- Immutable audit trail (append-only JSONL)
- Secrets blocked unconditionally by PreToolUse hook
- PII guardrails in PostToolUse hook
- Human gates at every architecture decision and production promotion
- Blast radius scored before any code generation
- ARB convened automatically for High+ blast radius and compliance-flagged work

---

## The Architecture Review Board

When the ARB is triggered, six specialist agents analyze the design in parallel across three rounds:

**Round 1** — Independent analysis (no cross-panelist visibility)
**Round 2** — Deliberation (CORROBORATE / CHALLENGE / ESCALATE / AMPLIFY / WITHDRAW)
**Round 3** — Architect chairs synthesis, produces Panel Synthesis for human decision

Corroboration weighting determines final severity: unanimous findings are non-waivable; supermajority findings are Critical; solo InfoSec/Architect primary domain findings are High.

The human makes the final call. Always.

---

## Self-Evolving Memory

After every bolt, agents commit institutional knowledge to `.claude/memory/`:

- `decisions/` — architecture decisions with rationale and alternatives
- `lessons/` — errors, corrections, rollbacks (with prevention rules)
- `patterns/` — recurring implementation patterns
- `standards/` — ARB-derived architectural rules (enforced on all future designs)

Memory accumulates across bolts. The system gets measurably better over time.
