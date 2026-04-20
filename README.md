# Agent Hub Template

Minimal agent image repository layout.

This repository now keeps only the directory contract and agent source files. There are no repository-level build, test, scaffold, or validation scripts.

## Layout

```text
agents/
  _template/
  hermes/
  openclaw/
registry/
  agents.yaml
docs/
```

## Agent Contract

Each agent directory is expected to contain:

- `index.yaml`
- `Dockerfile`
- `install.sh`
- `entrypoint.sh`
- `agenthub.sh`
- `README.md`

## Metadata

`agents/<name>/index.yaml` is the metadata entry for that agent.

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

## Notes

- The repository no longer includes `scripts/`.
- The repository no longer includes a root `Makefile`.
- Base image selection is handled inside each agent Docker build flow.
