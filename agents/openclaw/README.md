# OpenClaw agent image

This image packages the real OpenClaw CLI from the official npm package `openclaw@2026.4.14`.

Quick checks:

```bash
docker run --rm agent-hub/openclaw:dev --version
docker run --rm agent-hub/openclaw:dev gateway --help
```

Interactive shell:

```bash
docker run --rm -it agent-hub/openclaw:dev shell
```
