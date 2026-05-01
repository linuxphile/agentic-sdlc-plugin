---
description: Convene the Architecture Review Board
allowed-tools: Read, Write, Glob, Grep
argument-hint: [optional: path to brief or design doc]
model: opus
---

Convene a full Architecture Review Board (ARB) session against a brief or design document.

Use this command to trigger a manual ARB review — outside of a bolt — for major architectural decisions, RFCs, or design proposals that need cross-domain expert analysis before implementation begins.

## Step 1: Load Inputs

Read in this order:
1. `brief-schema.yaml` or design document from `$ARGUMENTS` (if provided, use that path; otherwise check current directory for `brief-schema.yaml`)
2. `topology.yaml` — for service context and compliance tier
3. `.claude/memory/standards/STANDARDS_INDEX.md` — mandatory; Architect checks standards compliance first
4. `.claude/memory/MEMORY_INDEX.md` — scan for relevant prior decisions; read matched files

If no brief or design document is found, say: "No design document found. Provide a path to a brief-schema.yaml or design doc, or run `/brief` to create one."

## Step 2: Blast Radius Assessment

Before dispatching the ARB, compute the blast radius:
- List all `affected_systems` from the brief
- Cross-reference against `topology.yaml` service graph
- Score: Low | Medium | High | Critical
- Identify any compliance flags that are set

Present the blast radius summary before dispatching panelists.

## Step 3: Round 1 — Independent Analysis

Dispatch all six panelists **in parallel**. Each panelist receives:
- The brief or design document
- `topology.yaml`
- The blast radius report
- `STANDARDS_INDEX.md`
- Relevant memory files

Each panelist produces an independent Round 1 review. **Panelists do not see each other's output until Round 2.**

Wait for ALL six Round 1 outputs before proceeding.

## Step 4: Round 2 — Deliberation

Dispatch all six panelists **in parallel** with the full set of Round 1 outputs added to their context.

Each panelist must address the following mandatory moves:
- **CORROBORATE:** Which findings from other panelists did you independently notice? (Verbatim identification, not paraphrase)
- **CHALLENGE:** Which findings do you disagree with and why?
- **ESCALATE:** Are any findings more severe when viewed through your domain lens?
- **AMPLIFY:** Do any two panelists' findings combine into a cross-domain risk neither fully articulated?
- **WITHDRAW:** Retract any Round 1 finding you now believe is incorrect, with explanation
- **OPEN QUESTIONS:** What new questions does this deliberation surface?

Wait for ALL six Round 2 outputs before proceeding.

## Step 5: Round 3 — Synthesis (Architect chairs)

Dispatch the Architect panelist with all Round 1 and Round 2 outputs. The Architect produces the Panel Synthesis.

Apply corroboration weighting:
- Unanimous (all 6): automatic Critical, non-waivable
- Supermajority (4-5): Critical, requires override documentation
- Corroborated (2-3): elevated to High
- Solo InfoSec or Architect in primary domain: High regardless
- Solo other panelist: retain original severity
- Challenged and not defended by Round 2: demote one level
- Withdrawn: remove from summary

## Step 6: ARB Summary

Format the Panel Synthesis into an ARB Summary for human decision:

```
# ARB Summary — [TICKET-ID] — [Date]

## Panel Recommendation
Vote: Approve | Approve with Conditions | Reject | Hold for Information
Confidence: High | Medium | Low
The single most important thing you need to know: [one sentence]

## Consensus Findings (corroborated by 3+ panelists)
| # | Finding | Severity | Panelists | Recommended Action |
|---|---------|----------|-----------|-------------------|

## Contested Findings (one panelist challenged another)
| # | Finding | Challenger | Challenger's Reasoning | Resolution Needed |
|---|---------|------------|----------------------|------------------|

## Cross-Domain Amplifications
[Findings where two panelists' concerns combine into a risk greater than either alone]

## Solo Findings — Elevated (InfoSec or Architect primary domain)
| # | Finding | Panelist | Severity |
|---|---------|----------|----------|

## Solo Findings — Standard
| # | Finding | Panelist | Severity |
|---|---------|----------|----------|

## Withdrawn Findings
[List with reason for withdrawal]

## Vote Shifts (Round 1 → Round 2)
[Which panelists changed their vote and why]

## Your Decision
[ ] Approve
[ ] Approve with Conditions: _______________________
[ ] Reject — reason: _______________________
[ ] Hold — need more information: _______________________
```

Present the ARB Summary. Wait for the human's decision.

After decision: write an architecture decision record to `.claude/memory/decisions/YYYY-MM-DD-{slug}.md` documenting the outcome, the panel recommendation, and the human's rationale. If the human overrode a Critical or Unanimous finding, document the override justification explicitly.

Update `STANDARDS_INDEX.md` if the ARB established any new architectural rules.
