# handoff/README.md

本目录用于存放跨角色任务交接记录实例，配合根目录 `D:\Github\openclaw\dev-agents\HANDOFF.md` 使用。

## 模板入口

1. `D:\Github\openclaw\dev-agents\templates\handoff-template.md`

## 命名规则

为避免不同任务之间相互覆盖，所有交接单文件名必须包含唯一 `task_id`，并保留交出方与接收方角色。

文件名格式：

`<task_id>-<from>-to-<to>.md`

示例：

1. `T-20260418-001-FrontendDeveloper-to-CodeReviewer.md`
2. `T-20260418-001-CodeReviewer-to-QAEngineer.md`

补充要求：

1. 不允许省略 `task_id`。
2. 不允许只用 `handoff-analyst.md` 这类无法区分任务的名称。
3. 不同任务必须使用不同的交接单文件名。

## 推荐交接顺序

1. `ProjectManager`
2. `RequirementsAnalyst`
3. `FrontendDeveloper`
4. `BackendDeveloper`
5. `CodeReviewer`
6. `QAEngineer`
7. `ProjectManager`

## Status 使用建议

主流程：`todo -> in_progress -> in_review -> in_test -> done`

常见回退：

1. `in_review -> in_progress`
2. `in_test -> in_progress`
3. `* -> blocked`
