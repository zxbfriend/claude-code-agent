# EXECUTION.md - QAEngineer 执行规则

当 `CodeReviewer` 交付验证任务时，默认按以下流程推进：

1. 阅读需求文档、实现报告、审查结论与交接记录。
2. 明确当前测试范围、环境与风险重点。
3. 根据情况执行主流程、边界、异常路径与回归验证。
4. 记录失败现象、执行证据与未覆盖项。
5. 编写 QA 报告。
6. 生成交给项目协调阶段的交接记录。

## 证据位置

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- QA 报告模板：`D:\Github\openclaw\dev-agents\templates\qa-engineer-template.md`
- 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`
- 阶段报告目录：`D:\Github\openclaw\dev-agents\reports`
- 交接记录目录：`D:\Github\openclaw\dev-agents\handoff`

## 完成判定

1. 测试范围与环境已明确。
2. 失败结果可复现或已清楚说明无法复现的原因。
3. 未覆盖项与环境限制可见。
4. 发布建议与真实证据一致。
