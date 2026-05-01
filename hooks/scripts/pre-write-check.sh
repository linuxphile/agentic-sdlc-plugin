#!/bin/bash
# pre-write-check.sh — Agentic SDLC Plugin
# Blocks writes to secrets files and validates branch naming convention.
# Called by PreToolUse hook on Write|Edit.

TOOL_INPUT=$(cat)

FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // .file_path // ""' 2>/dev/null)

# ── SECRETS FILE BLOCK ──────────────────────────────────────────────────────
# Never allow writes to secrets files — unconditional, no exceptions.
if echo "$FILE_PATH" | grep -qE "\.env$|\.env\..*|\.pem$|\.key$|credentials\..*|secrets\..*|\.vault-token$"; then
  echo '{"decision":"block","reason":"Secrets file writes are blocked by the agentic-sdlc policy. Use environment variable injection or a secrets manager instead. File: '"$FILE_PATH"'"}'
  exit 0
fi

# ── BRANCH NAMING VALIDATION ─────────────────────────────────────────────────
# Read ticket_id_format from topology.yaml if present — default to Jira-style.
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
TICKET_FORMAT="[A-Z]+-[0-9]+"

if [ -f "topology.yaml" ]; then
  TOPOLOGY_FORMAT=$(grep -oP '(?<=ticket_id_format: ).*' topology.yaml 2>/dev/null | head -1 | tr -d '"' | tr -d "'")
  if [ -n "$TOPOLOGY_FORMAT" ]; then
    TICKET_FORMAT="$TOPOLOGY_FORMAT"
  fi
fi

if [[ -n "$BRANCH" && "$BRANCH" != "main" && "$BRANCH" != "master" && "$BRANCH" != "HEAD" ]]; then
  VALID_TYPES="^(feature|fix|refactor|chore|spike|release|hotfix)/"
  if ! echo "$BRANCH" | grep -qE "$VALID_TYPES"; then
    echo '{"decision":"block","reason":"Branch name does not follow the required convention: {type}/{ticket-id}-{slug}. Valid types: feature, fix, refactor, chore, spike, release, hotfix. Current branch: '"$BRANCH"'"}'
    exit 0
  fi
fi

exit 0
