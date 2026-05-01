# Phase-by-Phase Workflow (Phases 0–6)

## Phase 0: Inception — The Brief Dialogue

**Goal:** Produce a `brief-schema.yaml` that is complete enough for an agent to work from without repeated clarification.

The dialogue is Socratic, not a form. Ask one question at a time. Follow the thread. End with a written brief the human confirms before any agent work begins.

Key questions to explore:
- What's the actual pain — the user or system impact, not the feature description?
- Which systems are likely touched?
- What does "done" look like in concrete, testable terms?
- What is explicitly out of scope?
- Does this touch compliance-sensitive areas (auth, PII, audit trails, payment data)?

**Output:** `brief-schema.yaml`

---

## Phase 1: Design — Blast Radius + Architecture Review Board

**Goal:** Understand the full impact of the change before writing a line of code.

**Blast radius agent** scans the repo graph, dependency declarations, related tickets, and relevant ADRs to produce a `blast-radius-report.json` with:
- Affected systems (list)
- Score: Low | Medium | High | Critical
- Cross-service dependencies
- Rollback complexity estimate
- Compliance flags detected in affected code

**ARB** convenes based on blast radius score and compliance flags (see dispatch rules in SKILL.md).

**Human gate** for any High or Critical blast radius, or `human_gate_required: true` in the brief.

**Output:** `blast-radius-report.json`, ARB Summary (if triggered), human approval record

---

## Phase 2: Coding — Context-Aware Generation

**Goal:** Produce implementation that is grounded in the actual codebase, not generic patterns.

Agent constraints:
- Read existing patterns before writing new ones
- Follow naming conventions in the affected files
- Generate up AND down migrations for any schema change
- Never write to `.env`, `*.pem`, `credentials.*`, `secrets.*`
- All branches: `{type}/{ticket-id}-{slug}`
- All commits: conventional commits format with ticket reference in subject line

Parallel dispatch where domains are independent (backend + frontend + tests + docs).

**Output:** Implementation branch, test suite additions

---

## Phase 3: Testing — Quality That Scales

**Goal:** Coverage that would catch a regression, not coverage that satisfies a percentage target.

Test types by change type:
- Logic change → unit tests
- API change → contract tests + integration tests
- Data model change → migration tests (up and down)
- Cross-service change → E2E smoke test
- Performance-sensitive path → load test baseline

Coverage must not decrease. Test agent reads existing test patterns and follows them.

**Output:** Test suite additions committed to the branch

---

## Phase 4: CI/CD — Intelligent Pipeline Automation

**Goal:** Pipeline that fails fast, fails informatively, and passes only when safe.

Agent monitors CI run. On failure: reads the error output, diagnoses the root cause, proposes a fix, waits for human confirmation before committing the fix.

Mandatory pipeline gates (in order):
1. Secrets scan (blocks on any detected credential)
2. Static analysis / lint
3. Unit + integration tests
4. Coverage check (delta must be ≥ 0)
5. Security scan
6. Build artifact validation

**Output:** Green CI pipeline, or structured failure report with diagnosis

---

## Phase 5: Observability — AI-Assisted, Not AI-Resolved

**Goal:** Every deployment produces observable signals; no agent autonomously resolves production incidents.

Agent responsibilities:
- Suggest log line additions for new code paths
- Verify metric instrumentation exists for new features
- Flag alert gaps (new code path with no alerting)
- Draft runbook updates for new failure modes

Human responsibilities:
- Own production alert triage
- Approve any remediation action
- Sign off on runbook changes before they go live

**Output:** Observability checklist, runbook patch (if applicable)

---

## Phase 6: Documentation — Always Current

**Goal:** Documentation that is accurate at merge time, not retrofitted months later.

Doc agent generates:
- Inline code documentation for new functions/classes
- ADR (Architecture Decision Record) if an architectural decision was made
- API documentation patch if endpoints changed
- Runbook update if operational behavior changed
- CHANGELOG entry

Documentation is committed as part of the same PR as the implementation — not a follow-up ticket.

**Output:** Documentation committed to the branch, PR description populated
