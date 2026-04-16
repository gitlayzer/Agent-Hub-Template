#!/usr/bin/env bash
set -euo pipefail

AGENT="${1:-}"

if [[ -z "$AGENT" ]]; then
  echo "Usage: $0 <agent-name>" >&2
  exit 1
fi

TARGET="agents/${AGENT}"
if [[ -e "$TARGET" ]]; then
  echo "Target already exists: $TARGET" >&2
  exit 1
fi

cp -R agents/_template "$TARGET"

AGENT_NAME="$AGENT" TARGET_DIR="$TARGET" python3 - <<'PY'
import os
from pathlib import Path

agent = os.environ['AGENT_NAME']
target = Path(os.environ['TARGET_DIR'])
for path in target.rglob('*'):
    if path.is_file():
        text = path.read_text()
        text = text.replace('change-me', agent)
        path.write_text(text)
PY

cat >> registry/agents.yaml <<EOF
  - name: ${AGENT}
    path: agents/${AGENT}
    enabled: false
EOF

cat <<EOF
Created new agent scaffold at ${TARGET}
Registered ${AGENT} in registry/agents.yaml with enabled: false

Next steps:
  1. Read docs/adding-a-new-agent.md
  2. Update ${TARGET}/agent.yaml
  3. Implement ${TARGET}/install.sh
  4. Update ${TARGET}/Dockerfile, entrypoint.sh, healthcheck.sh, tests/smoke.sh
  5. Run: make validate
  6. Run: make build-agent AGENT=${AGENT}
  7. Run: make test-agent AGENT=${AGENT}
  8. Set enabled: true only after the agent really builds and passes smoke tests
EOF
