# EXECUTION.md - CodeReviewer 执行规则

当 `FrontendDeveloper` 或 `BackendDeveloper` 交付审查任务时，默认按以下流程推进：

1. 阅读需求文档、实现报告与交接记录。
2. 从正确性、边界、安全、回归风险与可维护性维度进行审查。
3. 输出明确结论，例如 `pass`、`conditional_pass` 或 `fail`。
4. 编写正式审查报告。
5. 生成交给 QA 的交接记录，并明确重点回归区域。

## 证据位置

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- 审查报告模板：`D:\Github\openclaw\dev-agents\templates\code-reviewer-template.md`
- 交接模板：`D:\Github\openclaw\dev-agents\templates\handoff-template.md`
- 阶段报告目录：`D:\Github\openclaw\dev-agents\reports`
- 交接记录目录：`D:\Github\openclaw\dev-agents\handoff`

## 完成判定

1. 审查结论明确。
2. 阻断问题具备可执行性与可定位性。
3. QA 能直接据此确定重点回归范围。
4. 报告基于真实改动与证据，而不是想象中的实现。
