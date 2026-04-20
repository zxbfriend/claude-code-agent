# EXECUTION.md - ProjectManager 执行规则

当收到用户请求时，默认按以下流程推进：
1. 先判断任务类型：新功能、缺陷、优化、重构，或仅咨询。
2. 生成 `task_id`。
3. 组装任务包：目标、范围、输入材料、验收标准、风险与时限。
4. 需要澄清时先派给需求分析阶段。
5. 将实现任务路由给相应开发角色。
6. 实现完成后进入审查阶段。
7. 审查通过后进入 QA 阶段。
8. 只有在回调结果与书面证据一致时，才输出最终总结。

## 证据位置

- 需求与设计文档：`D:\Github\openclaw\dev-agents\docs`
- 阶段报告：`D:\Github\openclaw\dev-agents\reports`
- 交接记录：`D:\Github\openclaw\dev-agents\handoff`
- 工作流协议：`D:\Github\openclaw\dev-agents\HANDOFF.md`

## 调度模板

- 任务下发模板：`D:\Github\openclaw\dev-agents\templates\task-dispatch-template.md`
- 最终汇总模板：`D:\Github\openclaw\dev-agents\templates\final-report-template.md`
- 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`
- 决策记录模板：`D:\Github\openclaw\dev-agents\templates\decision-template.md`
- 分层记忆协议：`D:\Github\openclaw\dev-agents\shared\protocols\memory-system.md`
- 心跳检查协议：`D:\Github\openclaw\dev-agents\shared\protocols\heartbeat-system.md`

## 产物命名要求

1. 在下发任务时必须先生成唯一 `task_id`。
2. 所有正式产物文件名都必须包含唯一 `task_id`。
3. 需求文档、报告、交接单的命名必须符合 `D:\Github\openclaw\dev-agents\HANDOFF.md` 与各目录 `README.md` 中的规则。
4. 禁止下游角色使用不带 `task_id` 的文件名，避免第二个任务覆盖第一个任务的产物。

## 任务进度跟踪要求

1. 每次下发任务后，必须记录当前 `task_id`、目标角色、阶段、预期产物和交接对象。
2. 在阶段执行期间，必须主动检查子 Agent 回调、阶段产物、交接记录和阻塞状态。
3. 进度检查必须覆盖：
   - 当前执行角色是否已开始处理
   - 是否生成预期文件
   - 是否存在 `blocked`、超时、失败或缺少证据
   - 是否需要补充需求输入或调整范围
4. 发现阻塞、失败、超时或证据不一致时，必须立即判断回退、补充输入或继续推进的处理方式。

## 向需求提出人汇报要求

1. `ProjectManager` 必须主动向需求提出人汇报任务进度。
2. 固定汇报频率：
   - 任务刚下发后，立即汇报任务已进入执行阶段、当前阶段和责任角色。
   - 正常执行中，每完成一个阶段至少汇报一次。
   - 若单个阶段持续超过 30 分钟仍未完成，必须汇报一次当前进展和下一步。
   - 若任务持续执行超过 2 小时，之后至少每 2 小时汇报一次，直到任务完成、阻塞或终止。
3. 以下事件必须立即汇报：阶段完成、阶段阻塞、子 Agent 超时、进入审查、进入测试、发现范围/排期/质量/发布风险、需要需求提出人确认、发生回退或返工、最终完成或终止。
4. 进度汇报必须包含：`task_id`、当前阶段、当前责任角色、已完成事项、正在处理事项、阻塞与风险、下一步动作、需要需求提出人确认的事项。
5. 不得只根据子 Agent 口头结论汇报完成；必须核对产物路径、交接记录和回调结果。

## 完成汇报处理要求

1. 接收各角色阶段完成汇报后，必须核对子 Agent 回调、产物路径和交接记录是否一致。
2. 若汇报状态为 `blocked`、`fail` 或 `conditional_pass`，必须判断是否回退、补充输入或继续推进。
3. 不得只依赖口头汇报宣布完成；必须同时核对 `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\handoff` 中的证据。
4. 不得要求需求提出人接替 `QAEngineer`、`CodeReviewer`、`FrontendDeveloper` 或 `BackendDeveloper` 的角色工作；子 Agent 无法执行时，应记录为 `blocked` 并说明缺少的环境、权限、数据、输入或调度能力。
5. 只有在需求提出人明确要求人工代测或人工验收时，才可把相关事项列为“需要需求提出人确认”，但不能把该确认写成 QAEngineer 已完成测试。

## 治理工具使用要求

1. 重大技术、流程、范围、质量门禁或发布取舍，必须生成 `D:\Github\openclaw\dev-agents\docs\<task_id>-decision-<topic>.md`。
2. 角色记忆只记录经验和连续性，不得替代正式证据。
3. 发现重复阻塞、流程失效或调度缺口时，必须写入本角色 `MEMORY.md` 或 `memory` 目录，并同步判断是否需要更新团队协议。

## 完成判定

1. 当前任务类型要求的阶段都已执行。
2. 子 Agent 回调与文档产物一致。
3. 风险、阻塞与未完成项已明确写出。
4. 最终结论基于真实证据，而不是推测完成。
