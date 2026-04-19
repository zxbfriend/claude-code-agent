# handoff/README.md

本目录用于存放跨角色任务交接记录实例，配合根目录 `HANDOFF.md` 使用。

## 模板入口

1. `../templates/handoff-template.md`

## 1. 命名规则

1. 文件名格式：`<task_id>-<from>-to-<to>.md`
2. 示例：`T-20260418-001-FrontendDeveloper-to-CodeReviewer.md`

## 2. 推荐交接顺序

1. `ProjectManager`
2. `RequirementsAnalyst`
3. `FrontendDeveloper`
4. `BackendDeveloper`
5. `CodeReviewer`
6. `QAEngineer`
7. `ProjectManager`

## 3. Status 使用建议

主流程：`todo -> in_progress -> in_review -> in_test -> done`

常见回退：

1. `in_review -> in_progress`
2. `in_test -> in_progress`
3. `* -> blocked`
