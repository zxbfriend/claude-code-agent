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

## 开发流程

严格按以下顺序实现，不跳步：

```
1. Entity 类（对应数据库表）
2. Mapper 接口（继承 BaseMapper）
3. Service 接口
4. ServiceImpl 实现类（核心业务逻辑）
5. Controller（只做参数绑定和响应封装）
6. DTO / VO 类（请求和响应的数据结构）
7. 统一异常处理（如项目中尚未存在）
8. 数据库迁移 SQL（如有表结构变更）
9. Service 层单元测试
```

---

## 代码自检清单

提交 `output/backend.md` 前，逐项确认：

**与 DESIGN.md 一致性**
- [ ] 所有接口路径、HTTP 方法与 DESIGN.md 完全一致？
- [ ] 请求参数字段名和类型与 DESIGN.md 完全一致？
- [ ] 响应结构使用了统一 `Result<T>`，字段名与 DESIGN.md 一致？

**安全性**
- [ ] 所有接口入参都加了 `@Valid` 或 `@Validated`？
- [ ] 密码字段使用 BCrypt 加密？
- [ ] 需要认证的接口加了权限控制？
- [ ] 没有硬编码的密钥或密码？

**代码质量**
- [ ] Controller 中没有业务逻辑（只有参数接收 + 调用 Service + 返回结果）？
- [ ] 没有将 Entity 直接返回给前端（必须转 VO）？
- [ ] 异常处理通过自定义异常类 + GlobalExceptionHandler 统一处理？
- [ ] 没有 `e.printStackTrace()`，统一使用日志框架（SLF4J / Logback）？

**测试**
- [ ] Service 层核心逻辑有单元测试？
- [ ] 测试覆盖了正常流程和至少 2 个异常分支？

---

## 阶段进度上报规程

执行过程中，每完成一个主要阶段，**立即**在 `output/backend.md` 的顶部追加进度记录，
同时通过 message 工具向 PM session 发送阶段消息：

```
📍 Backend 进度更新
当前阶段：{阶段名}
已完成：{已完成的内容，一句话}
下一步：{接下来要做什么}
```

上报节点（按开发顺序）：

| 节点 | 触发时机 | 上报内容 |
|------|---------|---------|
| 开始 | 读完所有输入文档，准备动手时 | "已理解需求，开始实现 Entity 和 Mapper 层" |
| 中间 | Service + Controller 层完成时 | "核心业务逻辑已实现，开始编写 DTO/VO 和异常处理" |
| 收尾 | 业务代码完成，开始写单元测试时 | "业务代码完成，正在编写单元测试" |
| 完成 | 写入 STATUS: done 前 | "所有任务完成，输出报告已写入 output/backend.md" |

> 每次上报消息简短即可，不超过 3 行。重点是让 PM 和用户知道任务在正常推进。

---

## 记忆管理

- 不需要维护长期记忆
- 每次任务独立，以文档为准，不依赖上一次的记忆

---

## 安全边界

- 不执行任何生产数据库的 DDL（只生成迁移脚本，不直接执行）
- 不在代码中硬编码任何密钥、密码、外部服务 Token
- 不删除任何现有代码，除非 TASKS.md 中明确要求