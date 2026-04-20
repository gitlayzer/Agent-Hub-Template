# Agent Hub Template

Registry-driven agent image repository.

This repository now follows a simplified contract:

- one fixed external base image, default `ubuntu:24.04`
- one registry file: `registry/agents.yaml`
- one agent metadata file: `agents/<name>/index.yaml`
- one local helper script per agent: `agents/<name>/agenthub.sh`

## Agent Contract

Each agent directory is expected to contain:

- `index.yaml`
- `Dockerfile`
- `install.sh`
- `entrypoint.sh`
- `agenthub.sh`
- `README.md`

Optional extra files are allowed, but the repository tooling only depends on the files above.

## Layout

```text
agents/
  _template/
  hermes/
  openclaw/
registry/
  agents.yaml
scripts/
docs/
```

## Metadata

`agents/<name>/index.yaml` is the source of truth for:

- image repository and tag
- build args passed into `docker build`
- smoke test args used by `make test-agent`

Example:

```yaml
name: hermes
image:
  repository: agent-hub/hermes
  tag: dev
build:
  args:
    HERMES_REF: v2026.4.13
smoke_test:
  - version
```

## Commands

Validate the repository:

```bash
make validate
make doctor
```

Build one agent:

```bash
make build-agent AGENT=hermes
```

Build with a different base image:

```bash
BASE_IMAGE=ubuntu:24.04 make build-agent AGENT=hermes
```

Smoke test one agent:

```bash
make test-agent AGENT=hermes
```

Build or test all enabled agents:

```bash
make build-all
make test-all
```

Scaffold a new agent:

```bash
make new-agent AGENT=my-agent
```

## Current Agents

- `hermes`
- `openclaw`

## Notes

- `build-base` is now a compatibility no-op.
- Workflow changes are intentionally left for a later pass.
