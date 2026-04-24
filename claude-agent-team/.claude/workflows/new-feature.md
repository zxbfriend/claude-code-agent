# 工作流：新功能开发（New Feature）

> 链路最长，几乎所有 Agent 都会参与。

---

## 触发条件

用户输入包含：新增、开发、实现、新功能、增加功能 等关键词，  
且需要新增接口或数据库表时，走本流程。

---

## 完整流程

```
用户需求
   │
   ▼
Step 1: pm-agent
   ├── 理解并重述需求（向用户确认）
   ├── 判断任务类型 → 新功能开发 ✅
   ├── 影响范围分析（前端/后端/数据库）
   ├── 生成任务单（task-list.md 模板）
   └── → 调用 architect-agent

Step 2: architect-agent
   ├── 接口规格设计（路径/入参/出参/错误码）
   ├── 数据模型设计（表结构/索引策略）
   ├── 技术方案说明（中间件/缓存/关键逻辑）
   ├── 输出：tech-spec.md（技术规格文档）
   └── → 并行通知 backend-agent + dba-agent（+ frontend-agent，如有前端）

Step 3（并行）:
   ├── Step 3-A: dba-agent
   │     ├── 根据 architect-agent 的数据模型，编写 Flyway 迁移脚本
   │     ├── 确认索引设计
   │     └── 输出：V{版本}__xxx.sql
   │
   └── Step 3-B: backend-agent
         ├── 依据技术规格实现 Controller / Service / Repository
         ├── 编写单元测试（正常流程 + 至少2个异常场景）
         └── 输出：实现代码 + 测试代码

   （如有前端）
   └── Step 3-C: frontend-agent
         ├── 依据接口规格实现页面和组件
         ├── 封装接口调用
         └── 输出：前端代码

Step 4: qa-agent
   ├── 设计测试用例（P0 + P1）
   ├── 执行功能测试和接口测试
   ├── 如发现 Bug → 通知 pm-agent 归属分析 → 对应 Agent 修复 → 重新测试
   └── 输出：测试报告（test-report.md 模板）

Step 5: reviewer-agent
   ├── 代码规范审查
   ├── 潜在问题识别
   ├── 架构合规性检查（对照 tech-spec.md）
   ├── 安全基线检查
   ├── 如有必须修改项 → 对应 Agent 修复 → 重新 Review
   └── 输出：review-report.md

Step 6: pm-agent
   ├── 汇总所有输出物
   ├── 检查交付清单是否完整
   └── 输出：交付报告
```

---

## 交付物清单

| 交付物 | 产出 Agent | 模板文件 |
|--------|-----------|---------|
| 任务单 | pm-agent | task-list.md |
| 技术规格文档 | architect-agent | tech-spec.md |
| 数据库迁移脚本 | dba-agent | - |
| 后端实现代码 | backend-agent | - |
| 前端实现代码 | frontend-agent | - |
| 测试报告 | qa-agent | test-report.md |
| Code Review 报告 | reviewer-agent | review-report.md |

---

## 关键约束

```
1. architect-agent 输出【必须先于】开发 Agent 开始工作
2. dba-agent 和 backend-agent（和 frontend-agent）可以并行
3. qa-agent 在所有开发完成后统一介入
4. reviewer-agent 是最后一道门，不在开发过程中介入
5. 所有数据库变更必须通过 Flyway 脚本，不能直接 DDL
```

---

## 异常处理

| 异常情况 | 处理方式 |
|---------|---------|
| qa-agent 发现 Bug | 通知 pm-agent → pm-agent 归属分析 → 派发对应 Agent 修复 → qa-agent 重测 |
| reviewer-agent 驳回 | 对应 Agent 修改 → reviewer-agent 重新 Review 被修改部分 |
| 接口规格需要变更 | 通知 pm-agent → 重新调用 architect-agent → 评估对开发进度的影响 |

---

## 估时参考

| 步骤 | 预估时间 |
|------|---------|
| pm-agent 分析 | 5 分钟 |
| architect-agent 设计 | 15-30 分钟 |
| 并行开发阶段 | 30-120 分钟（按功能复杂度）|
| qa-agent 测试 | 15-30 分钟 |
| reviewer-agent 审查 | 10-20 分钟 |
