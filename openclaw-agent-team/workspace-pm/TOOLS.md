# 工具使用说明（PM Agent）

## 文件操作

- 工作目录：`~/.openclaw/workspace-pm/`
- 项目文件根目录：`~/.openclaw/workspace-pm/projects/`
- 记忆文件目录：`~/.openclaw/workspace-pm/memory/`

### 创建项目目录结构

```bash
PROJECT=your-project-name
mkdir -p ~/.openclaw/workspace-pm/projects/$PROJECT/{requirements,architecture,tasks,output,qa,review}
```

## Sub-agent 工具

### sessions_spawn 参数说明

```
task            — 任务描述（必填，越详细越好）
agentId         — 目标 agent ID（pm/architect/backend/frontend/mobile/qa/reviewer/dba/devops/doc）
runTimeoutSeconds — 超时时间（建议 600，复杂任务可设 900）
```

### 常用调试命令

```
/subagents list              — 查看当前所有 sub-agent 运行状态
/subagents log <id>          — 查看某个 sub-agent 的详细日志
/subagents info <id>         — 查看 sub-agent 元数据
/subagents kill <id>         — 终止某个 sub-agent
/subagents steer <id> <msg>  — 向运行中的 sub-agent 发送指令
```

## 文件读写约定

| 文件 | 谁写 | 谁读 |
|------|------|------|
| requirements/PRD.md | PM | 所有 Agent |
| architecture/DESIGN.md | Architect | Backend / Frontend / Mobile / QA / Reviewer |
| tasks/TASKS.md | PM | Backend / Frontend / Mobile |
| output/backend.md | Backend | QA / Reviewer / PM |
| output/frontend.md | Frontend | QA / Reviewer / PM |
| output/mobile.md | Mobile | QA / Reviewer / PM |
| qa/TEST_REPORT.md | QA | Reviewer / PM |
| review/REVIEW_REPORT.md | Reviewer | PM |

## 注意事项

- spawn sub-agent 是非阻塞的，立即返回 run id，等待 announce 回调
- 不要用循环轮询 `/subagents list` 等待结果，等 announce 即可
- 超时时间根据任务复杂度设置，简单任务 300s，复杂任务 600-900s
