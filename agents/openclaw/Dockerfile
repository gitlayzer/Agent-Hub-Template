ARG BASE_IMAGE=agent-hub/base-ubuntu:dev
FROM ${BASE_IMAGE}

ARG OPENCLAW_VERSION=2026.4.14
ARG NODE_VERSION=24.14.1
ARG TARGETARCH

ENV OPENCLAW_CONFIG_DIR=/home/agent/.config/openclaw     OPENCLAW_STATE_DIR=/home/agent/.local/share/openclaw     OPENCLAW_INSTALL_PREFIX=/opt/openclaw     NODE_COMPILE_CACHE=/home/agent/.cache/openclaw/compile-cache     OPENCLAW_NO_RESPAWN=1     PATH=/opt/openclaw/bin:/opt/node/bin:$PATH

COPY shared/scripts/common.sh /opt/agent/lib/common.sh
COPY agents/openclaw/install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh     && OPENCLAW_VERSION="$OPENCLAW_VERSION" NODE_VERSION="$NODE_VERSION" TARGETARCH="$TARGETARCH" /tmp/install.sh     && rm -f /tmp/install.sh

COPY agents/openclaw/entrypoint.sh /opt/agent/entrypoint.sh
COPY agents/openclaw/healthcheck.sh /opt/agent/healthcheck.sh
RUN chmod +x /opt/agent/lib/common.sh /opt/agent/entrypoint.sh /opt/agent/healthcheck.sh     && mkdir -p "$OPENCLAW_CONFIG_DIR" "$OPENCLAW_STATE_DIR" "$NODE_COMPILE_CACHE" /workspace     && chown -R agent:agent /opt/agent /opt/openclaw /opt/node /workspace /home/agent/.config /home/agent/.local /home/agent/.cache

USER agent
WORKDIR /workspace
VOLUME ["/home/agent/.config/openclaw", "/home/agent/.local/share/openclaw"]
HEALTHCHECK --interval=30s --timeout=10s --start-period=20s --retries=3 CMD ["/opt/agent/healthcheck.sh"]
ENTRYPOINT ["/opt/agent/entrypoint.sh"]
CMD ["--help"]
