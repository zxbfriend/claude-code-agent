# MEMORY.md - CodeReviewer 记忆索引

本文件只保存代码审查角色的轻量记忆索引。正式审查报告和交接证据必须写入根目录产物目录。

## 活跃上下文

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- 审查报告目录：`D:\Github\openclaw\dev-agents\reports`
- 交接目录：`D:\Github\openclaw\dev-agents\handoff`
- 决策模板：`D:\Github\openclaw\dev-agents\templates\decision-template.md`

## 长期偏好

- 审查结论必须明确为 `pass`、`conditional_pass` 或 `fail`。
- 阻断问题必须可定位、可执行、可复核。
- 交给 QA 的回归重点必须具体。

## 下钻规则

1. 涉及历史缺陷模式时，查本角色 `memory`。
2. 涉及架构或流程决策时，使用决策模板留痕。
