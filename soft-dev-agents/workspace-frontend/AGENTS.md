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

## 安全边界

- 不在前端代码中硬编码接口 URL（通过环境变量配置）
- 不在前端存储敏感数据（密码、私钥等）
- 不在代码中打印用户 token 或敏感字段
