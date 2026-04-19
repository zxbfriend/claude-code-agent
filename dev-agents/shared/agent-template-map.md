# agent-template-map.md

本文件定义 `dev-agents` 中各角色使用的输入模板、输出模板与交接模板。

## 统一模板目录

1. 全部模板位于：`D:\Github\openclaw\dev-agents\templates`
2. 任务下发模板：`D:\Github\openclaw\dev-agents\templates\task-dispatch-template.md`
3. 最终汇总模板：`D:\Github\openclaw\dev-agents\templates\final-report-template.md`
4. 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`

## 角色模板映射

### ProjectManager

1. 输入模板：
   `D:\Github\openclaw\dev-agents\templates\task-dispatch-template.md`
   `D:\Github\openclaw\dev-agents\templates\handoff-template.md`
   `D:\Github\openclaw\dev-agents\templates\prd-template.md`
   `D:\Github\openclaw\dev-agents\templates\api-template.md`
   `D:\Github\openclaw\dev-agents\templates\requirements-analyst-template.md`
   `D:\Github\openclaw\dev-agents\templates\frontend-developer-template.md`
   `D:\Github\openclaw\dev-agents\templates\backend-developer-template.md`
   `D:\Github\openclaw\dev-agents\templates\code-reviewer-template.md`
   `D:\Github\openclaw\dev-agents\templates\qa-engineer-template.md`
2. 输出模板：
   `D:\Github\openclaw\dev-agents\templates\final-report-template.md`

### RequirementsAnalyst

1. 输入模板：
   `D:\Github\openclaw\dev-agents\templates\task-dispatch-template.md`
   `D:\Github\openclaw\dev-agents\templates\handoff-template.md`
2. 输出模板：
   `D:\Github\openclaw\dev-agents\templates\prd-template.md`
   `D:\Github\openclaw\dev-agents\templates\api-template.md`
   `D:\Github\openclaw\dev-agents\templates\requirements-analyst-template.md`

### FrontendDeveloper

1. 输入模板：
   `D:\Github\openclaw\dev-agents\templates\prd-template.md`
   `D:\Github\openclaw\dev-agents\templates\api-template.md`
   `D:\Github\openclaw\dev-agents\templates\handoff-template.md`
2. 输出模板：
   `D:\Github\openclaw\dev-agents\templates\frontend-developer-template.md`

### BackendDeveloper

1. 输入模板：
   `D:\Github\openclaw\dev-agents\templates\prd-template.md`
   `D:\Github\openclaw\dev-agents\templates\api-template.md`
   `D:\Github\openclaw\dev-agents\templates\handoff-template.md`
2. 输出模板：
   `D:\Github\openclaw\dev-agents\templates\backend-developer-template.md`

### CodeReviewer

1. 输入模板：
   `D:\Github\openclaw\dev-agents\templates\prd-template.md`
   `D:\Github\openclaw\dev-agents\templates\api-template.md`
   `D:\Github\openclaw\dev-agents\templates\frontend-developer-template.md`
   `D:\Github\openclaw\dev-agents\templates\backend-developer-template.md`
   `D:\Github\openclaw\dev-agents\templates\handoff-template.md`
2. 输出模板：
   `D:\Github\openclaw\dev-agents\templates\code-reviewer-template.md`

### QAEngineer

1. 输入模板：
   `D:\Github\openclaw\dev-agents\templates\prd-template.md`
   `D:\Github\openclaw\dev-agents\templates\frontend-developer-template.md`
   `D:\Github\openclaw\dev-agents\templates\backend-developer-template.md`
   `D:\Github\openclaw\dev-agents\templates\code-reviewer-template.md`
   `D:\Github\openclaw\dev-agents\templates\handoff-template.md`
2. 输出模板：
   `D:\Github\openclaw\dev-agents\templates\qa-engineer-template.md`

## 推荐链路

1. `ProjectManager` 使用 `task-dispatch-template.md` 下发任务
2. `RequirementsAnalyst` 产出 `prd-template.md`、`api-template.md`、`requirements-analyst-template.md`
3. `FrontendDeveloper` / `BackendDeveloper` 分别产出各自开发报告
4. `CodeReviewer` 产出审查报告
5. `QAEngineer` 产出测试报告
6. `ProjectManager` 使用 `final-report-template.md` 汇总最终结果
