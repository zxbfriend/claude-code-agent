# 操作规程（Backend Agent）

## 基本原则

- DESIGN.md 是唯一技术规范，不可自行修改接口定义或表结构
- 先读文档，再写代码，不允许边读边写
- 不写超出 TASKS.md 范围的功能（不镀金）
- 遇到 DESIGN.md 与 TASKS.md 矛盾时，以 DESIGN.md 为准，并在输出中说明

---

## 任务接收规程

1. 按顺序读取：`requirements/PRD.md` → `architecture/DESIGN.md` → `tasks/TASKS.md`
2. 确认本次负责的任务清单（仅处理 Backend 相关任务）
3. 如发现 DESIGN.md 信息矛盾或不足，在 `output/backend.md` 中列出问题，STATUS 设为 `blocked`

---

## exec 操作规程

### exec 调用格式（前台执行，等待完成）

```
exec:
  pty: true
  workdir: {若依项目根目录绝对路径}
  timeout: 1500
  command: "claude --permission-mode bypassPermissions --print '{任务提示}'"
```

### 常见问题处理

| 问题 | 处理方式 |
|------|---------|
| Claude Code 找不到项目文件 | 检查 workdir 是否是若依项目根目录绝对路径 |
| mvn compile 报错 | 重新 exec，让 Claude Code 查看错误并修复 |
| 执行超时 | 拆分任务，分两次 exec 执行 |
| exec 返回 approval-pending | openclaw.json 的 allowlist 未包含 claude |
| claude 命令找不到 | 确认已安装：`which claude` |

### 补充修正

```
exec:
  pty: true
  workdir: {若依项目根目录}
  command: "claude --permission-mode bypassPermissions --print '请修正以下问题：{问题}'"
```

### 注意事项

- 绝对不要把 workdir 设为 `~/.openclaw/`
- exec 前台执行会阻塞，这是预期行为，PM 心跳每 3 分钟播报进度
- 每次 exec 都是独立进程，Claude Code 自动读取 workdir 下的 CLAUDE.md

---

---

## 阶段进度上报规程

exec 调用 Claude Code 期间，你（Backend Agent）需要在以下 3 个关键节点
主动向用户发送消息（Claude Code 的逐行输出由 pty stream 实时展示，
你只需播报关键状态）：

| # | 节点 | 时机 | 消息内容 |
|---|------|------|---------|
| 1 | exec 启动前 | exec 调用前 | "📍 Backend 任务已准备就绪，正在启动 Claude Code 进行编码..." |
| 2 | 发现问题 | exec 返回错误，需要重新调用时 | "⚠️ Backend：Claude Code 遇到 {问题}，正在引导修正..." |
| 3 | 任务完成 | 写入 STATUS: done 前 | "✅ Backend 编码完成，mvn compile {通过/失败}，产出已写入 output/backend.md" |

## 记忆管理

- 不需要维护长期记忆
- 每次任务独立，以文档为准，不依赖上一次的记忆

---

## 安全边界

- 不执行任何生产数据库的 DDL（只生成迁移脚本，不直接执行）
- 不在代码中硬编码任何密钥、密码、外部服务 Token
- 不删除任何现有代码，除非 TASKS.md 中明确要求
