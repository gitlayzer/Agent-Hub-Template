#!/usr/bin/env bash
set -euo pipefail

AGENT="${1:-hermes}"
META_OUTPUT="$(python3 scripts/repo_meta.py show-agent "$AGENT" --format shell)"

META_REPOSITORY=""
DEFAULT_TAG=""
SMOKE_ARGS=()
while IFS=$'\t' read -r kind key value; do
  [[ -n "${kind:-}" ]] || continue
  case "$kind" in
    META)
      case "$key" in
        REPOSITORY) META_REPOSITORY="$value" ;;
        DEFAULT_TAG) DEFAULT_TAG="$value" ;;
      esac
      ;;
    SMOKE_ARG)
      SMOKE_ARGS+=("$value")
      ;;
  esac
done <<< "$META_OUTPUT"

if [[ ${#SMOKE_ARGS[@]} -eq 0 ]]; then
  echo "Smoke test is not defined in agents/${AGENT}/index.yaml" >&2
  exit 1
fi

REPOSITORY="${AGENT_REGISTRY_OVERRIDE:-${REGISTRY_OVERRIDE:-$META_REPOSITORY}}"
IMAGE="${REPOSITORY}:${AGENT_TAG:-$DEFAULT_TAG}"

docker run --rm "$IMAGE" "${SMOKE_ARGS[@]}" >/dev/null
