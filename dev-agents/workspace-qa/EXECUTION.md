# EXECUTION.md - QAEngineer 执行规则

当 `CodeReviewer` 交付验证任务时，默认按以下流程推进：

1. 阅读需求文档、实现报告、审查结论与交接记录。
2. 明确当前测试范围、环境与风险重点。
3. 根据情况执行主流程、边界、异常路径与回归验证。
4. 记录失败现象、执行证据与未覆盖项。
5. 编写 QA 报告。
6. 生成交给项目协调阶段的交接记录。

## 证据位置

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- QA 报告模板：`D:\Github\openclaw\dev-agents\templates\qa-engineer-template.md`
- 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`
- 阶段报告目录：`D:\Github\openclaw\dev-agents\reports`
- 交接记录目录：`D:\Github\openclaw\dev-agents\handoff`

## 产物命名要求

1. 所有正式产物文件名必须包含唯一 `task_id`。
2. QA 报告推荐命名为：`<task_id>-qa-engineer-report.md`。
3. 交接单必须使用：`<task_id>-<from>-to-<to>.md`。
4. 禁止使用不带 `task_id` 的文件名，避免后续任务覆盖已有产物。

## 完成汇报要求

1. 阶段任务完成后，必须向 `ProjectManager` 汇报完成状态。
2. 汇报内容必须包含：`task_id`、当前角色、`status`、已生成产物的绝对路径、交接记录路径、已知风险与阻塞、发布建议与建议下一步。
3. 正式交接仍按研发链路流转，`QAEngineer` 需向 `ProjectManager` 生成最终阶段交接记录。
4. 若测试被阻塞或不通过，也必须向 `ProjectManager` 汇报阻塞原因、影响范围、失败证据和建议回退对象。

## 完成判定

1. 测试范围与环境已明确。
2. 失败结果可复现或已清楚说明无法复现的原因。
3. 未覆盖项与环境限制可见。
4. 发布建议与真实证据一致。

