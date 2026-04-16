#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/openclaw/bin:/opt/node/bin:${PATH}"
openclaw --version >/dev/null
