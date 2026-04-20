# dev-agents - 软件开发多 Agent 协同配置

本目录包含一套面向 OpenClaw `Sub-Agents` 模式的软件研发多 Agent 协同规范，覆盖从需求到交付的完整链路。

## 定位说明

这套配置不是按渠道分流的 `Multi-Agent Routing`，而是按研发阶段协作的 `Sub-Agents` 编排方案。
系统约束如下：
1. 只有 `ProjectManager` 是外部用户入口 Agent
2. 其他 Agent 不直接绑定外部渠道，只能由 `ProjectManager` 通过 OpenClaw 子 Agent 机制调用
3. 正式研发链路以主 Agent 编排为准，`D:\Github\openclaw\dev-agents\handoff`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\docs` 用于留痕、审计和复盘
4. 角色记忆、心跳检查和决策记录是仓库治理补充，不替代正式研发链路

## 团队角色

| 角色中文名称 | 角色 ID | 配置目录 | Agent ID | 职责 |
|---|---|---|---|---|
| 项目经理 | ProjectManager | `workspace-pm` | `project_manager` | 接收用户请求、拆解需求、调度子 Agent、汇总最终结果 |
| 需求分析师 | RequirementsAnalyst | `workspace-analyst` | `requirements_analyst` | 需求分析、PRD 输出、验收标准定义 |
| 前端开发 | FrontendDeveloper | `workspace-frontend-dev` | `frontend_developer` | 前端代码实现、组件编写、界面开发 |
| 后端开发 | BackendDeveloper | `workspace-backend-dev` | `backend_developer` | 后端代码实现、API 设计、业务逻辑实现 |
| 代码审查员 | CodeReviewer | `workspace-reviewer` | `code_reviewer` | 代码质量审查、风险识别、问题分级 |
| 测试工程师 | QAEngineer | `workspace-qa` | `qa_engineer` | 测试设计、执行验证、缺陷反馈、发布建议 |
说明：本文档中的目录路径统一使用绝对路径；角色 ID 统一使用 PascalCase，Agent ID 统一使用 snake_case。

## 与文章示例的映射关系

OpenClaw 文章示例采用 5 角色链路：`Director -> Requirement Analyst -> Developer -> Code Reviewer -> Tester`。
本仓库在该思路上做了 6 角色扩展：
1. `ProjectManager` 对应 `Director`
2. `RequirementsAnalyst` 对应 `Requirement Analyst`
3. `FrontendDeveloper + BackendDeveloper` 是对单一 `Developer` 的拆分
4. `CodeReviewer` 对应 `Code Reviewer`
5. `QAEngineer` 对应 `Tester`
这种拆分更贴近真实软件研发协作，且保留了文章中的主流程编排思想。

## OpenClaw 运行模型

### 1. 外部入口

外部用户请求统一绑定到 `project_manager`。

### 2. 子 Agent 调度

`ProjectManager` 通过 OpenClaw `Sub-Agents` 能力派发任务。实现层面采用文章示例中的 `sessions_spawn` 思路：
1. 主 Agent 生成任务上下文
2. 主 Agent 调用目标子 Agent
3. 子 Agent 返回阶段结果
4. 主 Agent 决定是否进入下一阶段

### 3. 文档留痕

OpenClaw 原生回调负责“任务执行”，仓库文档负责“过程留痕”：
1. `D:\Github\openclaw\dev-agents\docs`：需求与设计文档
2. `D:\Github\openclaw\dev-agents\reports`：阶段性结果报告
3. `D:\Github\openclaw\dev-agents\handoff`：角色交接记录
因此，文档交接单是治理补充，不替代 OpenClaw 原生任务回传。

## 协作协议

1. 角色交接统一遵循 `D:\Github\openclaw\dev-agents\HANDOFF.md`
2. 交接记录统一写入 `D:\Github\openclaw\dev-agents\handoff`
3. 阶段报告统一写入 `D:\Github\openclaw\dev-agents\reports`
4. 需求与接口文档统一写入 `D:\Github\openclaw\dev-agents\docs`
5. 共享入口与模板映射统一放在 `D:\Github\openclaw\dev-agents\shared`
6. 各角色输入输出模板映射统一查看 `D:\Github\openclaw\dev-agents\shared\agent-template-map.md`
7. OpenClaw 配置与运行说明统一查看 `D:\Github\openclaw\dev-agents\docs`
8. 分层记忆和心跳检查协议统一查看 `D:\Github\openclaw\dev-agents\shared\protocols`
9. 重要决策统一使用 `D:\Github\openclaw\dev-agents\templates\decision-template.md`

## 治理扩展

1. 分层记忆系统：各角色使用本工作区 `MEMORY.md` 与 `memory` 目录保存长期经验，但正式证据仍以根目录 `docs`、`reports`、`handoff` 为准。
2. 心跳检查系统：各角色按 `D:\Github\openclaw\dev-agents\shared\protocols\heartbeat-system.md` 主动发现阻塞、证据缺失和阶段停滞。
3. 决策记录：架构、流程、范围、质量门禁或发布取舍使用 `D:\Github\openclaw\dev-agents\templates\decision-template.md` 留痕。

## 任务模板

```markdown
task_id: T-YYYYMMDD-001
goal:
- ...
inputs:
- ...
outputs:
- ...
acceptance_criteria:
- ...
handoff_to:
- ...
```

## 文件结构

```text
D:\Github\openclaw\dev-agents
├── D:\Github\openclaw\dev-agents\HANDOFF.md
├── D:\Github\openclaw\dev-agents\README.md
├── D:\Github\openclaw\dev-agents\docs
├── D:\Github\openclaw\dev-agents\reports
├── D:\Github\openclaw\dev-agents\handoff
├── D:\Github\openclaw\dev-agents\shared
├── D:\Github\openclaw\dev-agents\templates
├── D:\Github\openclaw\dev-agents\workspace-pm
├── D:\Github\openclaw\dev-agents\workspace-analyst
├── D:\Github\openclaw\dev-agents\workspace-frontend-dev
├── D:\Github\openclaw\dev-agents\workspace-backend-dev
├── D:\Github\openclaw\dev-agents\workspace-reviewer
└── D:\Github\openclaw\dev-agents\workspace-qa
```

## 运行相关文档

1. `D:\Github\openclaw\dev-agents\docs\openclaw-config-example.md`：OpenClaw 主配置示例
2. `D:\Github\openclaw\dev-agents\docs\openclaw-binding-example.md`：入口绑定示例
3. `D:\Github\openclaw\dev-agents\docs\openclaw-runtime-layout.md`：运行目录说明
4. `D:\Github\openclaw\dev-agents\docs\openclaw-architecture-mapping.md`：角色架构映射说明

## 使用说明

1. 外部用户向 `ProjectManager` 提出软件需求
2. `ProjectManager` 生成 `task_id`，并通过 Sub-Agents 调用 `RequirementsAnalyst`
3. `RequirementsAnalyst` 完成规格后，`ProjectManager` 并行调用 `FrontendDeveloper` 与 `BackendDeveloper`
4. 开发完成后，`ProjectManager` 调用 `CodeReviewer`
5. 审查通过后，`ProjectManager` 调用 `QAEngineer`
6. 最终由 `ProjectManager` 汇总 `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\handoff` 与子 Agent 回调结果，对外输出结论
