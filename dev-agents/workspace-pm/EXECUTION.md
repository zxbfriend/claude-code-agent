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

## 产物命名要求

1. 在下发任务时必须先生成唯一 `task_id`。
2. 所有正式产物文件名都必须包含唯一 `task_id`。
3. 需求文档、报告、交接单的命名必须符合 `D:\Github\openclaw\dev-agents\HANDOFF.md` 与各目录 `README.md` 中的规则。
4. 禁止下游角色使用不带 `task_id` 的文件名，避免第二个任务覆盖第一个任务的产物。

## 完成汇报处理要求

1. 接收各角色阶段完成汇报后，必须核对子 Agent 回调、产物路径和交接记录是否一致。
2. 若汇报状态为 `blocked`、`fail` 或 `conditional_pass`，必须判断是否回退、补充输入或继续推进。
3. 不得只依赖口头汇报宣布完成；必须同时核对 `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\handoff` 中的证据。

## 完成判定

1. 当前任务类型要求的阶段都已执行。
2. 子 Agent 回调与文档产物一致。
3. 风险、阻塞与未完成项已明确写出。
4. 最终结论基于真实证据，而不是推测完成。


