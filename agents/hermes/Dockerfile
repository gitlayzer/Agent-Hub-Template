ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG HERMES_GIT_URL
ARG HERMES_REF
ARG HERMES_EXTRAS

ENV HERMES_HOME=/home/agent/.hermes \
    HERMES_SRC=/opt/hermes/src \
    HERMES_VENV=/opt/hermes/venv \
    PATH=/opt/hermes/venv/bin:$PATH

COPY agents/hermes/install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh \
    && HERMES_GIT_URL="$HERMES_GIT_URL" HERMES_REF="$HERMES_REF" HERMES_EXTRAS="$HERMES_EXTRAS" /tmp/install.sh \
    && rm -f /tmp/install.sh

COPY agents/hermes/agenthub.sh /opt/agent/agenthub.sh
COPY agents/hermes/entrypoint.sh /opt/agent/entrypoint.sh
RUN groupadd --gid 10001 agent \
    && useradd --uid 10001 --gid 10001 --create-home --shell /bin/bash agent \
    && chmod +x /opt/agent/agenthub.sh /opt/agent/entrypoint.sh \
    && mkdir -p "$HERMES_HOME" \
    && chown -R agent:agent /opt/agent /opt/hermes /workspace "$HERMES_HOME"

USER agent
WORKDIR /workspace
VOLUME ["/home/agent/.hermes"]
ENTRYPOINT ["/opt/agent/entrypoint.sh"]
CMD ["chat"]
