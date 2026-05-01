---
name: sdlc-orchestration
description: >
  This skill should be used when the user asks to "run a bolt", "execute the SDLC
  workflow", "start an agentic pipeline", "orchestrate agents", "check blast radius",
  "route a work item", or needs guidance on the agentic SDLC phases (Inception,
  Construction, Operation), the dark factory model, or how to dispatch and sequence
  specialist agents. Also triggers when the user asks about the eight non-negotiables,
  compliance architecture, governance model cards, or the audit log schema.
version: 0.1.0
---

## Mental Model

The agentic SDLC has one fundamental shift: the developer moves from **conductor** (one expert, sequential execution) to **orchestrator** (ensemble of agents, parallel workstreams). The orchestrator's leverage is proportional to how well they define the work — not how well they write the code.

**The new bottleneck is idea clarity, not coding velocity.**

## The Three Phases (BCG Dark Factory Model)

```
INCEPTION              CONSTRUCTION           OPERATION
─────────────          ─────────────          ─────────────
Business intent →      Agents generate:       Agents:
  structured brief       Implementation         Monitor production
                         Code                   Triage alerts
Agents challenge:        Tests                  Detect regressions
  Assumptions            Docs
  Blast radius                                Humans:
  Gaps                 Humans validate:         Own escalation
                         Architecture           Approve remediation
Humans approve:          PR reviews
  Architecture           Security gates
  Work breakdown
```

The **bolt** is the atomic delivery unit — brief-in to PR-merged, measured in hours or days.

## Orchestration Sequence

For every bolt, execute in this order:

1. **Load context** — read `brief-schema.yaml`, `topology.yaml`, and relevant memory files from `.claude/memory/MEMORY_INDEX.md`
2. **Blast radius check** — scan affected systems before any code is generated
3. **ARB dispatch** (if triggered) — full 3-round deliberation; never skip or compress
4. **Human gate** (if required) — present and wait; do not proceed until approved
5. **Parallel implementation** — dispatch independent agents in parallel
6. **Quality gate** — verify acceptance criteria, test coverage, compliance checklist
7. **PR production** — structured 8-section PR description
8. **Memory write** — commit lessons, decisions, and patterns to `.claude/memory/`

## ARB Dispatch Rules

| Condition | ARB Mode |
|-----------|----------|
| Blast radius = Low | No ARB |
| Blast radius = Medium | Lightweight (Architect + InfoSec + domain panelist; 2 rounds) |
| Blast radius = High or Critical | Full ARB (6 panelists, 3 rounds) |
| Any compliance flag set | Full ARB regardless of blast radius |
| Complexity = xl | Full ARB regardless of blast radius |
| Mid-bolt architecture surprise | Pause, dispatch full ARB |

## The Eight Non-Negotiables

See `references/eight-non-negotiables.md` for full detail. Summary:

1. **Human gates at phase boundaries** — no autonomous production promotion or High+ blast radius decisions
2. **Immutable audit trails** — built first, not retrofitted
3. **Blast radius before blast** — dedicated scan before any code generation
4. **Context-grounded agents only** — live repo + ticket + wiki via MCP; no generic prompts
5. **Measure relentlessly** — cycle time, defect escape rate, blast radius catches, developer NPS
6. **Compliance-first architecture** — SOC/HIPAA/PCI in agent prompts and hooks from day one
7. **Earn autonomy through demonstrated reliability** — expand agent scope with data, not calendar time
8. **Closed feedback loops** — agents track deployment outcomes; system improves each quarter

## Phase Guide

See `references/phases.md` for the full phase-by-phase workflow (Phases 0–6).

## Schemas

- Brief schema: `references/brief-schema.yaml`
- Topology schema: `references/topology-schema.yaml`

## Compliance Framework Mapping

| Framework | Constraint | Implementation |
|-----------|-----------|----------------|
| SOC 1/2 Type II | Immutable audit trail; human sign-off | Append-only log + mandatory human gate hooks |
| ISO 27001 | Risk assessment; least-privilege | Blast radius scoring + scoped MCP tokens |
| NIST AI RMF | Model governance; explainability | Model cards per agent; reasoning exposed to reviewers |
| EU AI Act | Human oversight; high-risk classification | All production gates human-owned |
| HIPAA | PII scanning; data residency | Output guardrails in PostToolUse hooks |

## Audit Log Schema

Every agent action appends a structured record. The log is append-only — no agent has write access to existing records.

```json
{
  "timestamp": "ISO8601",
  "session_id": "uuid",
  "agent_role": "orchestrator | spec | blast-radius | backend | ...",
  "action_type": "tool_call | decision | output | human_gate",
  "tool_name": "Write | mcp__...__create_pr | ...",
  "tool_input_hash": "sha256",
  "outcome": "success | denied | modified | escalated",
  "ticket_id": "TICKET-1234",
  "actor": "claude-sonnet-4-6 | human:{name}",
  "rationale": "string"
}
```
