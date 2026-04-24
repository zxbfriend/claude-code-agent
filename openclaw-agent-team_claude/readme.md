# openclaw.json 配置说明

## 第一步：建议先做冒烟测试，确认你的环境能跑起来再修改配置文件：

```bash
# 1：确认 acpx 和 Claude Code 都装好
claude --version
acpx --version

# 2：直接用 acpx CLI 测试（不经过 OpenClaw）
acpx --approve-all claude exec "列出当前目录的文件"

# 3：通过 OpenClaw 命令测试（经过 ACP 桥接）
/acp spawn claude --mode run "Say hello"

# 4：如果两步都正常，再考虑接入 sessions_spawn
```

## 第二步：openclaw.json 启用 ACP模式

```json
{
  "acp": {
    "enabled": true,
    "backend": "acpx",
    "defaultAgent": "claude",
    "allowedAgents": ["claude"],
    "maxConcurrentSessions": 4,
    "stream": {
      "coalesceIdleMs": 300,
      "maxChunkChars": 1200
    },
    "runtime": {
      "ttlMinutes": 120
    }
  },
  "agents": {
    "list": [
      {
        "id": "backend",
        "workspace": "~/.openclaw/workspace-backend",
        "model": "claude-sonnet-4-6",
        "runtime": {
          "type": "acp",
          "agent": "claude"
        }
      },
      {
        "id": "frontend",
        "workspace": "~/.openclaw/workspace-frontend",
        "model": "claude-sonnet-4-6",
        "runtime": {
          "type": "acp",
          "agent": "claude"
        }
      },
      {
        "id": "mobile",
        "workspace": "~/.openclaw/workspace-mobile",
        "model": "claude-sonnet-4-6",
        "runtime": {
          "type": "acp",
          "agent": "claude"
        }
      }
    ]
  }
}
```

## 第三步：安装 acpx 和 Claude Code

```bash
# 安装 acpx（ACP 后端）
npm install -g acpx@latest

# 安装 acpx skill（让 agent 知道怎么用）
npx acpx@latest --skill install acpx

# 确认 Claude Code 已安装并已登录
claude --version
claude auth login
```

## 第四步：更新 Backend/Frontend/Mobile 的 SOUL.md