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

## 完成判定

1. 范围与非目标已经写清楚。
2. 验收标准具备可测试性。
3. 前后端职责边界清晰。
4. 开放问题与风险已显式记录，而不是隐含在字里行间。
