# EXECUTION.md - CodeReviewer 执行规则

当 `FrontendDeveloper` 或 `BackendDeveloper` 交付审查任务时，默认按以下流程推进：
1. 阅读需求文档、实现报告与交接记录。
2. 从正确性、边界、回归风险与可维护性维度进行审查。
3. 输出明确结论，例如 `pass`、`conditional_pass` 或 `fail`。
4. 编写正式审查报告。
5. 生成交给 QA 的交接记录，并明确重点回归区域。

## 证据位置

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- 审查报告模板：`D:\Github\openclaw\dev-agents\templates\code-reviewer-template.md`
- 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`
- 阶段报告目录：`D:\Github\openclaw\dev-agents\reports`
- 交接记录目录：`D:\Github\openclaw\dev-agents\handoff`

## 产物命名要求

1. 所有正式产物文件名必须包含唯一 `task_id`。
2. 审查报告推荐命名为：`<task_id>-code-reviewer-report.md`。
3. 交接单必须使用：`<task_id>-<from>-to-<to>.md`。
4. 禁止使用不带 `task_id` 的文件名，避免后续任务覆盖已有产物。

## 完成汇报要求

1. 阶段任务完成后，必须向 `ProjectManager` 汇报完成状态。
2. 汇报内容必须包含：`task_id`、当前角色、`status`、已生成产物的绝对路径、交接记录路径、已知风险与阻塞、建议下一步。
3. 正式交接仍按研发链路流转，`CodeReviewer` 仍需向 `QAEngineer` 生成交接记录。
4. 若代码审查被阻塞或审查不通过，也必须向 `ProjectManager` 汇报阻塞原因、影响范围和建议回退对象。

## 治理工具使用要求

1. 角色经验、重复问题和长期失效模式可写入本角色 `MEMORY.md` 或 `memory` 目录，但不得替代正式产物。
2. 重大技术、流程、范围、质量门禁或发布取舍，必须使用 `D:\Github\openclaw\dev-agents\templates\decision-template.md` 记录，并保存到 `D:\Github\openclaw\dev-agents\docs`。
3. 心跳检查与阶段状态自检按 `D:\Github\openclaw\dev-agents\shared\protocols\heartbeat-system.md` 执行。

## 完成判定

1. 审查结论明确。
2. 阻断问题具备可执行性与可定位性。
3. QA 能直接据此确定重点回归范围。
4. 报告基于真实改动与证据，而不是想象中的实现。
