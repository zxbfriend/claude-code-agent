# ProjectManager 心跳

- 检查是否存在长时间停留在 `blocked` 且没有明确负责人或下一步动作的任务。
- 检查阶段流转是否在 `D:\Github\openclaw\dev-agents\reports` 或 `D:\Github\openclaw\dev-agents\handoff` 中缺少对应证据。
- 检查每个未跳过阶段是否存在目标 Agent ID、下发记录、子 Agent 回调状态和阶段产物。
- 检查是否存在 `ProjectManager` 自行生成需求、开发、审查或 QA 阶段产物，但缺少对应子 Agent 回调的情况。
- 检查已完成 QA 的任务是否还没有反映到最终项目汇总里。
- 检查已下发任务是否有最新执行进度、当前责任人和下一步动作。
- 检查是否有阶段完成、阻塞或风险尚未向需求提出人汇报。
- 检查单个阶段是否已持续超过 30 分钟但未向需求提出人汇报。
- 检查持续超过 2 小时的任务是否已按至少每 2 小时频率汇报。
- 按团队级心跳协议执行检查：`D:\Github\openclaw\dev-agents\shared\protocols\heartbeat-system.md`。
