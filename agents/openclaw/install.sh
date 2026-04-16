#!/usr/bin/env bash
set -euo pipefail

: "${OPENCLAW_VERSION:?OPENCLAW_VERSION is required}"
: "${NODE_VERSION:?NODE_VERSION is required}"

TARGETARCH="${TARGETARCH:-$(dpkg --print-architecture)}"
case "$TARGETARCH" in
  amd64|x86_64)
    NODE_ARCH="x64"
    ;;
  arm64|aarch64)
    NODE_ARCH="arm64"
    ;;
  *)
    echo "Unsupported TARGETARCH for Node.js download: $TARGETARCH" >&2
    exit 1
    ;;
esac

mkdir -p   /opt/agent/lib   /opt/node   /opt/openclaw   /home/agent/.cache/openclaw/compile-cache   /home/agent/.config/openclaw   /home/agent/.local/share/openclaw/agents/main/sessions   /home/agent/.local/share/openclaw/credentials   /workspace

chmod 700 /home/agent/.config/openclaw /home/agent/.local/share/openclaw /home/agent/.local/share/openclaw/agents /home/agent/.local/share/openclaw/agents/main /home/agent/.local/share/openclaw/agents/main/sessions /home/agent/.local/share/openclaw/credentials || true

NODE_TARBALL="node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz"
NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/${NODE_TARBALL}"

curl -fsSL "$NODE_URL" -o /tmp/node.tar.xz
rm -rf /opt/node/*
tar -xJf /tmp/node.tar.xz -C /opt/node --strip-components=1
rm -f /tmp/node.tar.xz

/opt/node/bin/npm install --global --prefix /opt/openclaw "openclaw@${OPENCLAW_VERSION}"
ln -sf /opt/openclaw/bin/openclaw /usr/local/bin/openclaw

/opt/openclaw/bin/openclaw --version >/dev/null
