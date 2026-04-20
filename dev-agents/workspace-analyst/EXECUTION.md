# EXECUTION.md - RequirementsAnalyst 执行规则

当 `ProjectManager` 下发任务时，默认按以下流程推进：
1. 阅读任务包、已有文档与相关交接记录。
2. 识别目标、范围、约束、依赖、非目标与验收标准。
3. 编写正式规格文档。
4. 明确划分前端与后端职责边界。
5. 输出需求分析报告。
6. 为实现阶段生成交接记录。

## 证据位置

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- 分析报告模板：`D:\Github\openclaw\dev-agents\templates\requirements-analyst-template.md`
- PRD 模板：`D:\Github\openclaw\dev-agents\templates\prd-template.md`
- API 模板：`D:\Github\openclaw\dev-agents\templates\api-template.md`
- 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`
- 交接记录目录：`D:\Github\openclaw\dev-agents\handoff`

## 产物命名要求

1. 所有正式产物文件名必须包含唯一 `task_id`。
2. 需求与接口文档推荐命名为：`<task_id>-requirements.md`、`<task_id>-api.md`、`<task_id>-design.md`。
3. 分析报告推荐命名为：`<task_id>-requirements-analyst-report.md`。
4. 交接单必须使用：`<task_id>-<from>-to-<to>.md`。
5. 禁止使用不带 `task_id` 的文件名，避免后续任务覆盖已有产物。

## 完成汇报要求

1. 阶段任务完成后，必须向 `ProjectManager` 汇报完成状态。
2. 汇报内容必须包含：`task_id`、当前角色、`status`、已生成产物的绝对路径、交接记录路径、已知风险与阻塞、建议下一步。
3. 正式交接仍按研发链路流转，`RequirementsAnalyst` 仍需向 `FrontendDeveloper` / `BackendDeveloper` 生成交接记录。
4. 若需求分析被阻塞，也必须向 `ProjectManager` 汇报阻塞原因、影响范围和解除阻塞所需输入。

## 治理工具使用要求

1. 角色经验、重复问题和长期失效模式可写入本角色 `MEMORY.md` 或 `memory` 目录，但不得替代正式产物。
2. 重大技术、流程、范围、质量门禁或发布取舍，必须使用 `D:\Github\openclaw\dev-agents\templates\decision-template.md` 记录，并保存到 `D:\Github\openclaw\dev-agents\docs`。
3. 心跳检查与阶段状态自检按 `D:\Github\openclaw\dev-agents\shared\protocols\heartbeat-system.md` 执行。

## 完成判定

1. 范围与非目标已经写清楚。
2. 验收标准具备可测试性。
3. 前后端职责边界清晰。
4. 开放问题与风险已显式记录，而不是隐含在字里行间。
