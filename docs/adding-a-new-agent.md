# 添加一个新的 Agent

现在仓库的接入规则已经收敛成一套更小的契约：

- 不再维护仓库内的 `base/` 目录
- 不再维护 `registry/bases.yaml`
- 不再依赖 `shared/`
- 每个 agent 自己带 `agenthub.sh`
- 元数据入口统一为 `agents/<name>/index.yaml`

## 最短路径

```bash
make new-agent AGENT=my-agent
```

然后只做这几件事：

1. 修改 `agents/my-agent/index.yaml`
2. 实现 `agents/my-agent/install.sh`
3. 修改 `agents/my-agent/Dockerfile`
4. 修改 `agents/my-agent/agenthub.sh`
5. 修改 `agents/my-agent/entrypoint.sh`
6. 运行：

```bash
make doctor
make build-agent AGENT=my-agent
make test-agent AGENT=my-agent
```

7. 通过后再把 `registry/agents.yaml` 里的 `enabled: false` 改成 `enabled: true`

## 目录要求

每个 agent 至少包含：

```text
agents/<name>/
  index.yaml
  Dockerfile
  install.sh
  entrypoint.sh
  agenthub.sh
  README.md
```

这些文件的职责：

- `index.yaml`
  - 记录镜像名、tag、构建参数、smoke test 参数
- `Dockerfile`
  - 定义最终镜像如何组装
- `install.sh`
  - 定义真实安装过程
- `entrypoint.sh`
  - 定义容器启动行为
- `agenthub.sh`
  - 放这个 agent 自己需要的公共 shell helper
- `README.md`
  - 记录这个 agent 的说明和用法

## index.yaml 示例

```yaml
name: my-agent
image:
  repository: agent-hub/my-agent
  tag: dev
build:
  args:
    MY_AGENT_VERSION: 1.2.3
smoke_test:
  - --version
metadata:
  description: Real MyAgent runtime image.
  category: custom-agent
```

说明：

- `build.args` 会自动传给 `docker build`
- `smoke_test` 会自动传给 `docker run --rm <image> ...`

## 关于 base image

仓库现在默认使用固定外部 base image：

```bash
ubuntu:24.04
```

如果某次构建需要临时覆盖，可以这样执行：

```bash
BASE_IMAGE=ubuntu:24.04 make build-agent AGENT=my-agent
```

## 原则

- agent 的安装逻辑必须放在自己的 `install.sh`
- 共享 helper 如果只服务单个 agent，就留在该 agent 的 `agenthub.sh`
- `registry/agents.yaml` 只负责名字、路径、启用状态
- 先让 `make build-agent` 和 `make test-agent` 通过，再启用
