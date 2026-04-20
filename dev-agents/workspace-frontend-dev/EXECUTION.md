# EXECUTION.md - FrontendDeveloper 执行规则

当 `RequirementsAnalyst` 或 `ProjectManager` 下发前端任务时，默认按以下流程推进：
1. 阅读任务包、需求文档与已有交接记录。
2. 明确前端范围、依赖关系与验收标准。
3. 完成已批准的前端实现。
4. 执行并记录最小自测。
5. 输出前端实现报告。
6. 生成交给审查阶段的交接记录。

## 证据位置

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- 前端报告模板：`D:\Github\openclaw\dev-agents\templates\frontend-developer-template.md`
- 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`
- 阶段报告目录：`D:\Github\openclaw\dev-agents\reports`
- 交接记录目录：`D:\Github\openclaw\dev-agents\handoff`

## 产物命名要求

1. 所有正式产物文件名必须包含唯一 `task_id`。
2. 前端实现报告推荐命名为：`<task_id>-frontend-developer-report.md`。
3. 若补充前端设计说明，应使用：`<task_id>-design.md` 等格式。
4. 交接单必须使用：`<task_id>-<from>-to-<to>.md`。
5. 禁止使用不带 `task_id` 的文件名，避免后续任务覆盖已有产物。

## 完成汇报要求

1. 阶段任务完成后，必须向 `ProjectManager` 汇报完成状态。
2. 汇报内容必须包含：`task_id`、当前角色、`status`、已生成产物的绝对路径、交接记录路径、已知风险与阻塞、建议下一步。
3. 正式交接仍按研发链路流转，`FrontendDeveloper` 仍需向 `CodeReviewer` 生成交接记录。
4. 若前端开发被阻塞，也必须向 `ProjectManager` 汇报阻塞原因、影响范围和解除阻塞所需输入。

## 治理工具使用要求

1. 角色经验、重复问题和长期失效模式可写入本角色 `MEMORY.md` 或 `memory` 目录，但不得替代正式产物。
2. 重大技术、流程、范围、质量门禁或发布取舍，必须使用 `D:\Github\openclaw\dev-agents\templates\decision-template.md` 记录，并保存到 `D:\Github\openclaw\dev-agents\docs`。
3. 心跳检查与阶段状态自检按 `D:\Github\openclaw\dev-agents\shared\protocols\heartbeat-system.md` 执行。

## 完成判定

1. 前端实现与已批准范围一致。
2. 已留下最小自测证据。
3. 已知风险与缺口已明确写出。
4. 审查阶段无需靠猜测理解改动内容。
