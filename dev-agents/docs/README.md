# docs/README.md

本目录用于存放研发流程中的正式需求、设计、接口与架构文档。

根目录绝对路径：

`D:\Github\openclaw\dev-agents\docs`

## 命名规则

为避免不同任务之间相互覆盖，`docs` 目录中的正式文档文件名必须包含唯一 `task_id`。

推荐格式：

1. `T-YYYYMMDD-001-requirements.md`
2. `T-YYYYMMDD-001-api.md`
3. `T-YYYYMMDD-001-design.md`
4. `T-YYYYMMDD-001-architecture.md`

补充要求：

1. 不允许只用业务名命名，例如 `requirements-login.md`。
2. 不允许省略 `task_id`。
3. 同一任务的不同文档，通过后缀区分类型，不通过覆盖旧文件更新阶段。

示例：

1. `D:\Github\openclaw\dev-agents\docs\T-20260419-001-requirements.md`
2. `D:\Github\openclaw\dev-agents\docs\T-20260419-001-api.md`

约定：

1. 正式产物统一写入本目录，不写入各工作区子目录。
2. 所有模板、交接单、报告中的文档引用统一使用绝对路径。
