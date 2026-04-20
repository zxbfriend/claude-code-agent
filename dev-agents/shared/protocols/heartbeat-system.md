# heartbeat-system.md - 心跳检查系统

本文件定义 `dev-agents` 研发团队模板的统一心跳规则。

## 1. 目标

1. 主动发现长期阻塞、证据缺失、阶段停滞和风险遗漏。
2. 降低无意义打扰，只在有行动价值时汇报。
3. 让 `ProjectManager` 能持续掌握任务状态。

## 2. 通用原则

1. 心跳检查不得替代正式阶段执行。
2. 心跳结果不得直接写成任务完成结论。
3. 无异常时保持安静；需要机器可读返回时使用 `HEARTBEAT_OK`。
4. 不得因为心跳发现缺口就跳过角色链路；应回到对应角色或标记阻塞。

## 3. ProjectManager 心跳重点

`ProjectManager` 必须检查：

1. 已下发任务是否有子 Agent 回调。
2. 当前阶段是否超过 30 分钟未向需求提出人汇报。
3. 持续超过 2 小时的任务是否已按至少每 2 小时汇报。
4. `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\handoff` 是否存在预期产物。
5. 是否存在 `blocked`、`fail`、`conditional_pass`、证据缺失或角色职责被用户替代的情况。

## 4. 子角色心跳重点

除 `ProjectManager` 外，各角色必须检查：

1. 当前是否有已接收但未完成的任务。
2. 是否缺少输入文档、验收标准、环境、权限或测试数据。
3. 是否已生成阶段报告和交接记录。
4. 是否已向 `ProjectManager` 汇报完成、阻塞或失败状态。
5. 是否有经验或失效模式需要写入本角色记忆。

## 5. 汇报规则

必须主动汇报：

1. 阶段完成。
2. 阶段阻塞。
3. 缺少证据。
4. 子 Agent 超时或调度失败。
5. 发现流程风险、证据风险或外发动作风险。
6. 发现流程被跳过、角色职责混淆或用户被要求接替子 Agent。

不应汇报：

1. 没有新信息。
2. 刚检查过且状态未变化。
3. 只属于角色内部整理、且不影响任务推进的记忆更新。

## 6. 输出格式

有问题时输出：

```markdown
heartbeat_status: attention_required
task_id:
role:
issue:
evidence:
impact:
next_action:
needs_user_input:
```

无问题时输出：

```text
HEARTBEAT_OK
```
