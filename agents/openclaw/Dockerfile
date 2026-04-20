ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG OPENCLAW_VERSION
ARG NODE_VERSION
ARG TARGETARCH

ENV OPENCLAW_CONFIG_DIR=/home/agent/.config/openclaw     OPENCLAW_STATE_DIR=/home/agent/.local/share/openclaw     OPENCLAW_INSTALL_PREFIX=/opt/openclaw     NODE_COMPILE_CACHE=/home/agent/.cache/openclaw/compile-cache     OPENCLAW_NO_RESPAWN=1     PATH=/opt/openclaw/bin:/opt/node/bin:$PATH

COPY agents/openclaw/install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh     && OPENCLAW_VERSION="$OPENCLAW_VERSION" NODE_VERSION="$NODE_VERSION" TARGETARCH="$TARGETARCH" /tmp/install.sh     && rm -f /tmp/install.sh

COPY agents/openclaw/agenthub.sh /opt/agent/agenthub.sh
COPY agents/openclaw/entrypoint.sh /opt/agent/entrypoint.sh
RUN groupadd --gid 10001 agent \
    && useradd --uid 10001 --gid 10001 --create-home --shell /bin/bash agent \
    && chmod +x /opt/agent/agenthub.sh /opt/agent/entrypoint.sh \
    && mkdir -p "$OPENCLAW_CONFIG_DIR" "$OPENCLAW_STATE_DIR" "$NODE_COMPILE_CACHE" /workspace \
    && chown -R agent:agent /opt/agent /opt/openclaw /opt/node /workspace /home/agent/.config /home/agent/.local /home/agent/.cache

USER agent
WORKDIR /workspace
VOLUME ["/home/agent/.config/openclaw", "/home/agent/.local/share/openclaw"]
ENTRYPOINT ["/opt/agent/entrypoint.sh"]
CMD ["--help"]
