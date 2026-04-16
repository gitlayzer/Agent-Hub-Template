#!/usr/bin/env bash
set -euo pipefail

BASE="${1:-ubuntu}"
META_OUTPUT="$(python3 scripts/repo_meta.py show-base "$BASE" --format shell)"

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

DOCKERFILE="base/${BASE}/Dockerfile"
REPOSITORY="${REGISTRY_OVERRIDE:-$META_REPOSITORY}"
IMAGE="${REPOSITORY}:${BASE_TAG:-$DEFAULT_TAG}"

echo "==> Building base image: $IMAGE"
docker build \
  --file "$DOCKERFILE" \
  --tag "$IMAGE" \
  .
