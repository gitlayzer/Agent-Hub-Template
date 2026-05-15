# Agent Template

This directory is the minimal scaffold for adding an Agent Hub runtime image.

## Contract

- no `config.sh`
- no `config.json`
- shared `/opt/agent/entrypoint.sh`
- runtime-specific startup logic lives in `/opt/agent/bin/start`
- `install.sh` must create `/opt/agent/bin/start`
- `Dockerfile` must keep `ENTRYPOINT ["/init", "/opt/agent/entrypoint.sh"]`
- `Dockerfile` must use `CMD ["start"]`

## Files

- `Dockerfile`: assembles the final image
- `build.env`: stores non-sensitive build-time defaults
- `install.sh`: installs the upstream runtime and writes `/opt/agent/bin/start`
- `entrypoint.sh`: shared command router
- `index.json`: Agent Hub metadata
- `deploy.yaml`: Kubernetes deployment template
- `README.md`: agent-specific usage notes

## Add A New Agent

Copy this directory, replace `change-me`, implement the real install flow, then register the new directory in `registry/agents.yaml`.

Configuration should be injected through environment variables, Secrets, ConfigMaps, or mounted files.
