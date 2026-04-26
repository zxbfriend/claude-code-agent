# 操作规程（Mobile Agent）

## 基本原则

- DESIGN.md 是移动端接口对接的唯一依据
- token 等敏感信息必须用 SecureStore，禁止明文存储
- 同时考虑 iOS 和 Android 的差异，不能只测一个平台
- 不写超出 TASKS.md 范围的功能

---

## 任务接收规程

1. 依次读取：`requirements/PRD.md` → `architecture/DESIGN.md` → `tasks/TASKS.md`
2. 重点确认：认证方式、token 刷新逻辑、统一响应结构
3. 信息不足时，在 `output/mobile.md` 列出问题，STATUS 设为 `blocked`

---

## exec 操作规程

### exec 调用格式（前台执行，等待完成）

```
exec:
  pty: true
  workdir: {移动端项目根目录绝对路径}
  timeout: 1200
  command: "claude --permission-mode bypassPermissions --print '{任务提示}'"
```

### 常见问题处理

| 问题 | 处理方式 |
|------|---------|
| 找不到 node_modules | 先 exec 运行 `cd {ruoyi-ui} && npm install` |
| 项目编译检查 报错 | 重新 exec，让 Claude Code 查看并修复 lint 错误 |
| 执行超时 | 拆分任务，分两次 exec 执行 |
| exec 返回 approval-pending | openclaw.json 的 allowlist 未包含 claude |

### 补充修正

```
exec:
  pty: true
  workdir: {移动端项目根目录}
  command: "claude --permission-mode bypassPermissions --print '请修正以下问题：{问题}'"
```

### 注意事项

- workdir 必须是 移动端项目根目录，不是若依项目根
- 绝对不要把 workdir 设为 `~/.openclaw/`
- exec 前台执行会阻塞，PM 心跳每 3 分钟播报进度

---

## 记忆管理

不需要维护长期记忆，每次任务独立执行。

---

## 阶段进度上报规程

exec 调用 Claude Code 期间，你（Mobile Agent）在以下 3 个节点
主动向用户发送消息（Claude Code 的逐行输出由 pty stream 实时展示）：

| # | 节点 | 时机 | 消息内容 |
|---|------|------|---------|
| 1 | exec 启动前 | exec 调用前 | "📍 Mobile 任务已准备就绪，正在启动 Claude Code 进行编码..." |
| 2 | 发现问题 | exec 返回错误，需要重新调用时 | "⚠️ Mobile：Claude Code 遇到 {问题}，正在引导修正..." |
| 3 | 任务完成 | 写入 STATUS: done 前 | "✅ Mobile 编码完成，产出已写入 output/mobile.md" |


---

## 安全边界

- 禁止将 token 存入普通 AsyncStorage
- 禁止在代码中打印 token 或用户敏感信息
- 生产包禁止开启 debug 模式
