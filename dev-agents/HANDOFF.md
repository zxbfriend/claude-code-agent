# HANDOFF.md - 跨角色交接协议

本文件定义 `ProjectManager`、`RequirementsAnalyst`、`FrontendDeveloper`、`BackendDeveloper`、`CodeReviewer`、`QAEngineer` 的统一交接规范。
目标：可追踪、可复现、可验收，减少信息丢失与重复沟通。

## 1. 适用范围

1. 新功能开发
2. Bug 修复
3. 优化与重构
4. 紧急修复（Hotfix）

## 2. 与 OpenClaw 运行机制的关系

本协议属于仓库治理层，不等同于 OpenClaw 原生任务编排。

两者分工如下：

1. OpenClaw 原生层：由 `ProjectManager` 通过 `Sub-Agents` 机制调用各角色，并接收阶段结果回传
2. 仓库治理层：通过 `D:\Github\openclaw\dev-agents\handoff`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\docs` 保留研发过程证据，便于审计、复盘和人工接力

结论：

1. 正式链路以主 Agent 编排为准
2. handoff 文档是强制留痕物，不替代子 Agent 的原生执行回调

## 3. 统一状态机

所有任务必须使用以下英文状态：

1. `todo`：已创建，未开始
2. `in_progress`：处理中
3. `blocked`：被阻塞，需外部输入
4. `in_review`：等待审查
5. `in_test`：等待测试或测试中
6. `done`：完成并验收通过
7. `closed`：终止（需说明原因）

状态流转建议：
`todo -> in_progress -> in_review -> in_test -> done`：标准主流程

异常流转：

1. `any_status -> blocked`：需写 `block_reason`
2. `in_review -> in_progress`：审查未通过后回退
3. `in_test -> in_progress`：测试失败后回退
4. `any_status -> closed`：任务取消、合并或废弃

## 4. 交接最小字段（必填）

每次角色交接必须包含以下字段：

1. `task_id`：任务唯一标识
2. `from_role`：交出方角色
3. `to_role`：接收方角色
4. `status`：当前状态
5. `summary`：一句话结论
6. `scope`：本次处理范围
7. `changes`：关键变更点
8. `evidence`：证据（文档/日志/截图/报告路径）
9. `risks`：风险与影响
10. `next_action`：接收方下一步动作
11. `owner`：当前责任人
12. `updated_at`：更新时间（本地时区）

## 5. 角色交接要求

### 5.1 ProjectManager -> RequirementsAnalyst

必须提供：

1. 业务目标与成功标准
2. 范围与优先级
3. 时限与资源约束

### 5.2 `RequirementsAnalyst` -> `FrontendDeveloper` / `BackendDeveloper`

必须提供：

1. PRD 与 API 契约
2. In Scope / Out of Scope
3. 验收标准（可测试）
4. 待确认项（如有）

### 5.3 `FrontendDeveloper` / `BackendDeveloper` -> `CodeReviewer`

必须提供：

1. 变更说明（模块/文件/关键逻辑）
2. 自测结果与边界说明
3. 已知限制和技术债

### 5.4 CodeReviewer -> QAEngineer

必须提供：

1. 审查结论（`pass` / `conditional_pass` / `fail`）
2. 阻断问题与优先级
3. 建议重点回归路径

### 5.5 QAEngineer -> ProjectManager

必须提供：

1. 测试统计（total/pass/fail/blocked）
2. 失败用例与复现证据
3. 发布建议（`go` / `conditional_go` / `no_go`）

## 6. 阻塞与升级机制

出现 `blocked` 时必须追加：

1. `block_reason`：阻塞原因
2. `required_input`：解除阻塞所需输入
3. `impact`：对范围/时间/质量的影响
4. `eta_after_unblock`：解除后预计完成时间

升级规则：

1. 阻塞超过 2 小时：通知 ProjectManager
2. 阻塞超过 24 小时：升级为项目风险项
3. 阻塞超过 48 小时：触发范围/排期重评估

## 7. 验收清单（DoD）

任务进入 `done` 前，需满足：

1. 需求、实现、审查、测试产物齐全
2. 高优先级问题已修复或明确豁免
3. 测试结论与证据一致
4. 风险项已记录并有跟进责任人
5. ProjectManager 已完成最终汇总
6. 子 Agent 回调结果与文档结论一致

## 8. 文件与命名建议

1. 交接记录目录：`D:\Github\openclaw\dev-agents\handoff`
2. 交接单命名格式：`<task_id>-<from>-to-<to>.md`
3. 需求与设计文档命名格式：`<task_id>-requirements.md`、`<task_id>-api.md`、`<task_id>-design.md`
4. 报告命名格式：`<task_id>-requirements-analyst-report.md`、`<task_id>-frontend-developer-report.md`、`<task_id>-backend-developer-report.md`、`<task_id>-code-reviewer-report.md`、`<task_id>-qa-engineer-report.md`、`<task_id>-final-report.md`
5. 所有正式产物文件名都必须包含唯一 `task_id`，避免第二个任务覆盖第一个任务的文档。
6. 证据优先记录在交接单 `evidence` 字段中，必要时引用 `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports` 或外部日志位置

## 9. 阶段完成汇报规则

1. 除 `ProjectManager` 外，每个角色在阶段任务完成后，必须向 `ProjectManager` 汇报阶段完成状态。
2. 完成汇报不改变正式研发链路的 `to_role`，正式交接仍按 `RequirementsAnalyst -> FrontendDeveloper / BackendDeveloper -> CodeReviewer -> QAEngineer -> ProjectManager` 推进。
3. 完成汇报必须包含：
   - `task_id`
   - 当前角色
   - `status`
   - 已生成产物的绝对路径
   - 交接记录的绝对路径
   - 已知风险、阻塞与未完成项
   - 建议下一步
4. 如果阶段处于 `blocked`，也必须向 `ProjectManager` 汇报阻塞原因、影响范围和解除阻塞所需输入。

## 10. ProjectManager 进度跟踪与对外汇报规则

1. `ProjectManager` 下发任务后，必须持续检查子 Agent 执行进度、阶段产物、交接记录和阻塞状态。
2. 进度检查至少覆盖：
   - 当前阶段与责任角色
   - 子 Agent 是否仍在运行或已返回结果
   - `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\handoff` 中是否出现预期产物
   - 是否存在 `blocked`、超时、缺少证据或阶段回退
3. `ProjectManager` 必须按固定频率汇报：
   - 任务刚下发后，立即汇报任务已进入执行阶段、当前阶段和责任角色。
   - 正常执行中，每完成一个阶段至少汇报一次。
   - 若单个阶段持续超过 30 分钟仍未完成，必须汇报一次当前进展和下一步。
   - 若任务持续执行超过 2 小时，之后至少每 2 小时汇报一次，直到任务完成、阻塞或终止。
4. `ProjectManager` 必须在以下事件发生时立即主动向需求提出人汇报：
   - 阶段完成
   - 阶段阻塞或子 Agent 超时
   - 任务进入审查或测试
   - 发现范围变更、排期风险、质量风险或发布风险
   - 发现需求不清、验收标准冲突或需要需求提出人确认
   - 发生回退、返工、跳过阶段或任务终止
   - 用户主动询问进度
   - 最终完成或关闭
5. 进度汇报必须包含：
   - `task_id`
   - 当前阶段
   - 已完成事项
   - 正在处理事项
   - 阻塞、风险与影响
   - 下一步动作
   - 需要需求提出人确认的事项
6. 不得在没有证据的情况下向需求提出人报告“已完成”。

## 11. 执行纪律

1. 不口头交接：必须落文档
2. 不跳环节：非紧急场景必须按链路交接
3. 不省证据：结论必须可复核
4. 不藏风险：已知问题必须显式记录
5. 不混淆运行层与协议层：OpenClaw 调度与文档留痕必须同时成立



