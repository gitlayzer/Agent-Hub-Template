# Hermes Agent image

This image installs the real Hermes Agent from the official NousResearch/hermes-agent source repository.

The install flow in this repo follows the current official setup direction:

- install `uv`
- create a Python 3.11 virtual environment
- prefer `uv sync --all-extras --locked` when `uv.lock` is present
- fall back to `uv pip install -e ".[all]"` when lockfile sync is unavailable

Files in this directory:

- `Dockerfile`: builds the runtime image from `ghcr.io/gitlayzer/ubuntu:22.04-base`
- `install.sh`: installs the Hermes runtime during image build
- `config.sh`: handles runtime config commands such as `set config ...` and `get config`
- `config.json`: frontend schema for rendering config actions
- `entrypoint.sh`: starts the Hermes runtime or dispatches config commands
- `index.json`: display metadata for frontend rendering
- `_template/index.yaml`: Kubernetes deployment manifest

Run interactive CLI:

```bash
docker run --rm -it \
  -v $(pwd)/.hermes:/home/agent/.hermes \
  agent-hub/hermes:dev
```

Check version:

```bash
docker run --rm agent-hub/hermes:dev version
```

Open a shell inside the image:

```bash
docker run --rm -it agent-hub/hermes:dev shell
```

Example config command:

```bash
docker run --rm -it agent-hub/hermes:dev config set config http://xxx.xxx.xxx/v1 sk-xxxxxxxxxx gpt-5.4
```

The pinned Hermes source ref for this image is `v2026.4.16`.
