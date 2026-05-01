---
description: Start a new work item via Socratic dialogue
allowed-tools: Read, Write, Edit
argument-hint: [optional: ticket-id or brief description]
---

Conduct a Socratic dialogue to produce a complete `brief-schema.yaml` for a new work item.

## Context Loading

Before asking any questions:
1. Check if `topology.yaml` exists in the current directory. If it does, read it — the toolchain declaration informs which fields matter most (e.g., ticket ID format, compliance tier).
2. Check if a `brief-schema.yaml` already exists. If so, ask whether the user wants to create a new brief or revise the existing one.
3. If `$ARGUMENTS` was provided, use it as the starting context (it may be a ticket ID, a short description, or a pasted problem statement).

## Socratic Dialogue Protocol

Do not present a form. Ask one question at a time. Listen to the answer before asking the next. Adapt your questions based on what you learn. The goal is to understand the problem deeply, not to fill in fields.

**Opening question:** "What's broken, missing, or needs to change — and who's feeling the pain right now?"

**Follow the thread.** Based on the answer, explore:
- The specific user or system impact (not the feature description — the actual pain)
- Whether this is a symptom of a larger issue or a standalone problem
- Which systems are likely touched (probe gently — the user may not know the full blast radius)
- What "done" looks like in concrete, testable terms
- What is explicitly out of scope
- Whether this touches any compliance-sensitive areas (auth, PII, audit trails, payment data)

**Complexity calibration:** After you understand the problem, ask: "On a scale from a one-file change to a multi-service migration, where does this land in your gut?" Use the answer to set `estimated_complexity`.

**Gate question:** "Does this need a human to review the architecture before any code gets written, or are you comfortable with agent-driven decisions on this one?" Use to set `human_gate_required`.

## Producing the Brief

Once you have enough to fill every required field, say: "I have enough to draft the brief. Let me show it to you before I write the file."

Present the brief in YAML format inline. Wait for confirmation or corrections. Then write it to `brief-schema.yaml`.

**brief-schema.yaml format:**
```yaml
id: string                    # ticket/issue ID from ~~issue tracker, or "DRAFT-001"
type: feature | bug | refactor | spike | security
title: string                 # imperative: "Add X to Y" or "Fix Z in W"
problem_statement: string     # what user pain or system failure this resolves
proposed_solution: string     # approach; leave as "TBD — agent will propose" if unknown

context:
  affected_systems: []        # services, repos, data models touched
  related_tickets: []         # upstream/downstream dependencies
  architecture_docs: []       # links to relevant ADRs, design docs

acceptance_criteria: []       # testable, binary pass/fail statements
non_goals: []                 # explicit scope boundaries

compliance_flags:
  pii_involved: false
  auth_boundary: false
  soc_relevant: false

estimated_complexity: xs | s | m | l | xl
human_gate_required: false
```

After writing, say: "Brief is ready. Run `/bolt` to execute the full pipeline, or `/arb` if you want architecture review first."
