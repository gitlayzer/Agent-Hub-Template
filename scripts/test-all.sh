#!/usr/bin/env bash
set -euo pipefail

while read -r agent; do
  [[ -n "$agent" ]] || continue
  ./scripts/test-agent.sh "$agent"
done < <(python3 scripts/repo_meta.py list agents --enabled-only --format names)
