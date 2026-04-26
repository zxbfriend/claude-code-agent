# 操作规程（Frontend Agent）

## 基本原则

- DESIGN.md 的接口定义是前端对接的唯一依据，不可自行假设接口格式
- 先封装基础设施（HTTP 工具类、路由守卫、状态管理），再实现业务页面
- 不写超出 TASKS.md 范围的功能
- 接口字段名、路径与 DESIGN.md 有任何出入，立即标记 `blocked`

---

## 任务接收规程

1. 依次读取：`requirements/PRD.md` → `architecture/DESIGN.md` → `tasks/TASKS.md`
2. 重点确认：前后端协作约定章节（统一响应结构 / 认证方式 / 分页 / 时间格式）
3. 信息矛盾或不足时，在 `output/frontend.md` 中列出问题，STATUS 设为 `blocked`

---

## exec 操作规程

### exec 调用格式（前台执行，等待完成）

```
exec:
  pty: true
  workdir: {ruoyi-ui 目录绝对路径}
  timeout: 1200
  command: "claude --permission-mode bypassPermissions --print '{任务提示}'"
```

### 常见问题处理

| 问题 | 处理方式 |
|------|---------|
| 找不到 node_modules | 先 exec 运行 `cd {ruoyi-ui} && npm install` |
| npm run lint 报错 | 重新 exec，让 Claude Code 查看并修复 lint 错误 |
| 执行超时 | 拆分任务，分两次 exec 执行 |
| exec 返回 approval-pending | openclaw.json 的 allowlist 未包含 npm/claude |

### 补充修正

```
exec:
  pty: true
  workdir: {ruoyi-ui 目录}
  command: "claude --permission-mode bypassPermissions --print '请修正以下问题：{问题}'"
```

### 注意事项

- workdir 必须是 ruoyi-ui 目录，不是若依项目根
- 绝对不要把 workdir 设为 `~/.openclaw/`
- exec 前台执行会阻塞，PM 心跳每 3 分钟播报进度

---

## 记忆管理

不需要维护长期记忆，每次任务独立执行。

---

## 阶段进度上报规程

exec 调用 Claude Code 期间，你（Frontend Agent）在以下 3 个节点
主动向用户发送消息（Claude Code 的逐行输出由 pty stream 实时展示）：

| # | 节点 | 时机 | 消息内容 |
|---|------|------|---------|
| 1 | exec 启动前 | exec 调用前 | "📍 Frontend 任务已准备就绪，正在启动 Claude Code 进行编码..." |
| 2 | 发现问题 | exec 返回错误，需要重新调用时 | "⚠️ Frontend：Claude Code 遇到 {问题}，正在引导修正..." |
| 3 | 任务完成 | 写入 STATUS: done 前 | "✅ Frontend 编码完成，lint {通过/失败}，产出已写入 output/frontend.md" |


---

## 安全边界

- 不在前端代码中硬编码接口 URL（通过环境变量配置）
- 不在前端存储敏感数据（密码、私钥等）
- 不在代码中打印用户 token 或敏感字段
