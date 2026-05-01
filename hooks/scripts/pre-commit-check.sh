#!/bin/bash
# pre-commit-check.sh — Agentic SDLC Plugin
# Enforces ticket reference in git commit messages.
# Called by PreToolUse hook on Bash tool when a git commit is detected.

TOOL_INPUT=$(cat)
COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // ""' 2>/dev/null)

# Only intercept git commit commands
if ! echo "$COMMAND" | grep -qE "^git commit|git commit "; then
  exit 0
fi

# Extract commit message from -m flag
MSG=$(echo "$COMMAND" | grep -oP '(?<=-m ")[^"]+' | head -1)
if [ -z "$MSG" ]; then
  MSG=$(echo "$COMMAND" | grep -oP "(?<=-m ')[^']+" | head -1)
fi

# If no -m message found, allow (commit may be using an editor or -F flag)
if [ -z "$MSG" ]; then
  exit 0
fi

# ── EXEMPTED COMMIT TYPES ────────────────────────────────────────────────────
# These commit types do not require a ticket reference.
if echo "$MSG" | grep -qE "^chore\(deps\):|^chore\(memory\):|^chore\(release\):|^chore\(init\):"; then
  exit 0
fi

# ── READ TICKET FORMAT FROM TOPOLOGY ────────────────────────────────────────
TICKET_FORMAT="[A-Z]+-[0-9]+"
if [ -f "topology.yaml" ]; then
  TOPOLOGY_FORMAT=$(grep -oP '(?<=ticket_id_format: ).*' topology.yaml 2>/dev/null | head -1 | tr -d '"' | tr -d "'")
  if [ -n "$TOPOLOGY_FORMAT" ]; then
    TICKET_FORMAT="$TOPOLOGY_FORMAT"
  fi
fi

# ── TICKET REFERENCE CHECK ───────────────────────────────────────────────────
# Ticket reference must appear in the commit subject line, surrounded by brackets.
if ! echo "$MSG" | grep -qP '\['"$TICKET_FORMAT"'\]'; then
  echo '{"decision":"block","reason":"Commit message must include a ticket reference matching '"$TICKET_FORMAT"' in square brackets, e.g. [ENG-1234]. Message: '"${MSG:0:80}"'"}'
  exit 0
fi

exit 0
