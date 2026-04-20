# D:\Github\openclaw\dev-agents\reports\README.md

本目录用于存放研发流程中的阶段输出报告实例，和根目录 `D:\Github\openclaw\dev-agents\HANDOFF.md`、`D:\Github\openclaw\dev-agents\handoff` 目录配套使用。

## 报告模板入口

1. `D:\Github\openclaw\dev-agents\templates\requirements-analyst-template.md`
2. `D:\Github\openclaw\dev-agents\templates\frontend-developer-template.md`
3. `D:\Github\openclaw\dev-agents\templates\backend-developer-template.md`
4. `D:\Github\openclaw\dev-agents\templates\code-reviewer-template.md`
5. `D:\Github\openclaw\dev-agents\templates\qa-engineer-template.md`
6. `D:\Github\openclaw\dev-agents\templates\final-report-template.md`

## 命名规则

为避免不同任务之间相互覆盖，所有报告文件名必须包含唯一 `task_id`。

推荐格式：

1. `T-YYYYMMDD-001-requirements-analyst-report.md`
2. `T-YYYYMMDD-001-frontend-developer-report.md`
3. `T-YYYYMMDD-001-backend-developer-report.md`
4. `T-YYYYMMDD-001-code-reviewer-report.md`
5. `T-YYYYMMDD-001-qa-engineer-report.md`
6. `T-YYYYMMDD-001-final-report.md`

补充要求：

1. 不允许使用 `frontend-report.md` 这类无任务标识名称。
2. 不允许不同任务复用同一报告文件名。
3. 同一任务的报告更新应覆盖同一任务文件，不应覆盖其他任务文件。
