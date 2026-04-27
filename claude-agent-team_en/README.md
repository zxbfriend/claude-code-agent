# Claude Code Agent Teams 重构方案 · 使用指南

> 完全适配官方 Claude Code Agent Teams 技术规范。
> 自主规划、任务驱动、协同执行的多智能体开发系统。

---

## 📋 系统概览

```
用户需求（自然语言）
    ↓
pm-agent（主会话 Lead）
    ├─ 分析需求，判断任务类型
    ├─ 决策门检查（多方案权衡）
    ├─ 动态装配 Agent 团队
    └─ 创建共享任务列表
    ↓
Agent 团队（并行协作）
    ├─ architect-agent       设计方案（可选）
    ├─ backend-agent         后端实现
    ├─ frontend-agent        前端实现
    ├─ dba-agent             数据库设计（可选）
    ├─ devops-agent          部署配置（可选）
    ├─ doc-agent             文档编写（可选）
    ├─ qa-agent              测试验证
    ├─ reviewer-agent        代码审查
    └─ security-agent        安全审计（可选）
    ↓
验证 & 交付
    ├─ 输出物存储在 outputs/{TIMESTAMP}_{PROJECT_ID}/
    ├─ 代码提交到特性分支（feature/TASK-ID）
    └─ pm-agent 汇总交付报告
```

---

## 📦 交付内容概览

本方案由 29 个文件组成，约 8,000 行配置、流程、模板和示例内容：

```
agent-teams/
├── 📘 主要配置
│   ├── CLAUDE.md                 项目总纲，所有 agent 读取
│   ├── settings.json             Claude Code 启用 Agent Teams
│   └── README.md                 完整使用指南
│
├── 🤖 10 个 Agent 定义（.claude/agents/）
│   ├── pm-agent.md               主会话、任务调度、汇总交付
│   ├── architect-agent.md        设计专家、决策门触发
│   ├── backend-agent.md          Java Spring Boot 实现
│   ├── frontend-agent.md         React/Vue 实现
│   ├── dba-agent.md              数据库迁移脚本、SQL 优化
│   ├── devops-agent.md           CI/CD、Docker、K8s
│   ├── qa-agent.md               功能测试、回归测试、性能测试
│   ├── reviewer-agent.md         代码审查、架构合规、安全基线
│   ├── security-agent.md         安全审计、OWASP、CVE 扫描
│   └── doc-agent.md              API 文档、README、CHANGELOG
│
├── 📋 8 个工作流（.claude/workflows/）
│   ├── new-feature.md            新功能开发
│   ├── bug-fix.md                Bug 修复
│   ├── refactor.md               技术重构
│   ├── change-request.md         需求变更
│   ├── performance.md            性能优化
│   ├── security-audit.md         安全审计
│   ├── dependency-upgrade.md     依赖升级
│   └── documentation.md          文档编写
│
├── 📑 5 个输出模板（.claude/templates/）
│   ├── tech-spec.md              技术规格文档
│   ├── decision-gate.md          多方案对比、决策文档
│   ├── test-report.md            测试报告、Bug 追踪
│   ├── review-report.md          代码审查、MUST/SUGGEST/OPT
│   └── task-list.md              共享任务列表、依赖管理
│
└── 🔧 3 个自动化 Hook（.claude/hooks/）
    ├── teammate-idle.sh          检查待办任务，阻止空闲
    ├── task-created.sh           验证任务字段和类型
    └── task-completed.sh         检查不能在 main 直接提交
```

---

## 🚀 快速开始

### 1. 初始化项目

```bash
# 复制本方案到项目根目录
cp -r agent-teams-config/.claude ./your-project/
cp -r agent-teams-config/settings.json ./your-project/
cp agent-teams-config/CLAUDE.md ./your-project/

# 编辑 CLAUDE.md，填写项目信息
nano CLAUDE.md
# 修改：
#   PROJECT_ID: 你的项目名
#   TECH_STACK: 你的技术栈
#   MAIN_BRANCH: main 或 master
```

### 2. 创建第一个任务

打开 Claude Code，说：

```
我需要实现用户登录功能。
创建一个 Agent Team，包括接口设计、后端实现、前端实现、数据库设计、测试和代码审查。
```

Claude（pm-agent）会：
1. ✅ 分析需求 → 判定为"新功能开发"
2. ✅ 评估决策门 → 无需多个方案确认
3. ✅ 动态装配团队 → architect + backend + frontend + dba + qa + reviewer
4. ✅ 创建共享任务列表
5. ✅ 自动生成 outputs/{TIMESTAMP}_ecommerce-api/design/auth_TECH-SPEC.md

### 3. 监督执行进度

pm-agent（主会话）会持续：
- 📊 跟踪任务状态（pending → in_progress → completed）
- 🔗 管理依赖关系（等待前置任务完成）
- ⚠️ 触发人工决策门（如果有多套可行方案）
- 🔄 协调并行执行（后端 + 前端 + 数据库可同时进行）

### 4. 获得交付报告

所有任务完成后，pm-agent 生成最终报告：

```
DELIVERY-REPORT.md
├─ 技术规格       outputs/.../auth_TECH-SPEC.md
├─ 后端代码       src/main/java/com/example/auth/*.java
├─ 前端代码       src/frontend/src/pages/auth/*.jsx
├─ 数据库迁移     src/main/resources/db/migration/V*.sql
├─ 测试报告       outputs/.../auth_TEST-REPORT.md
├─ 审查报告       outputs/.../auth_REVIEW-REPORT.md
└─ 特性分支       feature/TASK-20260426-001
```

---

## 📂 目录结构说明

```
your-project/
├── CLAUDE.md                  ← 项目总纲（每个 agent 启动时读取）
├── settings.json              ← Claude Code 配置（启用 Agent Teams）
│
├── .claude/
│   ├── agents/
│   │   ├── pm-agent.md           ← 团队主导者，8 步协调流程
│   │   ├── architect-agent.md    ← 设计专家，可触发决策门
│   │   ├── backend-agent.md      ← Java 实现
│   │   ├── frontend-agent.md     ← React/Vue 实现
│   │   ├── dba-agent.md          ← 数据库迁移（可选）
│   │   ├── devops-agent.md       ← CI/CD 和容器（可选）
│   │   ├── qa-agent.md           ← 测试验证
│   │   ├── reviewer-agent.md     ← 代码审查
│   │   ├── security-agent.md     ← 安全审计（可选）
│   │   └── doc-agent.md          ← 文档生成（可选）
│   │
│   ├── workflows/
│   │   ├── new-feature.md        ← 新功能开发（8 步）
│   │   ├── bug-fix.md            ← Bug 修复（5 步）
│   │   ├── refactor.md           ← 技术重构（7 步）
│   │   ├── change-request.md     ← 需求变更（影响范围分析）
│   │   ├── performance.md        ← 性能优化（6 步 + 性能对比）
│   │   ├── security-audit.md     ← 安全审计（OWASP Top 10）
│   │   ├── dependency-upgrade.md ← 依赖升级（全量回归）
│   │   └── documentation.md      ← 文档编写（单 agent）
│   │
│   ├── templates/
│   │   ├── tech-spec.md          ← 技术规格模板
│   │   ├── decision-gate.md      ← 决策门模板（多方案对比）
│   │   ├── test-report.md        ← 测试报告模板
│   │   ├── review-report.md      ← 代码审查报告模板
│   │   └── task-list.md          ← 共享任务列表模板
│   │
│   └── hooks/
│       ├── teammate-idle.sh      ← 检查待办任务，阻止空闲
│       ├── task-created.sh       ← 验证任务字段
│       └── task-completed.sh     ← 检查不能在 main 提交实现
│
├── outputs/
│   └── {TIMESTAMP}_{PROJECT_ID}/
│       ├── design/
│       │   └── auth_TECH-SPEC.md
│       ├── implement/
│       │   ├── auth_backend.md
│       │   ├── auth_frontend.md
│       │   └── auth_dba.md
│       ├── test/
│       │   └── auth_TEST-REPORT.md
│       ├── review/
│       │   ├── auth_REVIEW-REPORT.md
│       │   └── auth_SECURITY-AUDIT.md
│       ├── deploy/
│       │   └── auth_DEPLOY-PLAN.md
│       ├── docs/
│       │   └── auth_API-DOCS.md
│       └── DELIVERY-REPORT.md
│
├── src/
│   ├── main/
│   │   ├── java/com/example/       ← 后端代码
│   │   └── resources/
│   │       └── db/migration/       ← Flyway 数据库迁移脚本
│   │
│   ├── test/                       ← 单元测试
│   │
│   └── frontend/                   ← 前端代码（React/Vue）
│
└── .git/
    └── feature/TASK-20260426-001   ← 特性分支（自动创建）
```

---

## 🎯 8 种任务类型与对应流程

| 任务类型 | 触发关键词 | 流程文件 | 核心 Agent | 调用 architect? | 测试范围 |
|---|---|---|---|---|---|
| **new-feature** | 新增/开发/实现 | new-feature.md | backend + frontend | ✅ 必须 | P0 + P1 |
| **bug-fix** | Bug/错误/崩溃 | bug-fix.md | 对应 agent | ❌ 通常不需 | 定向回归 |
| **refactor** | 重构/迁移/技术债 | refactor.md | 实现 agents | ✅ 主导 | P0 + P1 + P2 |
| **change-request** | 变更/调整需求 | change-request.md | 按影响路由 | 条件 | 按路由 |
| **performance** | 慢/卡/性能 | performance.md | dba + backend | ✅ 综合方案 | 含性能对比 |
| **security-audit** | 安全/CVE/审计 | security-audit.md | security | ✅ 指导 | OWASP Top 10 |
| **dependency-upgrade** | 升级/更新依赖 | dependency-upgrade.md | 开发 agent | 条件（Major） | P0 + P1 + P2 |
| **documentation** | 文档/README/API | documentation.md | doc-agent | ❌ 不需要 | 一致性检查 |

---

## 🔄 任务状态与依赖管理

### 任务四态

```
① pending      →  等待前置任务完成，或等待 agent 认领
② in_progress  →  agent 正在工作
③ completed    →  工作完成，输出物已生成
④ blocked      →  被前置任务或决策门阻塞，无法开始
```

### 依赖链示例

```
设计（design）
    ↓ 必须完成
实现（implement）×3 [并行]
    ├─ backend-agent
    ├─ frontend-agent
    └─ dba-agent
    ↓ 都完成后
测试（test）
    ↓ 通过后
审查（review）
    ↓ 通过后
部署（deploy）
```

---

## 🎨 决策门机制

当 architect-agent 遇到多个技术可行方案时，系统自动暂停：

### 触发条件

- ✅ 缓存策略：Redis 单机 vs 集群 vs Memcached
- ✅ 认证方案：JWT vs Session vs OAuth
- ✅ DB 分库：何时、如何、成本评估
- ✅ 消息队列：RabbitMQ vs Kafka vs Redis Stream

### 决策流程

```
architect-agent 发现多个方案
    ↓
创建 decision-required 任务
    ↓
生成 decision-gate.md（方案对比、风险、成本）
    ↓
pm-agent 向人工展示决策文档
    ↓
人工选择一个方案
    ↓
pm-agent 标记 decision-required = completed
    ↓
所有阻塞的实现任务自动解锁
```

**示例：**

```markdown
## 决策 — 缓存策略选择

### 方案 A：Redis 单机
- 优：简单，成本低，开发快
- 缺：单点故障，无高可用
- 适用：当前 QPS < 1000

### 方案 B：Redis Cluster
- 优：高可用，自动故障转移
- 缺：运维复杂，成本高
- 适用：需要多机部署、SLA > 99.9%

[人工选择] → 选方案 A，后期再升级
```

---

## 📊 关键特性

### 1. 自主决策

- ✅ pm-agent 自动分类任务 → 路由到正确流程
- ✅ 根据影响范围动态选择 agent（dba-agent 可选）
- ✅ 自动管理依赖和并行执行

### 2. 人机协同

- 🤝 技术决策的关键点暂停等待人工确认
- 🤝 多方案权衡时呈现决策文档供人工选择
- 🤝 高风险问题（Critical CVE、架构重构）需要人工签字

### 3. 多 Agent 协同

- 🔗 共享任务列表自协调（文件域隔离）
- 🔗 Hook 机制防止意外（不能直接提交到 main）
- 🔗 输出物统一存储（时间戳 + 版本号）

### 4. 全生命周期覆盖

| 阶段 | 参与 Agent | 产出 |
|---|---|---|
| 需求分析 | pm-agent | 任务拆分 + 依赖关系 |
| 技术设计 | architect-agent | tech-spec |
| 代码实现 | backend/frontend/dba | 源代码 + 迁移脚本 |
| 测试验证 | qa-agent | test-report |
| 代码审查 | reviewer-agent | review-report |
| 安全检查 | security-agent | security-audit |
| 文档编写 | doc-agent | API 文档 + README |
| 部署配置 | devops-agent | 容器 + CI/CD |

---

## ⚙️ 配置与定制

### 修改 CLAUDE.md 以适配你的项目

```yaml
PROJECT_ID: my-ecommerce-api      # 项目标识
TECH_STACK: Java 17 / Spring Boot 3 / React 18 / MySQL 8
REPO_URL: https://github.com/yourorg/myproject
MAIN_BRANCH: main

# 自定义技术约束
JAVA_VERSION: 17+
ORM: MyBatis-Plus 3.x
TEST_FRAMEWORK: JUnit 5
FRONTEND: React 18+
DB_CHARSET: utf8mb4
```

### 启用/禁用可选 Agent

在 pm-agent 创建 team 时，只有实际需要的 agent 才会被启动：

```bash
# 新功能开发 → architect + backend + frontend + dba + qa + reviewer
# Bug 修复    → 对应 agent（通常 backend 或 frontend）
# 文档编写    → doc-agent（仅此一个）
# 安全审计    → security-agent（仅此一个）
```

---

## 🛡️ 安全 & 质量网关

### 四道质量门（逐层严格）

```
① architect-agent 检查设计合理性
    ↓ 通过后
② dba-agent / backend-agent / frontend-agent 实现代码
    ↓ 通过后
③ qa-agent 功能和回归测试
    ↓ 通过后
④ reviewer-agent 代码质量、架构合规、安全基线
    ↓
⑤ (可选) security-agent 深度安全审计
    ↓
✅ 允许合并和部署
```

### 禁止行为（自动检查）

```bash
❌ 直接在 main/master 提交实现代码       ← task-completed hook 拒绝
❌ 无 dba 迁移脚本直接修改数据库结构      ← dba-agent 规范
❌ SELECT * 查询                         ← reviewer-agent 驳回
❌ 明文密码/密钥在代码中                  ← security-agent 拒绝
❌ 跳过 qa-agent 测试直接审查            ← 任务依赖阻塞
```

---

## 📈 性能指标

| 指标 | 目标 | 说明 |
|---|---|---|
| 新功能端到端时间 | 2-4 小时 | 设计 + 并行实现 + 测试 + 审查 |
| Bug 修复周期 | 30-60 分钟 | 定位 + 修复 + 定向测试 |
| 代码审查耗时 | 10-20 分钟 | reviewer-agent 快速审查 |
| 测试覆盖率 | ≥ 80% | 新功能必须附带单元测试 |

---

## 🔗 与 Git 工作流的集成

### 自动分支管理

```bash
# 任务 TASK-20260426-001 时自动创建
git checkout -b feature/TASK-20260426-001

# 实现完成时自动提交（不推送）
git commit -m "feat(auth): implement login

Task: TASK-20260426-001
Agent: backend-agent"

# 审查通过后，pm-agent 指导推送
git push origin feature/TASK-20260426-001
# 并由人工 merge pull request
```

### 输出物版本管理

```
outputs/
├─ 20260426T143000_ecommerce-api/  ← 本次任务输出（UTC 时间戳）
│   ├─ design/auth_TECH-SPEC.md
│   ├─ test/auth_TEST-REPORT.md
│   └─ ...
├─ 20260426T180000_ecommerce-api/  ← 下次任务输出（互不覆盖）
│   └─ ...
```

---

## 📚 使用示例

### 示例 1：新功能 — 用户登录

```
用户输入："实现用户登录功能"
    ↓
pm-agent（主会话）
    ├─ 分类 → new-feature 流程
    ├─ 评估 → 无决策门（登录是标准模式）
    ├─ 装配 → architect + backend + frontend + dba + qa + reviewer
    └─ 创建任务列表（8 个任务）
    ↓
architect-agent（design 任务）
    ├─ 产出：tech-spec（接口、数据模型、Redis 缓存策略）
    └─ 状态：completed
    ↓
[并行] backend + frontend + dba（implement 任务）
    ├─ backend-agent：AuthController + AuthService + 单元测试
    ├─ frontend-agent：LoginPage + 状态管理 + API 集成
    ├─ dba-agent：Flyway 迁移脚本（V1.0.1__create_user_table.sql）
    └─ 状态：都 completed，分别提交到 feature/TASK-xxx
    ↓
qa-agent（test 任务）
    ├─ 设计：P0（正常登录）+ P1（失败锁定）
    ├─ 发现 Bug：账户解锁逻辑错误
    ├─ 通知 pm-agent → 派遣 backend-agent 修复
    ├─ 重测 → 通过
    └─ 状态：completed，输出 test-report.md
    ↓
reviewer-agent（review 任务）
    ├─ 检查：Javadoc、null-safety、SQL 参数化、无硬编码密钥
    ├─ 发现 MUST 问题：空指针处理
    ├─ 通知 backend-agent → 修复
    ├─ 重审 → 通过
    └─ 状态：completed，输出 review-report.md
    ↓
pm-agent（汇总）
    ├─ 收集所有输出物
    ├─ 生成 DELIVERY-REPORT.md
    └─ 指导用户合并分支和部署
```

### 示例 2：Bug 修复 — 登录页面崩溃

```
用户输入："登录页面点击登录按钮时崩溃"
    ↓
pm-agent（主会话）
    ├─ 分类 → bug-fix 流程
    ├─ 归属分析 → 页面崩溃，可能是前端 JS 错误
    ├─ 装配 → frontend-agent + qa-agent + reviewer-agent
    └─ 创建任务列表（3 个任务）
    ↓
frontend-agent（fix 任务）
    ├─ 创建分支：git checkout -b fix/TASK-20260426-002
    ├─ 复现 → 点击按钮时报 undefined is not a function
    ├─ 定位 → LoginForm.jsx 第 45 行，handleSubmit 函数绑定错误
    ├─ 修复 → 绑定 this，提交单元测试
    └─ 状态：completed
    ↓
qa-agent（test 任务）
    ├─ 测试范围：仅登录页面（定向，不全量）
    ├─ 验证修复有效 → 点击按钮不再崩溃
    ├─ 验证无副作用 → 其他页面正常
    └─ 状态：completed
    ↓
reviewer-agent（review 任务）
    ├─ 快速审查（修改少）→ 5 行代码改动，逻辑清晰
    ├─ 检查是否有遗漏 → 无
    └─ 状态：completed，PASS
    ↓
pm-agent（汇总）
    ├─ 生成 DELIVERY-REPORT.md
    └─ Bug 关闭
```

### 示例 3：决策门 — 缓存策略选择

```
用户输入："性能优化，登录接口响应时间从 3s 降到 200ms"
    ↓
pm-agent → performance 流程
    ├─ dba-agent 定位：SELECT user WHERE phone=? 无索引，全表扫描
    ├─ backend-agent 定位：无缓存，每次都查库
    └─ architect-agent 综合方案
        ├─ 方案 A：新建 UK(phone) 索引 + 本地 HashMap 缓存
        │   优：开发快（1 h），缺：无分布式高可用
        │
        ├─ 方案 B：新建 UK(phone) 索引 + Redis 缓存
        │   优：高可用，缺：依赖 Redis（已有）
        │
        └─ 方案 C：分库分表 + Redis
            优：极限扩展性，缺：工作量大（20 h），目前不需要
    ↓
[决策门触发]
architect-agent 生成 decision-gate.md（方案对比、成本、风险）
    ↓
pm-agent 暂停，向用户呈现决策文档
    ↓
用户选择：方案 B（Redis 缓存 + 索引）
    ↓
pm-agent 标记 decision-required = completed
    ↓
所有实现任务解锁 → dba-agent + backend-agent 并行执行
    ├─ dba-agent：添加索引迁移脚本
    └─ backend-agent：集成 Redis 缓存
    ↓
qa-agent 性能测试验证
    └─ 对比：P99 从 3200ms → 180ms（↑94%）
```

---

## 🆘 常见问题

### Q1：我的项目是前端专用，需要 Agent Teams 吗？

**A：** 需要。即使只有前端 code，也推荐用此方案：
- pm-agent 管理任务流程
- frontend-agent 实现
- qa-agent 测试
- reviewer-agent 审查

### Q2：能否跳过某些 Agent（如不需要 dba-agent）？

**A：** 完全可以。pm-agent 会根据任务类型动态装配：
- 新功能开发：自动包含 dba-agent（如有 DB 变动）
- 纯前端 Bug 修复：仅包含 frontend-agent
- 文档任务：仅包含 doc-agent

### Q3：如果发现设计有问题，还能改吗？

**A：** 可以。但需要通过流程：
1. 通知 pm-agent 暂停实现任务
2. pm-agent 通知 architect-agent 修正方案
3. 修正后再解锁实现任务

### Q4：Git 分支怎么管理？

**A：** 自动管理：
- 每个任务 → 一个特性分支 feature/TASK-{ID}
- 无法直接提交到 main（task-completed hook 检查）
- 由人工进行最终的 merge 和部署

### Q5：性能优化时需要对标很具体的数据吗？

**A：** 是的。qa-agent 输出的性能报告必须包含：
- 优化前 & 优化后的 P50 / P99 响应时间
- CPU / 内存占用对比
- 吞吐量（QPS）对比

### Q6：能否并行多个 Agent 修改同一个文件？

**A：** 不推荐，容易冲突。任务列表的 file_domain 字段用来隔离：
```
backend-agent 的 file_domain：src/main/java/com/example/auth/
frontend-agent 的 file_domain：src/frontend/src/pages/auth/
```
共享配置文件（pom.xml、package.json）需要串行处理。

---

## 📌 适用项目类型

### ✅ 完全适合

- Java Spring Boot + React/Vue 项目
- 有完整的后端 / 前端 / 数据库分层
- 需要严格的代码质量控制
- 多人团队协作

### ✅ 部分适用（可定制）

- 纯前端项目（移除 backend-agent 和 dba-agent）
- 纯后端项目（移除 frontend-agent）
- 小型个人项目（简化流程，保留核心 agents）

### ❌ 不适合

- 超小型脚本（一次性代码）
- 需要自由创意发挥的研究项目（文档化成本较高）

---

## 📊 预期收益

| 指标 | 改善方向 |
|---|---|
| **代码质量** | 从个人编码习惯 → 统一规范 |
| **缺陷发现** | 从测试阶段才发现 → 设计阶段提前预防 |
| **交付周期** | 从串行交付 → 多 agent 并行推进 |
| **技术文档** | 从无文档或零散文档 → 完整 spec + API 文档 |
| **团队信任** | 从依赖个人记忆 → 由流程保证关键检查 |

---

## 🔄 持续改进

### 反馈循环

```
运行 Team 1 → 发现问题 / 改进想法
    ↓
收集意见 → 更新 agent 定义或 workflow
    ↓
运行 Team 2 → 验证改进效果
    ↓
持续迭代
```

### 何时修改方案

| 场景 | 处理方式 |
|---|---|
| 发现 agent 职责有重叠 | 调整 agent 定义，明确边界 |
| 某个工作流步骤过多 | 合并相关步骤，优化流程 |
| 输出物格式不满足需求 | 更新模板，增加新字段 |
| 新增特定项目需求 | 创建定制的工作流或模板 |

---

## 📞 反馈与改进

本方案基于 Claude Code Agent Teams 官方规范（2025）。

若遇到问题或改进建议，欢迎：
- 📝 在项目 Issue 中记录
- 🔧 Fork 本方案并提交 PR
- 💬 在讨论区分享用法

---

## 📄 许可与使用

本方案完全开源，可自由使用、修改和分发。

希望这套系统能帮助你的团队高效协作。Happy coding! 🚀
