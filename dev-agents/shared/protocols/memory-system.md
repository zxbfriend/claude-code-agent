# memory-system.md - 分层记忆系统

本文件定义 `dev-agents` 研发团队模板的统一记忆规则。

## 1. 目标

1. 保留各角色长期经验，避免每次会话从零开始。
2. 区分正式交付证据与角色工作记忆。
3. 降低上下文加载成本，避免把所有历史内容一次性读入。

## 2. 权威边界

1. 正式交付证据以 `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\handoff` 为准。
2. 角色记忆只用于提升连续性，不得替代正式产物、交接记录或测试证据。
3. 记忆中不得保存密钥、令牌、密码、个人隐私或未经授权的生产数据。

## 3. 目录结构

每个角色工作区都可以使用以下结构：

```text
workspace-<role>\
├── MEMORY.md
└── memory\
    ├── YYYY-MM-DD.md
    ├── decisions\
    ├── context\
    ├── lessons\
    └── projects\
```

## 4. 文件职责

1. `MEMORY.md`：轻量索引，只记录当前活跃任务、重要偏好、常用路径和需要下钻的记忆文件。
2. `memory\YYYY-MM-DD.md`：当天原始工作日志，记录重要操作、阻塞、决策和教训。
3. `memory\decisions`：角色相关决策记录，正式决策仍应同步到 `D:\Github\openclaw\dev-agents\docs` 或 `D:\Github\openclaw\dev-agents\reports`。
4. `memory\context`：临时上下文，只保留当前任务需要的背景。
5. `memory\lessons`：可复用经验、常见错误和下次应避免的问题。
6. `memory\projects`：长期项目背景，但不得替代根目录正式产物。

## 5. 会话加载规则

1. 每次会话优先读取运行时提供的上下文。
2. 如果需要补充角色连续性，读取本角色 `MEMORY.md`。
3. 只有当当前任务命中特定项目、决策或问题时，才读取对应下钻文件。
4. 会话启动时最多读取 5 个下钻记忆文件。
5. 不得因为记忆中写过某结论，就跳过当前任务的证据核查。

## 6. 写入规则

以下情况必须写入角色记忆：

1. 发现可复用的工作经验或失效模式。
2. 出现重复阻塞、调度失败或交接缺口。
3. 做出会影响后续任务的流程、架构或质量判断。
4. 发现某个角色长期需要补充的检查项。

写入后必须保证：

1. 如果更新了下钻文件，同步更新 `MEMORY.md` 索引。
2. 如果内容影响正式流程，同步更新 `D:\Github\openclaw\dev-agents\HANDOFF.md` 或相关模板。
3. 如果内容属于某个 `task_id` 的正式证据，必须写入根目录 `docs`、`reports` 或 `handoff`，不能只写入记忆。

## 7. 读取方式

本模板不配置本地记忆检索工具。角色记忆通过 `MEMORY.md` 索引和人工下钻方式读取。

推荐流程：

1. 先读取当前角色的 `MEMORY.md`。
2. 根据 `MEMORY.md` 中的活跃上下文、长期偏好和下钻规则，定位需要读取的 `memory` 子目录文件。
3. 只读取当前任务需要的记忆文件，避免一次性加载全部历史。
4. 记忆只作为连续性辅助，正式结论仍必须回到 `docs`、`reports`、`handoff` 中核对证据。
