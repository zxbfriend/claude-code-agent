# task-dispatch-template.md

本模板用于 `ProjectManager` 向子 Agent 下发任务。

## 通用下发模板

```markdown
task_id: T-YYYYMMDD-001
target_role: RequirementsAnalyst / FrontendDeveloper / BackendDeveloper / CodeReviewer / QAEngineer
target_agent_id: requirements_analyst / frontend_developer / backend_developer / code_reviewer / qa_engineer
stage: analysis / frontend_dev / backend_dev / review / test
must_spawn_subagent: true
goal:
- ...

inputs:
- docs: ...
- code: ...
- handoff: ...
- reports: ...

outputs:
- D:\Github\openclaw\dev-agents\docs\<task_id>-requirements.md
- D:\Github\openclaw\dev-agents\reports\<task_id>-frontend-developer-report.md
- D:\Github\openclaw\dev-agents\handoff\<task_id>-<from>-to-<to>.md

acceptance_criteria:
- ...
- ...

timeout_seconds: 600
handoff_to: ...
return_to: ProjectManager
notes: ...
```

## 强制调度要求

1. `ProjectManager` 必须通过 OpenClaw `Sub-Agents` 机制调用 `target_agent_id` 对应的子 Agent。
2. `ProjectManager` 不得自行完成 `target_role` 的阶段工作，不得自行生成需求、开发、审查或 QA 阶段报告来代替子 Agent 产物。
3. 子 Agent 调用失败、超时或不可用时，当前阶段必须标记为 `blocked`，并记录失败原因、影响范围和下一步处理建议。
4. 阶段完成必须同时具备子 Agent 调度记录、子 Agent 回调结果、阶段产物绝对路径和交接记录绝对路径。
5. 缺少对应子 Agent 回调时，`ProjectManager` 不得把该阶段判定为 `done`。

## 输出文件命名要求

1. 所有正式产物文件名必须包含当前任务的唯一 `task_id`。
2. 所有正式产物必须写入仓库根目录下的 `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\handoff`。
3. 禁止使用不带 `task_id` 的文件名，例如 `requirements-login.md`、`frontend-report.md`、`handoff-analyst.md`。
4. 若任务拆分为多个阶段文件，也必须保持同一个 `task_id` 前缀，并通过后缀区分类型。

## 下发给 RequirementsAnalyst

重点要求：

1. 输出需求文档
2. 输出接口设计（如需要）
3. 输出验收标准
4. 标注风险与待确认项

## 下发给 FrontendDeveloper

重点要求：

1. 严格按规格实现前端
2. 输出前端开发报告
3. 完成最小自测
4. 记录已知问题与风险

## 下发给 BackendDeveloper

重点要求：

1. 严格按规格实现后端
2. 输出后端开发报告
3. 完成最小自测
4. 记录已知问题与风险

## 下发给 CodeReviewer

重点要求：

1. 输出明确结论
2. 标注问题优先级
3. 给出修复建议
4. 给 QAEngineer 标出重点回归路径

## 下发给 QAEngineer

重点要求：

1. 明确测试范围
2. 输出用例统计
3. 记录失败详情与证据
4. 给出发布建议

## ProjectManager 下发前检查

1. 是否生成 `task_id`
2. 是否明确目标角色
3. 是否明确目标 Agent ID
4. 是否标记 `must_spawn_subagent: true`
5. 是否提供足够输入材料
6. 是否写清输出要求
7. 是否写清验收标准
8. 是否说明完成后交接对象和回传给 `ProjectManager`
9. 是否要求所有正式产物文件名包含 `task_id`
