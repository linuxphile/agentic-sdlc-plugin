#!/bin/bash
# session-start.sh — Agentic SDLC Plugin
# Surfaces memory index and topology at session start so Claude is
# immediately context-aware without being prompted.

OUTPUT=""

# ── TOPOLOGY ─────────────────────────────────────────────────────────────────
if [ -f "topology.yaml" ]; then
  OUTPUT+="[agentic-sdlc] topology.yaml found. Toolchain:"$'\n'
  # Extract key fields for a quick summary
  PROVIDER=$(grep -oP '(?<=provider: )(github|gitlab|gitlab-self-hosted)' topology.yaml 2>/dev/null | head -1)
  ISSUE=$(grep -oP '(?<=provider: )(jira|github-issues|gitlab-issues|linear|none)' topology.yaml 2>/dev/null | head -1)
  TIER=$(grep -oP '(?<=compliance_tier: )(critical|standard|low)' topology.yaml 2>/dev/null | head -1)
  [ -n "$PROVIDER" ] && OUTPUT+="  source_control: $PROVIDER"$'\n'
  [ -n "$ISSUE" ] && OUTPUT+="  issue_tracking: $ISSUE"$'\n'
  [ -n "$TIER" ] && OUTPUT+="  compliance_tier: $TIER"$'\n'
else
  OUTPUT+="[agentic-sdlc] No topology.yaml found. Run /topology to initialize the project toolchain."$'\n'
fi

# ── MEMORY INDEX ─────────────────────────────────────────────────────────────
if [ -f ".claude/memory/MEMORY_INDEX.md" ]; then
  ENTRY_COUNT=$(grep -c "^|" .claude/memory/MEMORY_INDEX.md 2>/dev/null || echo "0")
  OUTPUT+="[agentic-sdlc] Memory system active. $ENTRY_COUNT entries in MEMORY_INDEX.md."$'\n'
  OUTPUT+="  Read .claude/memory/MEMORY_INDEX.md to surface relevant prior decisions."$'\n'
else
  OUTPUT+="[agentic-sdlc] No memory index found. Memory will be initialized on the first bolt."$'\n'
fi

# ── STANDARDS ────────────────────────────────────────────────────────────────
if [ -f ".claude/memory/standards/STANDARDS_INDEX.md" ]; then
  STD_COUNT=$(grep -c "^| STD-" .claude/memory/standards/STANDARDS_INDEX.md 2>/dev/null || echo "0")
  OUTPUT+="[agentic-sdlc] Architectural standards registry: $STD_COUNT active standards."$'\n'
  OUTPUT+="  ARB Architect loads STANDARDS_INDEX.md before every Round 1 analysis."$'\n'
fi

# ── BRIEF STATUS ─────────────────────────────────────────────────────────────
if [ -f "brief-schema.yaml" ]; then
  TICKET=$(grep -oP '(?<=^id: ).*' brief-schema.yaml 2>/dev/null | head -1)
  TITLE=$(grep -oP '(?<=^title: ).*' brief-schema.yaml 2>/dev/null | head -1)
  OUTPUT+="[agentic-sdlc] Active brief: $TICKET — $TITLE"$'\n'
  OUTPUT+="  Run /bolt to execute the pipeline on this brief."$'\n'
fi

echo "$OUTPUT"
exit 0
