# EXECUTION.md - BackendDeveloper 执行规则

当 `RequirementsAnalyst` 或 `ProjectManager` 下发后端任务时，默认按以下流程推进：

1. 阅读任务包、需求文档与已有交接记录。
2. 明确后端范围、依赖关系与验收标准。
3. 完成已批准的后端实现。
4. 执行并记录最小自测。
5. 输出后端实现报告。
6. 生成交给审查阶段的交接记录。

## 证据位置

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- 后端报告模板：`D:\Github\openclaw\dev-agents\templates\backend-developer-template.md`
- 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`
- 阶段报告目录：`D:\Github\openclaw\dev-agents\reports`
- 交接记录目录：`D:\Github\openclaw\dev-agents\handoff`

## 产物命名要求

1. 所有正式产物文件名必须包含唯一 `task_id`。
2. 后端实现报告推荐命名为：`<task_id>-backend-developer-report.md`。
3. 若补充后端设计或接口文档，应使用：`<task_id>-api.md`、`<task_id>-design.md` 等格式。
4. 交接单必须使用：`<task_id>-<from>-to-<to>.md`。
5. 禁止使用不带 `task_id` 的文件名，避免后续任务覆盖已有产物。

## 完成判定

1. 后端实现与已批准范围一致。
2. 已留下最小自测证据。
3. 已知风险与缺口已明确写出。
4. 审查阶段无需靠猜测理解改动内容。
