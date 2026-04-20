ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG AGENT_HOME=/opt/change-me
ENV AGENT_HOME=${AGENT_HOME}

COPY agents/change-me/install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh     && /tmp/install.sh     && rm -f /tmp/install.sh

COPY agents/change-me/agenthub.sh /opt/agent/agenthub.sh
COPY agents/change-me/entrypoint.sh /opt/agent/entrypoint.sh
RUN groupadd --gid 10001 agent \
    && useradd --uid 10001 --gid 10001 --create-home --shell /bin/bash agent \
    && chmod +x /opt/agent/agenthub.sh /opt/agent/entrypoint.sh \
    && mkdir -p /workspace ${AGENT_HOME} /home/agent/.change-me \
    && chown -R agent:agent /opt/agent ${AGENT_HOME} /workspace /home/agent/.change-me

USER agent
WORKDIR /workspace
VOLUME ["/workspace"]
ENTRYPOINT ["/opt/agent/entrypoint.sh"]
CMD ["shell"]
