#!/usr/bin/env bash
set -euo pipefail

source /opt/agent/lib/common.sh

export PATH="/opt/openclaw/bin:/opt/node/bin:${PATH}"
export OPENCLAW_CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-/home/agent/.config/openclaw}"
export OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/home/agent/.local/share/openclaw}"

mode="${1:---help}"

case "$mode" in
  shell)
    shift || true
    log "starting interactive shell"
    exec /bin/bash "$@"
    ;;
  openclaw)
    shift || true
    exec openclaw "$@"
    ;;
  *)
    exec openclaw "$@"
    ;;
esac
