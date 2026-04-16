#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-agent-hub/hermes:dev}"

docker run --rm "$IMAGE" version >/dev/null
