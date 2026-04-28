# 任务单模板（Task List）

> 由 pm-agent 在接收任务后生成，是 Agent 间协作的基础文档。

---

## 任务单

**任务ID**：TASK-{YYYYMMDD}-{序号，如001}
**任务类型**：新功能开发 / Bug修复 / 技术重构 / 需求变更 / 性能优化 / 安全加固 / 依赖升级 / 文档补全
**优先级**：P0（紧急）/ P1（正常）/ P2（低优）
**创建时间**：{YYYY-MM-DD HH:mm}
**参考流程**：`.claude/workflows/{流程文件名}.md`

---

## 需求描述

{用 pm-agent 自己的话重述需求，确认理解正确。  
如有模糊之处，在这里列出并标注"待澄清"。}

---

## 影响范围分析

| 层面 | 是否受影响 | 说明 |
|------|-----------|------|
| 前端 | 是 / 否 | {说明，如无则写"无变动"} |
| 后端 | 是 / 否 | {说明} |
| 数据库 | 是 / 否 | {说明，如有变动列出表名} |
| 接口定义 | 是 / 否 | {说明，如有变动列出接口路径} |
| 第三方依赖 | 是 / 否 | {说明} |

---

## Agent 调用计划

| 步骤 | Agent | 任务说明 | 依赖步骤 | 状态 |
|------|-------|---------|---------|------|
| 1 | architect-agent | 技术方案设计 | 无 | ⏳ 待开始 |
| 2-A | dba-agent | 数据库变更脚本 | Step 1 | ⏳ 待开始 |
| 2-B | backend-agent | 后端实现 | Step 1 | ⏳ 待开始 |
| 2-C | frontend-agent | 前端实现 | Step 1 | ⏳ 待开始 |
| 3 | qa-agent | 功能测试 | Step 2 全部完成 | ⏳ 待开始 |
| 4 | reviewer-agent | 代码审查 | Step 3 通过 | ⏳ 待开始 |

> 状态枚举：⏳ 待开始 / 🔄 进行中 / ✅ 完成 / ❌ 需修改 / ⏭ 跳过（不适用）

---

## 预期交付物

| 交付物 | 产出 Agent | 完成状态 |
|--------|-----------|---------|
| 技术规格文档（tech-spec.md）| architect-agent | ⏳ |
| 数据库变更脚本 | dba-agent | ⏳ |
| 后端实现代码 + 单元测试 | backend-agent | ⏳ |
| 前端实现代码 | frontend-agent | ⏳ |
| 测试报告（test-report.md）| qa-agent | ⏳ |
| Code Review 报告（review-report.md）| reviewer-agent | ⏳ |

---

## Agent 间传递格式（JSON）

```json
{
  "task_id": "TASK-20240101-001",
  "task_type": "new_feature",
  "from_agent": "pm-agent",
  "to_agent": "architect-agent",
  "priority": "P1",
  "context": {
    "requirement": "需求描述",
    "constraints": ["Java 17", "Spring Boot 4.0.5", "MyBatis", "Vue 3"],
    "dependencies": []
  },
  "expected_output": "接口规格文档 + 数据模型设计",
  "deadline": "{YYYY-MM-DDTHH:mm:ssZ}"
}
```

---

## 进度记录

| 时间 | 事件 | 操作 Agent |
|------|------|-----------|
| {HH:mm} | 任务创建 | pm-agent |
| {HH:mm} | architect-agent 开始工作 | pm-agent |
| {HH:mm} | 技术规格文档输出完成 | architect-agent |
| {HH:mm} | ... | ... |

---

## 汇总报告（任务完成后填写）

**完成时间**：{YYYY-MM-DD HH:mm}
**总耗时**：{X 分钟}

### 交付物汇总
- [x] 技术规格文档
- [x] 数据库迁移脚本：`V{版本}__xxx.sql`
- [x] 后端代码：{文件列表}
- [x] 测试报告：{测试结论}
- [x] Review 报告：✅ 通过

### 待跟进事项
{如有下一步需要跟进的内容}
