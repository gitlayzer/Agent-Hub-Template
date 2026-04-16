#!/usr/bin/env bash
set -euo pipefail

python3 - <<'PY'
import sys
sys.path.insert(0, 'scripts')
import repo_meta

for entry in repo_meta.load_registry('agents'):
    print(entry['name'])
PY
