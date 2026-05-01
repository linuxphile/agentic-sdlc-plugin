---
description: Execute a full agentic bolt (brief → PR)
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: [optional: path to brief-schema.yaml]
model: opus
---

Execute a full agentic bolt: from structured brief to a compliant, tested pull request.

## Step 1: Load Context

Read the following files before doing anything else:
1. `brief-schema.yaml` — the work item specification (path from `$ARGUMENTS` if provided, otherwise current directory)
2. `topology.yaml` — toolchain declaration and MCP routing
3. `.claude/memory/MEMORY_INDEX.md` — if it exists, scan for entries relevant to `affected_systems` or `compliance_flags` in the brief. Read matched memory files in full.
4. `.claude/memory/standards/STANDARDS_INDEX.md` — if it exists, load all active standards. These are non-waivable constraints on any design produced in this bolt.

If `brief-schema.yaml` does not exist, stop and say: "No brief found. Run `/brief` first to create one."

Surface any memory that contradicts or extends the brief before proceeding.

## Step 2: Assess and Route

Evaluate the brief:

**Blast radius check:** Identify all systems in `affected_systems`. Scan `topology.yaml` for service dependencies. Estimate blast radius: Low | Medium | High | Critical.

**Gate check:** If `human_gate_required: true` in the brief — pause here and present your blast radius assessment to the human. Wait for explicit confirmation before proceeding.

**ARB trigger rules:**
- Blast radius = Low → no ARB, proceed to coding
- Blast radius = Medium → lightweight ARB (Architect + InfoSec + most domain-relevant panelist; 2 rounds)
- Blast radius = High or Critical → full ARB (all 6 panelists, 3 rounds)
- Any `compliance_flags` set to `true` → full ARB regardless of blast radius
- Complexity = `xl` → full ARB regardless of blast radius

## Step 3: Architecture Review Board (when triggered)

Execute in strict sequence. Never compress or skip rounds. Never dispatch coding agents before ARB completes.

**Round 1:** Dispatch all triggered panelists in parallel. Provide each with: brief, topology, blast radius report, standards index, relevant memory. Wait for ALL to complete before Round 2.

**Round 2:** Dispatch all triggered panelists in parallel. Provide each with: all Round 1 outputs + deliberation instructions (CORROBORATE / CHALLENGE / ESCALATE / AMPLIFY / WITHDRAW). Wait for ALL to complete before Round 3.

**Round 3 (Architect only):** Architect synthesizes all Round 1 + Round 2 outputs into a Panel Synthesis. Apply corroboration weighting: unanimous findings are non-waivable; supermajority (4-5) are Critical; corroborated (2-3) are High; solo InfoSec/Architect primary domain findings are High; all others retain original severity; challenged-and-not-defended findings are demoted one level.

Present the ARB Summary to the human. Wait for one of: Approve / Approve with Conditions / Reject / Hold.

If Rejected → stop. Write a lesson to `.claude/memory/lessons/`.
If Approve with Conditions → document conditions. Coding agents must implement conditions as part of the bolt.

## Step 4: Implementation

Dispatch implementation agents in parallel where domains are independent:
- Backend changes and API work
- Frontend/UI changes
- Database migrations (always generate up AND down)
- Test coverage (unit, integration, contract — per topology test_framework)
- Documentation patch (inline docs + ADR if architectural decision was made)

Agent constraints:
- Never write to `.env`, `*.pem`, `credentials.*`, `secrets.*` files
- All branches must follow: `{type}/{ticket-id}-{slug}` where ticket-id format comes from `topology.yaml`
- Test coverage must not decrease
- All commits must use conventional commits format with ticket reference

## Step 5: Quality Gate

Before producing the PR:
- Confirm all acceptance criteria from the brief are verifiably met
- Confirm test suite passes
- If `soc_relevant: true` — confirm audit log entries were appended for all significant actions
- If `pii_involved: true` — confirm no PII appears in logs, error messages, or audit trail

## Step 6: Produce the PR

Generate a complete PR description using this structure:

```
## Summary
[What was built and why — one paragraph]

## Ticket
[Ticket ID and link from topology.yaml ticket_url_pattern]

## Blast Radius Report
- Affected systems: [list]
- Score: [Low | Medium | High | Critical]
- Cross-system impact verified: [Yes | No — explain]

## Changes
- [Key change 1]
- [Key change 2]

## Test Coverage
- New tests: [count and description]
- Coverage delta: [before% → after%]
- Test types: [unit / integration / contract / E2E]

## Compliance Checklist
- [ ] No secrets in code or logs
- [ ] PII handling reviewed (if applicable)
- [ ] Audit log entries written (if soc_relevant)
- [ ] Auth boundary changes reviewed (if applicable)
- [ ] Down migration exists (if schema changed)

## Rollback Plan
[How to revert this change if it causes an incident. "Revert commit X" is only acceptable for Low blast radius changes.]

## Human Review Notes
[What the reviewer should pay attention to. What tradeoffs were made. What the ARB recommended, if applicable.]
```

## Step 7: Write Memory

After the bolt completes:
- Architecture decision made → write `decisions/YYYY-MM-DD-{slug}.md`
- Error made and corrected → write `lessons/YYYY-MM-DD-{slug}.md`
- Recurring implementation pattern identified → write or update `patterns/{name}.md`
- Clean bolt, no notable events → append one-line summary to `MEMORY_INDEX.md`

Commit memory files as `chore(memory): [slug] [TICKET-ID]`.
