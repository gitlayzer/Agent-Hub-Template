# Agent Hub Template

面向 Sealos Devbox / Agent Hub 的 agent 镜像接入仓库。

这个仓库维护一套统一的 agent 镜像目录契约：每个 agent 可以保留自己的上游运行方式和配置方式，但镜像构建、容器入口、部署模板和元数据必须稳定一致。

## 仓库布局

```text
agents/
  _template/
  hermes-agent/
  openclaw/
  cowagent/
registry/
  agents.yaml
docs/
test/
```

## Agent 目录契约

每个 agent 目录必须提供：

- `Dockerfile`
- `build.env`
- `install.sh`
- `entrypoint.sh`
- `index.json`
- `deploy.yaml`
- `README.md`

每个 agent 目录不能再提供：

- `config.sh`
- `config.json`

运行期配置应来自环境变量、Kubernetes Secret、ConfigMap 或挂载文件，不再通过仓库统一配置脚本中转。

## 运行契约

所有 agent 使用同一条启动链路：

```text
/init
  -> /opt/agent/entrypoint.sh
    -> /opt/agent/bin/start
      -> real upstream agent runtime
```

关键规则：

- `ENTRYPOINT` 固定为 `["/init", "/opt/agent/entrypoint.sh"]`
- `CMD` 固定为 `["start"]`
- `entrypoint.sh` 必须和 `agents/_template/entrypoint.sh` 保持一致
- agent 自己的启动逻辑只写在 `/opt/agent/bin/start`
- `/opt/agent/bin/start` 由 `install.sh` 在镜像构建时生成
- `deploy.yaml` 中容器默认使用 `args: ["start"]`

共享入口会导出这些标准变量：

- `AGENT_NAME`
- `AGENT_HOME=/opt/agent`
- `AGENT_START=/opt/agent/bin/start`
- `AGENT_DATA_DIR`
- `AGENT_WORKSPACE=/workspace`
- `AGENT_PORT`
- `AGENT_LOG_LEVEL`

## 当前 Agent

- `agents/hermes-agent`: Hermes Agent gateway adapter
- `agents/openclaw`: OpenClaw gateway adapter
- `agents/cowagent`: CowAgent Web console adapter

## 镜像版本规则

GitHub Actions 会根据 `registry/agents.yaml` 生成构建矩阵。

- 分支 push 构建开发镜像：
  - `ghcr.io/<owner>/<agent>:dev-<sha12>`
  - `ghcr.io/<owner>/<agent>:dev`
- tag / 手动发布构建正式镜像：
  - `ghcr.io/<owner>/<agent>:<index.json.version>`

发布成功后，Actions 会把 enabled agents 的 `index.json.image` 和 `deploy.yaml` 镜像引用同步为最新 dev 镜像。

## 本地验证

```bash
bash test/validate-agent-contract.sh
bash test/hermes-smoke.sh
bash test/openclaw-smoke.sh
docker build -f agents/cowagent/Dockerfile -t agent-hub/cowagent:local .
```

参考：

- `docs/agent-contract.md`
- `docs/adding-a-new-agent.md`
- `docs/testing-hermes.md`
- `test/README.md`
