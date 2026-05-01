---
description: Initialize or view the project topology
allowed-tools: Read, Write, Edit
argument-hint: [init | view | validate]
---

Initialize, view, or validate the project `topology.yaml` — the codebase context map that drives all downstream agent behavior.

## Behavior by Argument

**No argument or `view`:** Check if `topology.yaml` exists. If it does, read it and present a formatted summary of the declared toolchain. If it does not, run `init`.

**`init`:** Guide the user through creating `topology.yaml` for their project.

**`validate`:** Read the existing `topology.yaml` and check for: missing required fields, unknown provider values, inconsistent ticket ID format regex, declared MCP servers that don't match available connectors.

---

## Init: Topology Dialogue

Ask the following questions in sequence. Keep it conversational — one question at a time.

**Repos:**
"What's the primary repo we're working in? Give me the name, URL, and the main language."
Follow up: "What's your test framework? And what's the deployment target — ECS, k8s, Lambda, something else?"
Follow up: "What compliance tier? Critical (customer data, payment, auth), Standard (internal tools, analytics), or Low (scripts, experiments)?"

**Source control:**
"Are you on GitHub, GitLab (cloud), or GitLab self-hosted?"
Follow up: "What's your org or group name? And what's your default branch — main or master?"
Follow up: "Is branch protection enabled? And just to confirm — your team merges via PRs or MRs?"

**Issue tracking:**
"What are you using for tickets — Jira, GitHub Issues, GitLab Issues, Linear, or nothing?"
If Jira: "What's the project key? (e.g., ENG, PLAT, SEC)"
If any: "What does a ticket ID look like? (e.g., ENG-1234 or #42)"

**Wiki:**
"Where does your team write architecture docs and runbooks? Confluence, GitHub Wiki, GitLab Wiki, Notion, local markdown files, or nowhere yet?"
If applicable: "Where do Architecture Decision Records (ADRs) live? And runbooks?"

**CI/CD:**
"What's your CI system — GitHub Actions, GitLab CI, Jenkins, CircleCI, or something else?"
"What's the path to your pipeline config file?"

**Alerts:**
"How does on-call work — PagerDuty, OpsGenie, Slack alerts, or nothing yet?"

**Secrets:**
"How are secrets managed — HashiCorp Vault, AWS Secrets Manager, GitHub Secrets, GitLab CI variables, or something else?"

---

## Writing topology.yaml

After gathering all answers, present the complete `topology.yaml` inline and wait for confirmation before writing.

```yaml
# topology.yaml — project context map
# Read by all agents at the start of every bolt

repos:
  - name: <repo-name>
    url: <repo-url>
    primary_language: <language>
    test_framework: <framework>
    deployment_target: <target>
    compliance_tier: critical | standard | low

toolchain:

  source_control:
    provider: github | gitlab | gitlab-self-hosted
    org_or_group: <string>
    default_branch: main | master
    branch_protection: true | false
    pr_or_mr: pr | mr

  issue_tracking:
    provider: jira | github-issues | gitlab-issues | linear | none
    project_key: <string>
    ticket_url_pattern: <url-with-{id}-placeholder>
    ticket_id_format: <regex-e.g.-[A-Z]+-[0-9]+>

  wiki:
    provider: confluence | github-wiki | gitlab-wiki | notion | local | none
    space_or_path: <string>
    adr_location: <path-or-url>
    runbook_location: <path-or-url>

  ci_cd:
    provider: github-actions | gitlab-ci | jenkins | circleci | none
    pipeline_config: <path>

  alerts:
    provider: pagerduty | opsgenie | slack | none
    oncall_channel: <string>

  secrets:
    provider: vault | aws-secrets-manager | github-secrets | gitlab-ci-vars | none

mcp_overrides: {}
```

After writing, say: "topology.yaml is set. Agents will use this toolchain configuration for every bolt in this project. Run `/brief` to start your first work item."
