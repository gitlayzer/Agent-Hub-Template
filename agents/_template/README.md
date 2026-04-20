# change-me agent template

First read: `docs/adding-a-new-agent.md`

This directory is the scaffold for a new agent image.

Before you try to build it, update at least:

- `index.yaml`
- `Dockerfile`
- `install.sh`
- `agenthub.sh`
- `entrypoint.sh`
- `README.md`

Quick checklist:

- Replace placeholder metadata such as `replace-me`
- Put build defaults in `index.yaml -> build.args`
- Keep all agent-specific logic inside this directory
- Leave `enabled: false` in `registry/agents.yaml` until the image really builds and passes smoke tests

Important:

- Replace the placeholder installation logic with the real upstream agent runtime.
- Do not leave the generated agent enabled until the image builds and the smoke test passes.
- Keep agent-specific logic inside the agent directory.
