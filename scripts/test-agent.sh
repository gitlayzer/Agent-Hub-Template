#!/usr/bin/env bash
set -euo pipefail

AGENT="${1:-hermes}"
META_OUTPUT="$(python3 scripts/repo_meta.py show-agent "$AGENT" --format shell)"

META_REPOSITORY=""
DEFAULT_TAG=""
while IFS=$'\t' read -r kind key value; do
  [[ -n "${kind:-}" ]] || continue
  if [[ "$kind" == "META" ]]; then
    case "$key" in
      REPOSITORY) META_REPOSITORY="$value" ;;
      DEFAULT_TAG) DEFAULT_TAG="$value" ;;
    esac
  fi
done <<< "$META_OUTPUT"

TEST_SCRIPT="agents/${AGENT}/tests/smoke.sh"
if [[ ! -x "$TEST_SCRIPT" ]]; then
  echo "Test script missing or not executable: $TEST_SCRIPT" >&2
  exit 1
fi

REPOSITORY="${AGENT_REGISTRY_OVERRIDE:-${REGISTRY_OVERRIDE:-$META_REPOSITORY}}"
IMAGE="${REPOSITORY}:${AGENT_TAG:-$DEFAULT_TAG}"

"$TEST_SCRIPT" "$IMAGE"
