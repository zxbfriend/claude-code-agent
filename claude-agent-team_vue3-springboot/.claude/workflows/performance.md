# 工作流：性能优化（Performance Optimization）

> 先定位再出方案，不同方向派发的 Agent 不同。

---

## 完整流程

```
性能问题报告
   │
   ▼
Step 1: pm-agent
   ├── 明确优化目标：接口慢 / 页面卡 / 数据库查询慢
   └── 按方向派发定位 Agent：
         ├── 接口慢 → backend-agent + dba-agent（并行分析）
         ├── 页面卡 → frontend-agent（分析）
         └── DB 慢 → dba-agent（分析）

Step 2: [定位 Agents]（问题定位阶段）
   ├── dba-agent：EXPLAIN 分析、慢查询日志分析
   ├── backend-agent：N+1 查询、代码层瓶颈分析
   └── frontend-agent：渲染性能、包体积分析

Step 3: architect-agent（综合优化方案）
   ├── 收集各 Agent 的定位结论
   ├── 制定综合优化方案（索引/缓存/查询优化/代码优化）
   └── 输出：优化方案文档

Step 4: [执行 Agents]（实施阶段）
   ├── dba-agent：索引迁移脚本
   ├── backend-agent：代码优化
   └── frontend-agent：前端优化

Step 5: qa-agent（性能测试验证）
   ├── 记录优化前基准数据
   ├── 测试优化后指标
   ├── 功能回归（确保优化没有破坏功能）
   └── 输出：性能测试报告（含前后对比）

Step 6: reviewer-agent
   ├── 索引设计合理性
   ├── 缓存策略是否有失效机制
   └── 输出：Review 结论
```

---

## 关键约束

```
1. 先【定位】再出方案，architect-agent 在收到定位结论后才介入
2. qa-agent 必须输出量化的性能对比数据（优化前 vs 优化后）
3. 功能回归不能遗漏（优化可能破坏已有功能）
4. 索引变更必须通过 Flyway 脚本（不可直接 ALTER TABLE）
```

---

---
