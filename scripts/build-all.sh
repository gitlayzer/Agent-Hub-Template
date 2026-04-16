#!/usr/bin/env bash
set -euo pipefail

while read -r base; do
  [[ -n "$base" ]] || continue
  ./scripts/build-base.sh "$base"
done < <(python3 scripts/repo_meta.py list bases --enabled-only --format names)

while read -r agent; do
  [[ -n "$agent" ]] || continue
  ./scripts/build-agent.sh "$agent"
done < <(python3 scripts/repo_meta.py list agents --enabled-only --format names)
