# Connectors

## How tool references work

Plugin files use `~~category` as a placeholder for whatever tool you connect in that category. The plugin is toolchain-agnostic — it describes workflows in terms of categories rather than specific products. The `topology.yaml` file is where you declare your actual toolchain, and agents use that declaration to route all tool interactions.

## Connectors for this plugin

| Category | Placeholder | Included Options |
|----------|-------------|------------------|
| Source control | `~~source control` | GitHub, GitLab (cloud), GitLab (self-hosted) |
| Issue tracker | `~~issue tracker` | Jira, GitHub Issues, GitLab Issues, Linear |
| Wiki / docs | `~~wiki` | Confluence, GitHub Wiki, GitLab Wiki, Notion, local markdown |
| CI/CD | `~~ci` | GitHub Actions, GitLab CI, Jenkins, CircleCI |
| Alerts | `~~alerts` | PagerDuty, OpsGenie, Slack |
| Secrets | `~~secrets` | HashiCorp Vault, AWS Secrets Manager, GitHub Secrets, GitLab CI variables |

## How to configure your toolchain

Run `/topology` to initialize your `topology.yaml`. Agents read this file at the start of every bolt to determine which MCP servers to invoke, which ticket ID format to enforce, which wiki to write to, and which CI system to monitor.

No hardcoded tool names appear in the plugin's commands, skills, or agents — everything routes through the topology declaration.
