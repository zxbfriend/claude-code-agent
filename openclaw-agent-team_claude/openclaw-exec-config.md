# openclaw.json 需要新增的 exec 配置

将以下 `tools` 字段合并到 `~/.openclaw/openclaw.json` 顶层：

```json
{
  "tools": {
    "exec": {
      "security": "allowlist",
      "ask": "on-miss",
      "allowlist": [
        "claude",
        "mvn",
        "npm",
        "git",
        "openclaw"
      ]
    }
  },
  "agents": {
    "defaults": {
      "model": "claude-sonnet-4-6",
      "subagents": {
        "model": "claude-sonnet-4-6",
        "runTimeoutSeconds": 1800
      }
    },
    "list": [
      {
        "id": "pm",
        "workspace": "~/.openclaw/workspace-pm",
        "model": "claude-opus-4-6",
        "heartbeat": {
          "every": "3m",
          "model": "claude-haiku-4-5",
          "isolatedSession": false,
          "lightContext": false,
          "target": "last"
        }
      },
      {
        "id": "architect",
        "workspace": "~/.openclaw/workspace-architect",
        "model": "claude-opus-4-6"
      },
      {
        "id": "backend",
        "workspace": "~/.openclaw/workspace-backend",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "frontend",
        "workspace": "~/.openclaw/workspace-frontend",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "mobile",
        "workspace": "~/.openclaw/workspace-mobile",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "qa",
        "workspace": "~/.openclaw/workspace-qa",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "reviewer",
        "workspace": "~/.openclaw/workspace-reviewer",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "dba",
        "workspace": "~/.openclaw/workspace-dba",
        "model": "claude-haiku-4-5"
      },
      {
        "id": "devops",
        "workspace": "~/.openclaw/workspace-devops",
        "model": "claude-haiku-4-5"
      },
      {
        "id": "doc",
        "workspace": "~/.openclaw/workspace-doc",
        "model": "claude-haiku-4-5"
      }
    ]
  },
  "bindings": [
    { "agentId": "pm", "match": { "channel": "telegram" } }
  ]
}
```

## 关键配置说明

| 配置项 | 值 | 说明 |
|--------|-----|------|
| `tools.exec.security` | `"allowlist"` | 只允许白名单内命令，白名单外命令需审批 |
| `tools.exec.ask` | `"on-miss"` | 白名单内自动执行，白名单外触发审批 |
| `tools.exec.allowlist` | `["claude","mvn","npm",...]` | claude 必须在白名单，否则被拦截 |
| `subagents.runTimeoutSeconds` | `1800` | 全局 sub-agent 超时 30 分钟，适应编码任务 |

## 配置生效步骤

```bash
# 1. 确认 Claude Code 已登录
claude auth login
claude auth status --text

# 2. 修改 openclaw.json（或通过命令行）
openclaw config set tools.exec.security "allowlist"
openclaw config set tools.exec.ask "on-miss"
openclaw config patch tools.exec.allowlist '["claude","mvn","npm","git","openclaw"]'

# 3. 重启 Gateway
openclaw restart

# 4. 验证 exec 权限（问 PM agent 执行一条简单命令）
# 发给 PM：执行 claude --version 看一下版本
```

## 注意

exec 的 per-agent 配置有已知 Bug（Issue #11832 被静默忽略），
**必须在顶层 `tools.exec` 全局配置**，不要写在 `agents.list[n].tools.exec` 里。
