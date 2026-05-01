---
name: memory-system
description: >
  This skill should be used when the user asks about "agent memory", "how agents
  learn", "writing a decision record", "logging a lesson learned", "updating patterns",
  "memory index", "standards registry", "MEMORY_INDEX.md", "how to persist knowledge",
  "self-evolving memory", or "what should be committed to the repo after a bolt".
  Also triggers when an agent needs to write, read, or update any file in
  `.claude/memory/`.
version: 0.1.0
---

## Repository Memory Structure

The self-evolving memory system lives in `.claude/memory/` and is committed to the repository. Every significant event in a bolt produces a memory file. These files accumulate institutional knowledge across sessions.

```
.claude/memory/
├── MEMORY_INDEX.md           # Session-start index — always read first
├── decisions/                # Architecture and design decisions
│   └── YYYY-MM-DD-{slug}.md
├── lessons/                  # Errors, corrections, rollbacks
│   └── YYYY-MM-DD-{slug}.md
├── patterns/                 # Recurring implementation patterns
│   └── {pattern-name}.md
├── context/                  # Domain knowledge, stakeholder context
│   └── {topic}.md
└── standards/                # ARB-derived architectural rules (non-waivable)
    ├── STANDARDS_INDEX.md
    └── {standard-id}.md
```

## When to Write Memory

| Event | Memory Type | Trigger |
|-------|------------|----------|
| Architecture decision made | `decisions/` | Any time a design choice has future impact |
| Error made and corrected | `lessons/` | Any correction — the error AND the fix |
| Human corrected agent approach | `lessons/` | Always; severity: medium |
| Recurring pattern identified | `patterns/` | Third time the same pattern appears |
| Bolt rolled back or hotfixed | `lessons/` | Always; severity: high |
| ARB establishes new rule | `standards/` | After every ARB decision |
| Clean bolt, no notable events | `MEMORY_INDEX.md` | One-line summary appended |

## Memory File Format

### Decision Record
```markdown
---
type: decision
date: YYYY-MM-DD
ticket: TICKET-ID
author: orchestrator | human:{name}
relevance: [system-name, pattern-name, compliance-area]
---

# Decision: [Imperative Title]

## Context
[What situation forced this decision]

## Decision
[What was decided]

## Rationale
[Why this option over the alternatives]

## Alternatives Considered
- [Alternative 1] — rejected because [reason]
- [Alternative 2] — rejected because [reason]

## Consequences
[What this decision makes easier, harder, or impossible in future]

## ARB Recommendation (if applicable)
[Panel vote and confidence level]

## Human Override (if applicable)
[If human overrode a Critical or Unanimous finding, document justification here]
```

### Lesson Learned
```markdown
---
type: lesson
date: YYYY-MM-DD
ticket: TICKET-ID
author: orchestrator | human:{name}
severity: low | medium | high
relevance: [system-name, error-category]
---

# Lesson: [What Went Wrong — One Line]

## What Happened
[Concrete description of the error or failure]

## Root Cause
[Why it happened — not surface-level]

## How It Was Caught
[Human correction | Test failure | CI failure | Production incident]

## Fix Applied
[What was done to resolve it]

## Prevention Rule
[The concrete rule to apply next time to avoid repeating this]
```

### Pattern
```markdown
---
type: pattern
name: {pattern-name}
applicable_to: [system-names, languages, contexts]
last_updated: YYYY-MM-DD
---

# Pattern: [Name]

## When to Use
[Conditions that indicate this pattern applies]

## Implementation
[Concrete description — code shape, file structure, or naming convention]

## Why This Pattern
[The problem it solves; what goes wrong without it]

## Anti-Patterns to Avoid
[Common mistakes in this area]

## Examples
[Reference to tickets or files where this was applied]
```

## Memory Read Protocol (Session Start)

At the start of every bolt:
1. Read `MEMORY_INDEX.md`
2. Match entries against the brief's `affected_systems`, `compliance_flags`, and keywords
3. Read each matched file in full
4. Surface any memory that contradicts or extends the brief before proceeding
5. Load `standards/STANDARDS_INDEX.md` — all active standards apply to this bolt

## Architectural Standards Registry

The most critical memory category. Standards are rules extracted from ARB decisions — they apply automatically to every future design, without needing a new ARB for each ticket.

`standards/STANDARDS_INDEX.md` format:
```markdown
# Architectural Standards Registry

| ID | Title | Source | Status | Enforced By |
|----|-------|--------|--------|-------------|
| STD-001 | All API endpoints require JWT auth | ARB-2026-03-15 | Active | Architect Round 1 check |
| STD-002 | No direct DB access from frontend service | ARB-2026-03-22 | Active | Architect Round 1 check |
```

The Architect panelist loads this index before every Round 1 analysis. A violation of an active standard is an automatic Reject — non-waivable, regardless of other panel votes.

## Commit Convention for Memory Files

All memory file commits use:
```
chore(memory): {type} {slug} [{TICKET-ID}]
```

Examples:
```
chore(memory): decision jwt-auth-standard [ENG-1050]
chore(memory): lesson migration-sequencing [ENG-1198]
chore(memory): pattern service-boundary-validation
```

Memory commits are never squashed — they form a traceable history of system learning.
