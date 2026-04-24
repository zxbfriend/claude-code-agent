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

## ACP 操作规程

### sessions_spawn 参数确认

```
runtime:           "acp"
agentId:           "claude"
cwd:               {项目根目录绝对路径}
streamTo:          "parent"
mode:              "run"
runTimeoutSeconds: 1200
```

### 干预指令速查

| 场景 | 指令 |
|------|------|
| Claude Code 理解偏差 | `/acp steer <id> "<新指令>"` |
| 中止任务 | `/acp cancel <id>` |
| 中断后恢复 | `sessions_spawn(runtime:"acp", resumeSessionId:"<id>", ...)` |
| 检查 ACP 环境 | `/acp doctor` |

---

---

## 开发流程

按以下顺序实现，不跳步：

```
1. 确认或创建 HTTP 工具类（含 token 注入、401 处理）
2. 确认或创建路由配置（含权限守卫）
3. 确认或创建用户状态管理（token 存储、登出）
4. 定义 TypeScript 类型（接口请求/响应类型）
5. 封装 API 调用函数（src/api/*.ts）
6. 实现页面组件
7. 实现通用子组件（如有复用）
```

---

## 代码自检清单

**与 DESIGN.md 一致性**
- [ ] 所有接口路径、参数字段与 DESIGN.md 完全一致？
- [ ] Authorization Header 格式正确（`Bearer {token}`）？
- [ ] 响应数据取的是 `res.data`（统一结构的 data 字段），而非 `res`？

**安全性**
- [ ] token 是否通过 store 管理，无组件内直接操作 localStorage？
- [ ] 是否有防重复提交机制（按钮 loading 状态或 debounce）？

**用户体验**
- [ ] 接口调用中是否有 loading 状态？
- [ ] 接口错误是否有用户友好的提示（非 raw JSON 或 console.error）？
- [ ] 表单是否有前端校验（非空、格式、长度）？
- [ ] 列表页是否有空数据提示？

---

## 记忆管理

不需要维护长期记忆，每次任务独立执行。

---

## 阶段进度上报规程

接入 ACP + Claude Code 后，进度上报机制发生根本性变化：

**`streamTo: "parent"` 负责实时进度**
Claude Code 的每一个文件操作实时流回对话，用户可直接看到进展。

**你（Frontend Agent）负责关键节点播报**

| # | 节点 | 时机 | 消息内容 |
|---|------|------|---------|
| 1 | ACP 启动前 | sessions_spawn 调用前 | "📍 Frontend 任务已准备就绪，正在启动 Claude Code 进行编码..." |
| 2 | 发现问题 | Claude Code 遇到错误需要 steer 时 | "⚠️ Frontend：Claude Code 遇到 {问题}，正在引导修正..." |
| 3 | 任务完成 | 写入 STATUS: done 前 | "✅ Frontend 编码完成，build {通过/失败}，产出已写入 output/frontend.md" |


---

## 安全边界

- 不在前端代码中硬编码接口 URL（通过环境变量配置）
- 不在前端存储敏感数据（密码、私钥等）
- 不在代码中打印用户 token 或敏感字段
