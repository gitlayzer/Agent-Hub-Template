#!/usr/bin/env bash
set -euo pipefail

AGENT="${1:-hermes}"
META_OUTPUT="$(python3 scripts/repo_meta.py show-agent "$AGENT" --format shell)"

META_REPOSITORY=""
DEFAULT_TAG=""
BUILD_ARG_FLAGS=()
BASE_IMAGE_VALUE="${BASE_IMAGE:-ubuntu:24.04}"

while IFS=$'\t' read -r kind key value; do
  [[ -n "${kind:-}" ]] || continue
  case "$kind" in
    META)
      case "$key" in
        REPOSITORY) META_REPOSITORY="$value" ;;
        DEFAULT_TAG) DEFAULT_TAG="$value" ;;
      esac
      ;;
    BUILD_ARG)
      override="${!key-}"
      if [[ -n "$override" ]]; then
        value="$override"
      fi
      BUILD_ARG_FLAGS+=(--build-arg "$key=$value")
      ;;
  esac
done <<< "$META_OUTPUT"

DOCKERFILE="agents/${AGENT}/Dockerfile"
REPOSITORY="${AGENT_REGISTRY_OVERRIDE:-${REGISTRY_OVERRIDE:-$META_REPOSITORY}}"
IMAGE="${REPOSITORY}:${AGENT_TAG:-$DEFAULT_TAG}"

echo "==> Building agent image: $IMAGE"
echo "    using base image: $BASE_IMAGE_VALUE"
if [[ ${#BUILD_ARG_FLAGS[@]} -gt 0 ]]; then
  echo "    build args from agent metadata:"
  for ((i=0; i<${#BUILD_ARG_FLAGS[@]}; i+=2)); do
    echo "      ${BUILD_ARG_FLAGS[i+1]}"
  done
fi

docker build \
  --build-arg BASE_IMAGE="$BASE_IMAGE_VALUE" \
  "${BUILD_ARG_FLAGS[@]}" \
  --file "$DOCKERFILE" \
  --tag "$IMAGE" \
  .
