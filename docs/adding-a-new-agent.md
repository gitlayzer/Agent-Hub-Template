# 添加一个新的 Agent

当前仓库只保留目录契约，不再提供仓库级脚手架或自动化脚本。

## 新增方式

直接复制 `agents/_template` 为新的 agent 目录，然后修改里面的文件。

例如：

```text
agents/my-agent/
  index.yaml
  Dockerfile
  install.sh
  entrypoint.sh
  agenthub.sh
  README.md
```

然后在 `registry/agents.yaml` 中追加新条目：

```yaml
agents:
  - name: my-agent
    path: agents/my-agent
    enabled: false
```

## 文件职责

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

## 原则

- agent 的安装逻辑放在自己的 `install.sh`
- agent 自己的公共 shell helper 留在 `agenthub.sh`
- `registry/agents.yaml` 只负责名字、路径、启用状态
