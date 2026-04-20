# MEMORY.md - QAEngineer 记忆索引

本文件只保存测试角色的轻量记忆索引。正式测试报告和交接证据必须写入根目录产物目录。

## 活跃上下文

- 需求文档目录：`D:\Github\openclaw\dev-agents\docs`
- 测试报告目录：`D:\Github\openclaw\dev-agents\reports`
- 交接目录：`D:\Github\openclaw\dev-agents\handoff`
- 心跳协议：`D:\Github\openclaw\dev-agents\shared\protocols\heartbeat-system.md`

## 长期偏好

- 未实际执行的测试不得写成通过。
- 失败必须尽量提供复现路径和证据。
- 无法执行测试时必须标记 `blocked` 并说明缺少的条件。

## 下钻规则

1. 涉及测试范围时，先读需求、实现报告和审查报告。
2. 涉及历史逃逸缺陷或环境限制时，查本角色 `memory`。
3. 涉及发布建议时，必须引用正式 QA 报告和证据。
