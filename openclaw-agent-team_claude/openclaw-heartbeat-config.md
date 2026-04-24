# openclaw.json 心跳配置说明

在 `~/.openclaw/openclaw.json` 的 agents.list 中，
为 PM agent 加入以下心跳配置：

```json
{
  "agents": {
    "defaults": {
      "model": "claude-sonnet-4-6",
      "subagents": {
        "model": "claude-sonnet-4-6",
        "runTimeoutSeconds": 600
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
      }
    ]
  }
}
```

## 参数说明

| 参数 | 值 | 说明 |
|------|----|------|
| every | "3m" | 每 3 分钟触发一次心跳检查 |
| model | "claude-haiku-4-5" | 心跳用便宜模型，节省 token |
| isolatedSession | false | 需要访问 sub-agent 状态，不能用隔离 session |
| lightContext | false | 需要读取 HEARTBEAT.md 完整内容 |
| target | "last" | 发送到最后一次对话的渠道（Telegram/Slack 等）|

## 注意

- 仅 PM agent 需要配置心跳，其他执行类 agent 不需要
- `every: "3m"` 意味着最长等待 3 分钟就会收到一次状态更新
- 心跳使用 claude-haiku-4-5，成本极低（约 0.001 美元/次）
- 如果没有 sub-agent 在运行，心跳回复 HEARTBEAT_OK 后消息被自动丢弃，不会打扰用户
