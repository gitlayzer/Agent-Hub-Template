#!/usr/bin/env bash
set -euo pipefail

AGENT="${1:-hermes}"
META_OUTPUT="$(python3 scripts/repo_meta.py show-agent "$AGENT" --format shell)"

BASE_NAME=""
META_REPOSITORY=""
DEFAULT_TAG=""
BUILD_ARG_FLAGS=()

while IFS=$'\t' read -r kind key value; do
  [[ -n "${kind:-}" ]] || continue
  case "$kind" in
    META)
      case "$key" in
        BASE_NAME) BASE_NAME="$value" ;;
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

if [[ -z "$BASE_NAME" ]]; then
  echo "Missing base metadata for agent: $AGENT" >&2
  exit 1
fi

BASE_META_OUTPUT="$(python3 scripts/repo_meta.py show-base "$BASE_NAME" --format shell)"
BASE_META_REPOSITORY=""
BASE_DEFAULT_TAG=""
while IFS=$'\t' read -r kind key value; do
  [[ -n "${kind:-}" ]] || continue
  if [[ "$kind" == "META" ]]; then
    case "$key" in
      REPOSITORY) BASE_META_REPOSITORY="$value" ;;
      DEFAULT_TAG) BASE_DEFAULT_TAG="$value" ;;
    esac
  fi
done <<< "$BASE_META_OUTPUT"

DOCKERFILE="agents/${AGENT}/Dockerfile"
BASE_REPOSITORY="${BASE_REGISTRY_OVERRIDE:-${REGISTRY_OVERRIDE_BASE:-$BASE_META_REPOSITORY}}"
REPOSITORY="${AGENT_REGISTRY_OVERRIDE:-${REGISTRY_OVERRIDE:-$META_REPOSITORY}}"
BASE_IMAGE="${BASE_IMAGE:-${BASE_REPOSITORY}:${BASE_TAG:-$BASE_DEFAULT_TAG}}"
IMAGE="${REPOSITORY}:${AGENT_TAG:-$DEFAULT_TAG}"

echo "==> Building agent image: $IMAGE"
echo "    using base image: $BASE_IMAGE"
if [[ ${#BUILD_ARG_FLAGS[@]} -gt 0 ]]; then
  echo "    build args from agent metadata:"
  for ((i=0; i<${#BUILD_ARG_FLAGS[@]}; i+=2)); do
    echo "      ${BUILD_ARG_FLAGS[i+1]}"
  done
fi

docker build \
  --build-arg BASE_IMAGE="$BASE_IMAGE" \
  "${BUILD_ARG_FLAGS[@]}" \
  --file "$DOCKERFILE" \
  --tag "$IMAGE" \
  .
