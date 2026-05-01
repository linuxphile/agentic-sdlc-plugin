# The Eight Non-Negotiables

These are structural requirements validated across every Fortune 500 implementation that has succeeded at scale. They are not guidelines. They are not suggestions.

## 1. Human Gates at Phase Boundaries

No agent autonomy for production promotions or architecture decisions with blast radius score ≥ High. When architecture review is required, the ARB convenes automatically — six specialized panelists analyze the design in parallel and produce a structured summary. The human reviews the summary and makes the final call.

**Humans own risk. Agents own preparation and analysis.**

Implementation: `human_gate_required: true` in `brief-schema.yaml` forces a gate. Blast radius score ≥ High triggers a gate automatically, regardless of the brief setting.

## 2. Immutable Audit Trails

Every agent invocation, tool call, and output is appended to a write-once, tamper-evident log. Non-negotiable for SOC 1/2, FINRA, PCI. Build this first — retrofitting it costs 3–5× more.

Implementation: Append-only JSONL file. PostToolUse hook appends every significant action. No agent has write access to existing records. Deletion requires a separate approval workflow (separation of duties).

## 3. Blast Radius Before Blast

A dedicated blast-radius analysis runs against repos, tickets, and docs to verify cross-system impact before any code is generated. No design phase proceeds without this.

Implementation: Blast radius agent dispatched as the first step of every bolt. Output is `blast-radius-report.json`. ARB dispatch rules are driven by the blast radius score.

## 4. Context-Grounded Agents Only

Agents must access live repo, issue tracker, and wiki via MCP. Generic prompts without codebase context produce generic output. RAG/grounding against your specific codebase is non-optional.

Implementation: Every agent receives `brief-schema.yaml`, `topology.yaml`, and relevant memory files. MCP servers connect to live toolchain. Agents are prohibited from speculating about code they haven't read.

## 5. Measure Relentlessly (The Right Metrics)

Do not measure lines of code. Track:
- **Cycle time:** brief to merged PR (target: hours to days, not weeks)
- **Defect escape rate:** pre vs. post AI review (agent quality signal)
- **Blast radius catches:** issues caught before merge vs. discovered in production
- **Developer NPS on agent quality:** are agents helping or producing rework?

Lines-of-code metrics create perverse incentives and mask quality regression.

## 6. Compliance-First Architecture

SOC/HIPAA/PCI constraints are built into agent prompts and hooks from day one. Agents are blocked from outputting secrets, PII, or credentials. Static output scanning runs before any artifact is committed.

Implementation: PreToolUse hooks block secrets file writes. PostToolUse hooks scan outputs for PII patterns. Compliance flags in `brief-schema.yaml` trigger additional review gates.

**Compliance is a feature, not a constraint.** It becomes a trust signal for enterprise customers.

## 7. Earn Autonomy Through Demonstrated Reliability

Don't run a 60-day pilot. Run a bolt. A single feature end-to-end, measured tightly, tells you more in three days than a two-month observation period. Expand agent autonomy in proportion to the reliability data the system generates — not in proportion to calendar time elapsed.

Teams that get 90%+ adoption got there because agents earned trust through visible, repeatable outcomes — not because leadership mandated adoption.

## 8. Closed Feedback Loops

Agents track deployment outcomes. Suggestions that led to rollbacks or incidents are flagged in `.claude/memory/lessons/`. Patterns that produce clean deployments are reinforced in `.claude/memory/patterns/`. The system should be measurably better each quarter based on outcome data — not just based on adding more agents.

Implementation: Session-end hook triggers memory write. Memory files are committed to the repo as `chore(memory):` commits, creating a traceable history of what the system learned.
