#!/usr/bin/env bash
set -euo pipefail

KIND="${1:-agents}"
python3 scripts/repo_meta.py matrix "$KIND" --enabled-only
