# agent-template-map.md

本文件定义 `dev-agents` 中各角色使用的输入模板、输出模板与交接模板。

## 统一模板目录

1. 全部模板位于：`../templates/`
2. 任务下发模板：`../templates/task-dispatch-template.md`
3. 最终汇总模板：`../templates/final-report-template.md`
4. 交接模板：`../templates/handoff-template.md`

## 角色模板映射

### ProjectManager

1. 输入模板：
   `../templates/task-dispatch-template.md`
   `../templates/handoff-template.md`
   `../templates/prd-template.md`
   `../templates/api-template.md`
   `../templates/requirements-analyst-template.md`
   `../templates/frontend-developer-template.md`
   `../templates/backend-developer-template.md`
   `../templates/code-reviewer-template.md`
   `../templates/qa-engineer-template.md`
2. 输出模板：
   `../templates/final-report-template.md`

### RequirementsAnalyst

1. 输入模板：
   `../templates/task-dispatch-template.md`
   `../templates/handoff-template.md`
2. 输出模板：
   `../templates/prd-template.md`
   `../templates/api-template.md`
   `../templates/requirements-analyst-template.md`

### FrontendDeveloper

1. 输入模板：
   `../templates/prd-template.md`
   `../templates/api-template.md`
   `../templates/handoff-template.md`
2. 输出模板：
   `../templates/frontend-developer-template.md`

### BackendDeveloper

1. 输入模板：
   `../templates/prd-template.md`
   `../templates/api-template.md`
   `../templates/handoff-template.md`
2. 输出模板：
   `../templates/backend-developer-template.md`

### CodeReviewer

1. 输入模板：
   `../templates/prd-template.md`
   `../templates/api-template.md`
   `../templates/frontend-developer-template.md`
   `../templates/backend-developer-template.md`
   `../templates/handoff-template.md`
2. 输出模板：
   `../templates/code-reviewer-template.md`

### QAEngineer

1. 输入模板：
   `../templates/prd-template.md`
   `../templates/frontend-developer-template.md`
   `../templates/backend-developer-template.md`
   `../templates/code-reviewer-template.md`
   `../templates/handoff-template.md`
2. 输出模板：
   `../templates/qa-engineer-template.md`

## 推荐链路

1. `ProjectManager` 使用 `task-dispatch-template.md` 下发任务
2. `RequirementsAnalyst` 产出 `prd-template.md`、`api-template.md`、`requirements-analyst-template.md`
3. `FrontendDeveloper` / `BackendDeveloper` 分别产出各自开发报告
4. `CodeReviewer` 产出审查报告
5. `QAEngineer` 产出测试报告
6. `ProjectManager` 使用 `final-report-template.md` 汇总最终结果