# Claude Code Agent Teams 中文完整指南

> 基于官方Agent Teams规范，适配多Agent协作的软件开发系统。

---

## 一、系统架构概览

```
用户自然语言需求
    ↓
pm-agent（团队负责人）
    ├─ 验证项目设置
    ├─ 分类任务类型
    ├─ 进行初步决策门控检查
    ├─ 组建开发团队
    ├─ 创建共享任务列表
    └─ 立即启动首个任务
    ↓
Agent团队（并行协作）
    ├─ architect-agent      技术设计（可选）
    ├─ backend-agent        后端实现
    ├─ frontend-agent       前端实现
    ├─ dba-agent            数据库迁移（可选）
    ├─ devops-agent         CI/CD和容器（可选）
    ├─ qa-agent             测试验证
    ├─ reviewer-agent       代码审查
    ├─ doc-agent            文档编写（可选）
    └─ security-agent       安全审计（可选）
    ↓
验证和交付
    ├─ 输出物存放于 outputs/{时间戳}_{项目ID}/
    ├─ 代码提交到特性分支
    └─ pm-agent 生成最终交付报告
```

---

## 二、项目文件结构

```
你的项目/
├── CLAUDE.md                          ← 项目指南（每个Agent启动时读取）
└── .claude/
    ├── settings.json                  ← 项目级配置（环境变量、权限、Hook）
    ├── config/
    │   └── VARIABLES.md               ← 上下文变量定义
    ├── messaging/
    │   └── PROTOCOL.md                ← Agent间消息格式规范
    ├── hooks/
    │   ├── teammate-idle.sh           ← 防止空闲（有可认领任务时阻止）
    │   ├── task-created.sh            ← 验证任务字段（非空title和id）
    │   └── task-completed.sh          ← 分支保护（禁止直接提交到main/master）
    ├── agents/
    │   ├── pm-agent.md                ← 团队负责人
    │   ├── architect-agent.md         ← 技术设计
    │   ├── backend-agent.md           ← 后端实现
    │   ├── frontend-agent.md          ← 前端实现
    │   ├── dba-agent.md               ← 数据库
    │   ├── devops-agent.md            ← DevOps
    │   ├── qa-agent.md                ← 测试
    │   ├── reviewer-agent.md          ← 代码审查
    │   ├── security-agent.md          ← 安全审计
    │   └── doc-agent.md               ← 文档
    ├── workflows/
    │   ├── new-feature.md             ← 新功能工作流
    │   ├── bug-fix.md                 ← 缺陷修复
    │   ├── refactor.md                ← 重构
    │   ├── change-request.md          ← 需求变更
    │   ├── performance.md             ← 性能优化
    │   ├── security-audit.md          ← 安全审计
    │   ├── dependency-upgrade.md      ← 依赖升级
    │   └── documentation.md           ← 文档编写
    └── templates/
        ├── tech-spec.md               ← 技术规范模板
        ├── decision-gate.md           ← 决策门控模板
        ├── task-list.md               ← 任务列表模板
        ├── test-report.md             ← 测试报告模板
        ├── review-report.md           ← 审查报告模板
        └── 其他交付物模板...
```

---

## 三、10大Agent角色详解

### 1. pm-agent（团队负责人）⭐
**职责**：编排全流程，不写生产代码
- ✅ 验证项目配置（占位符检查）
- ✅ 分类任务类型（8种工作流）
- ✅ 进行初步决策门控
- ✅ 组建合适的Agent团队
- ✅ 创建和维护共享任务列表
- ✅ 立即启动首个可执行任务（除非有真实阻塞）
- ✅ 监控执行进度，解除阻塞
- ✅ 合成最终交付报告

**关键规则**：
- 若没有真实阻塞，必须同时创建团队**和**启动执行
- 真实阻塞：决策门控打开 / 缺少仓库 / 缺少强制性人工输入
- 强制执行状态透明：明确说明是否已启动或阻塞原因

---

### 2. architect-agent（技术设计）
**职责**：产出规范，不写产品代码
- ✅ 输出API规范、数据模型、模块边界、技术决策
- ✅ 判断是否需要决策门控（多个方案>20%差异时）
- ✅ 判断是否需要计划审批
- ✅ 为其他Agent指导实现细节

**决策门控触发条件**：
- ✅ 两个或多个有效方案在成本/时间/风险差异>20%
- ✅ DB迁移涉及数据变换、回填或表合并
- ✅ 跨多层的架构影响
- ✅ 新外部依赖（Redis、MQ、支付、认证）
- ✅ 安全相关的架构决策

**不需要决策门控**的场景：标准CRUD、根因清晰的缺陷修复、遵循既有模式的新端点

**计划审批触发条件**：
- ✅ 引入新外部依赖
- ✅ 破坏性API变更（删除字段、改类型）
- ✅ 安全边界变化
- ✅ 含数据变换的DB迁移
- ✅ 部署拓扑变化

**不需要审批**的场景：标准CRUD、非破坏性API新增、缺陷修复、文档

---

### 3. backend-agent（后端实现）
**职责**：Java Spring Boot实现
- ✅ 实现Controller/Service/Repository
- ✅ 编写单元测试（主路径+至少2个失败路径）
- ✅ 遵循三层架构（Controller→Service→Repository）
- ✅ 提交到特性分支 `feature/TASK-{ID}`

**强制检查清单**：
- [ ] 所有Controller参数有 `@Valid`
- [ ] 业务异常用 `BusinessException`，不用原始RuntimeException
- [ ] 关键操作INFO日志，异常ERROR日志
- [ ] 多表操作用 `@Transactional`
- [ ] 单元测试覆盖：1个happy path + 至少2个失败路径
- [ ] MyBatis使用 `#{}` 不用 `${}`（防SQL注入）

**禁止行为**：
- ❌ `SELECT *` 查询
- ❌ 硬编码密钥/密码
- ❌ 吞掉异常不打日志
- ❌ 修改分配外的文件域

---

### 4. frontend-agent（前端实现）
**职责**：React/Vue实现
- ✅ 实现页面、组件、API集成
- ✅ 状态管理（loading/data/error/empty四态）
- ✅ 环境变量（不硬编码API URL）
- ✅ 提交到同一特性分支

**强制检查清单**：
- [ ] 使用共享request wrapper
- [ ] 所有异步操作有完整的四态处理
- [ ] 敏感数据不存localStorage（短期除外）
- [ ] 无未处理的API错误
- [ ] 只调用spec中定义的端点

**禁止行为**：
- ❌ 业务计算放在前端（价格、税、折扣）
- ❌ 直接DOM操作（用框架响应式）
- ❌ 硬编码API地址
- ❌ 修改分配外的文件域

---

### 5. dba-agent（数据库）⚠️ 可选
**职责**：仅当schema变更时才需要
- ✅ 编写Flyway迁移脚本
- ✅ 添加必要的索引
- ✅ SQL优化建议

**强制规则**：
- ✅ 版本必须由pm-agent分配（不能自动递增）
- ✅ 版本冲突时立即报BLOCKED
- ✅ 必须是Flyway脚本，不是直接ALTER
- ✅ 字符集utf8mb4、引擎InnoDB、软删除is_deleted

**禁止行为**：
- ❌ 脚本外修改表结构
- ❌ 物理DELETE用户数据（无人工批准）
- ❌ DML（INSERT/UPDATE）混入schema迁移
- ❌ 跳过Flyway直接改数据库

---

### 6. qa-agent（测试验证）
**职责**：质量门控
- ✅ 根据工作流执行P0/P1/P2测试
- ✅ 报告缺陷（通过pm-agent）
- ✅ 验证缺陷修复（有特定的回归范围）
- ✅ 阻止P0失败进入审查

**测试范围按工作流**：
| 工作流 | 范围 |
|---|---|
| 新功能 | P0 + P1 |
| 缺陷修复 | 有向回归（仅涉及功能+邻近烟雾测试） |
| 重构 | P0 + P1 + P2（全量，无例外） |
| 性能 | 功能回归+指标对比 |
| 依赖升级 | P0 + P1 + 兼容性检查 |

**回归范围规则**：
- **minimal**：单字段验证 → 仅重跑该测试
- **adjacent**：单方法改动 → 重跑该端点/组件的所有P0/P1
- **full**：跨层改动或共享工具 → 全量P0+P1回归

---

### 7. reviewer-agent（代码审查）
**职责**：最后的质量门控，只读不改
- ✅ 检查命名、Javadoc、null安全、N+1查询、事务边界
- ✅ 验证与tech spec的一致性
- ✅ 检查安全基线（无硬编码密钥、无敏感日志）

**评审结果**：
- ✅ **PASS** → 可部署
- ⚠️ **CONDITIONAL PASS** → 无阻塞项，有建议项留待后续
- ❌ **REJECT** → N个阻塞项，重新提交

**禁止行为**：
- ❌ 编辑任何文件
- ❌ 判断业务逻辑正确性（那是qa的职责）
- ❌ 因🟡或🔵项阻塞
- ❌ 用haiku简写（这个角色需要深度分析）

---

### 8. security-agent（安全审计）⚠️ 可选
**职责**：OWASP Top 10 + CVE扫描
- ✅ 检查访问控制、密码加密、SQL注入、组件漏洞
- ✅ 运行 `mvn dependency-check:check` 或 `npm audit`
- ✅ 分类严重性（Critical/High/Medium/Low）

**严重性阻塞规则**：
| 级别 | 行动 | 阻塞交付? |
|---|---|---|
| Critical | 立即修复后重审 | ✅ 是 |
| High | 当前迭代内修复 | ✅ 是 |
| Medium | 下个迭代处理 | ❌ 否 |
| Low | 建议 | ❌ 否 |

---

### 9. devops-agent（DevOps）⚠️ 可选
**职责**：CI/CD、容器、基础设施
- ✅ Dockerfile（多阶段、非root用户）
- ✅ K8s Deployment（资源限制、存活/就绪探针）
- ✅ 密钥管理（Vault或K8s Secret，不用ConfigMap）
- ✅ GitHub Actions流水线

**禁止行为**：
- ❌ 修改应用源代码
- ❌ 将密钥存在ConfigMap或ENV

---

### 10. doc-agent（文档）⚠️ 可选
**职责**：文档生成器
- ✅ API文档（Markdown）
- ✅ README和CHANGELOG更新
- ✅ 不虚构未实现的功能（用TBD标记）

**信息来源优先级**：
1. tech spec（最权威）
2. 代码注释（Javadoc/JSDoc）
3. 测试用例（验证行为）
4. 实现代码（最后手段，标记为"待验证"）

---

## 四、8种工作流分类

| 工作流 | 关键词 | 何时用 | 决策门控 | 测试范围 |
|---|---|---|---|---|
| **new-feature** | 新建/添加/实现 | 新功能 | 可能 | P0+P1 |
| **bug-fix** | 缺陷/错误/500 | 缺陷修复 | 否（通常） | 有向回归 |
| **refactor** | 重构/迁移/技术债 | 结构改进 | 可能 | P0+P1+P2（必须） |
| **change-request** | 变更/调整/修改 | 需求调整 | 可能 | 邻近烟雾 |
| **performance** | 慢/超时/延迟 | 性能优化 | 可能 | 功能回归+指标 |
| **security-audit** | 安全/CVE/审计 | 安全检查 | 否 | N/A（审计不是测试） |
| **dependency-upgrade** | 升级/版本/更新 | 依赖升级 | 可能 | 按升级风险 |
| **documentation** | 文档/README/API文档 | 文档编写 | 否 | N/A（文档） |

---

## 五、关键概念详解

### 1️⃣ 决策门控（Decision Gate）

**触发条件**（architect-agent判断）：
```
两个或多个技术方案存在，且在以下任一方面差异>20%：
  • 开发成本
  • 时间表
  • 运维复杂度
  • 风险等级
```

**流程**：
```
architect发现多个方案
    ↓
发送 DECISION-REQUIRED 给pm-agent（最高优先级）
    ↓
pm-agent暂停依赖任务（标记为blocked）
    ↓
pm-agent提交决策文档给人工审查
    ↓
人工选择一个方案
    ↓
pm-agent通知architect-agent决策结果
    ↓
architect继续设计，使用已选方案
```

**不触发决策门控的情况**：
- ❌ 标准CRUD功能
- ❌ 根因明确的缺陷修复
- ❌ 遵循既有模式的新端点
- ❌ 仅文档变更

---

### 2️⃣ 计划审批（Plan Approval）

architect发送 `ARCH-PLAN-REVIEW`，pm-agent回复 `ARCH-PLAN-APPROVED` 或 `REQUIRES_REVISION`

**何时需要**：
- ✅ 引入新外部依赖（Redis、MQ等）
- ✅ API破坏性变更（删除字段、改类型、删除端点）
- ✅ 安全边界变化（新认证方式、新PII路径）
- ✅ 含数据变换的DB迁移
- ✅ 部署拓扑变化（新服务、新基础设施）

**何时不需要**：
- ❌ 标准CRUD（即使跨后端+前端+DB）
- ❌ 非破坏性API新增字段或端点
- ❌ 缺陷修复
- ❌ 仅文档

**顺序很重要**：
```
如果既有决策门控又有计划审批：
  Step 1: 发送 DECISION-REQUIRED（先）
  Step 2: 等待人工决策
  Step 3: 发送 ARCH-PLAN-REVIEW（后）
  Step 4: 等待 ARCH-PLAN-APPROVED
  Step 5: 写最终tech spec

永远不要：在DECISION-REQUIRED未解决时发送ARCH-PLAN-REVIEW
```

---

### 3️⃣ Git分支约定

**分支命名**：
```
{type}/{TASK-ID}

类型（type）：
  • feature/TASK-20260427-001   → 新功能
  • fix/TASK-20260427-001        → 缺陷修复
  • refactor/TASK-20260427-001   → 重构
```

**提交信息**：
```
{type}({scope}): {简述}

任务: {TASK-ID}
Agent: {agent-name}

- {详细项1}
- {详细项2}

示例：
feat(auth): 实现JWT登录端点

任务: TASK-20260427-001
Agent: backend-agent

- 添加AuthController POST /api/v1/auth/login
- 添加AuthService含登录失败锁定（Redis）
- 单元测试：1个happy path + 3个失败场景
```

**分支保护**：
- ✅ 所有编码任务**必须**在特性分支上
- ❌ **禁止**直接提交到main/master
- ❌ Hook `task-completed.sh` 会阻止在main上标记完成

---

### 4️⃣ 文件域隔离（File Domain Isolation）

同时进行的任务**不能**修改相同的文件：

```json
{
  "TASK-001": {
    "assignee": "backend-agent",
    "file_domain": ["src/main/java/com/example/auth/"],
    "status": "in_progress"
  },
  "TASK-002": {
    "assignee": "frontend-agent",
    "file_domain": ["src/frontend/src/pages/auth/"],
    "status": "in_progress"
  },
  "TASK-003": {
    "assignee": "backend-agent",
    "file_domain": ["src/main/java/com/example/user/"],  // ❌ 与TASK-001不冲突
    "status": "pending"  // 但如果状态改成in_progress，则TASK-001应完成或变成pending
  }
}
```

**共享文件处理**（pom.xml、package.json、docker-compose等）：
```
如果多个任务需要修改同一共享文件：
  1. 选一个任务作为所有者
  2. 其他任务都 depends_on 这个所有者任务
  3. 所有者任务完成后，其他任务立即启动
```

---

### 5️⃣ 输出物目录结构

```
outputs/
└── {时间戳}_{项目ID}/
    ├── design/
    │   ├── {模块}_TECH-SPEC.md
    │   └── {模块}_DECISION-GATE.md          (如果触发决策门控)
    ├── implement/
    │   ├── {模块}_backend-agent.md
    │   ├── {模块}_frontend-agent.md
    │   └── {模块}_dba-agent.md
    ├── test/
    │   └── {模块}_TEST-REPORT.md
    ├── review/
    │   ├── {模块}_REVIEW-REPORT.md
    │   └── {模块}_SECURITY-REPORT.md       (如果跑安全审计)
    ├── deploy/
    │   └── {模块}_DEPLOY-PLAN.md
    ├── docs/
    │   └── {模块}_API-DOCS.md
    └── DELIVERY-REPORT.md
```

**时间戳格式**：`date -u +%Y%m%dT%H%M%S` → `20260427T143000`

每次运行创建新的时间戳文件夹，历史输出永不覆盖。

---

## 六、消息协议（Inter-Agent Messaging）

所有Agent向pm-agent发送消息使用这些格式：

### QA-REPORT（缺陷报告）
```
QA-REPORT: {TASK_ID}
Status: BUG_FOUND
Severity: Critical | High | Medium | Low
Assignee: backend-agent | frontend-agent | dba-agent | devops-agent
Bug ID: BUG-{YYYYMMDD}-{NNN}
Linked Test: TC-{NNN}
Evidence: {路径 | 请求响应 | 截图 | 日志}
Regression Scope: minimal | adjacent | full

描述:
{一句话总结}

重现步骤:
1. {步骤}
2. {步骤}

预期结果:
{应该发生什么}

实际结果:
{实际发生了什么}
```

### DECISION-REQUIRED（决策门控）
```
DECISION-REQUIRED: {TASK_ID}
话题: {短标题}
阻塞任务: {TASK_ID列表}
决策文档: {OUTPUT_BASE}/design/{MODULE}_DECISION-GATE.md
建议: 选项A | 选项B | 选项C

原因:
{为什么需要人工决策}
```

### ARCH-PLAN-REVIEW（计划审批请求）
```
ARCH-PLAN-REVIEW: {TASK_ID}
状态: PENDING_APPROVAL
阶段: draft_design
文档: {OUTPUT_BASE}/design/{MODULE}_TECH-SPEC.md（草稿）
范围: backend | frontend | dba | devops | security
外部依赖: yes | no; {如果yes则列出}
决策门控已解决: yes | n/a

关键决策:
- {决策1}
- {决策2}

等待批准...
```

**pm-agent回复**：
```
ARCH-PLAN-APPROVED: {TASK_ID}
决策: APPROVED | APPROVED_WITH_NOTES | REQUIRES_REVISION
备注: {反馈内容}
```

### BLOCKED（任务阻塞）
```
BLOCKED: {TASK_ID}
执行人: {agent-name}
原因: {具体阻塞原因}
需要来自: pm-agent | architect-agent | 其他Agent | 用户
阻塞开始: {时间戳}
```

### TASK-COMPLETED（任务完成）
```
TASK-COMPLETED: {TASK_ID}
执行人: {agent-name}
分支: {分支名}
输出路径: {OUTPUT_BASE}/{阶段}/{输出物}
提交数: {N}
状态: completed

总结:
{简短总结}

后续项:
{无或列表}
```

---

## 七、Hook脚本工作原理

### task-created.sh（任务创建验证）
```bash
检查：
  ✅ task_subject 非空（每个任务必须有标题）
  ✅ task_id 存在（系统分配）
  
若检查失败 → 拒绝创建，返回错误信息
```

### task-completed.sh（分支保护）
```bash
判断是否为编码任务：
  1. teammate_name 是否为已知编码Agent之一
     (backend-agent, frontend-agent, dba-agent, devops-agent, doc-agent)
  2. 或 task_subject 包含编码关键词
     (implement, fix, refactor, backend, component, etc.)

如果是编码任务：
  检查当前分支 ≠ main/master
  如果在main/master上 → 拒绝完成，提示创建特性分支
  
如果是非编码任务（如文档、决策）：
  直接允许完成
```

### teammate-idle.sh（防止空闲）
```bash
检查该Agent是否有可认领的任务：
  一个任务"可认领"需要满足：
    1. status == "pending"（未开始）
    2. assignee 匹配该Agent 或 assignee为空（未分配）
    3. depends_on 中所有任务都已 "completed"

如果有可认领任务 → 阻止空闲，返回任务列表
如果没有可认领任务 → 允许空闲
```

---

## 八、并发控制

```yaml
最大并发Agent数: 4

任务超时规则:
  design:    4小时
  implement: 8小时
  fix:       8小时
  refactor:  8小时
  test:      4小时
  review:    2小时
  security:  2小时
  deploy:    4小时
  docs:      4小时
```

**执行策略**：
```
MAX_CONCURRENT_AGENTS = 4

Step 1: pm-agent 创建所有任务
Step 2: 找首个无依赖的任务，标记为 in_progress
Step 3: 启动这个任务
Step 4: 当任务完成时
  Step 4a: 将其他依赖它的任务状态改为 pending
  Step 4b: 扫描新的可执行任务
  Step 4c: 如果当前 in_progress 数 < 4，启动下一个
  Step 4d: 如果当前 in_progress 数 = 4，保持其他为 pending

禁止同时运行5个或以上任务（非常特殊情况下需人工批准）
```

---

## 九、质量门控（非协商）

| 门控 | 执行者 | 条件 |
|---|---|---|
| 设计审查 | 人工 | 当 decision-required 任务存在 |
| 测试通过 | qa-agent | 所有P0测试必须通过再进入审查 |
| 代码审查 | reviewer-agent | 审查通过才能部署 |
| 安全扫描 | security-agent | 认证/支付/PII变更时必须 |
| 禁止main直交 | Hook | 所有编码任务 |

---

## 十、禁止行为清单

```
❌ pm-agent写产品代码
❌ architect-agent写实现代码
❌ 任何Agent跳过生效的决策门控
❌ 实现任务在决策/审批未完成时启动
❌ SELECT * 查询
❌ 硬编码密钥/密码/IP地址
❌ 吞掉异常不打日志
❌ 在main/master直接提交编码任务
❌ 修改分配域外的文件
❌ dba-agent跳过Flyway直接改表
❌ ARCH-PLAN-REVIEW在DECISION-REQUIRED未解决时发送
❌ 超过4个Agent同时执行（无人工批准）
```

---

## 十一、快速开始清单

### 初始化（一次性）
```bash
# 1. 复制配置文件到项目
cp -r .claude/ /你的项目/

# 2. 填写CLAUDE.md占位符
# 项目ID、技术栈、仓库、主分支

# 3. 验证无占位符遗漏
grep -E "\{your-" CLAUDE.md && echo "ERROR" || echo "OK"
```

### 启动Agent团队
```bash
# 在Claude Code中输入自然语言需求，例如：

"实现用户认证，支持JWT。创建Agent团队。"
"修复登录时500错误。创建Agent团队。"
"重构支付模块，使用策略模式。创建Agent团队。"
"订单列表API太慢（>3s）。创建Agent团队。"
```

### 监控进度
```
pm-agent会：
  ✅ 创建任务列表（TASK-LIST.md）
  ✅ 显示当前活跃任务和阻塞
  ✅ 自动启动可执行任务
  ✅ 路由缺陷和决策给人工

你需要：
  👁️ 观察输出，查看进度
  🚪 在决策门控打开时做选择
  ✅ 任务完成后合并特性分支
```

---

## 十二、常见场景示例

### 场景1：新增登录功能（新功能工作流）
```
用户: "实现JWT登录。创建Agent团队。"
  ↓
pm-agent:
  ✅ 分类: new-feature
  ✅ 判断:需要 architect, backend, frontend, dba, qa, reviewer
  ✅ 创建5个任务
  ✅ 启动 architect-agent 进行设计
  ↓
architect-agent:
  ✅ 阅读现有代码
  ✅ 设计API（POST /login）、数据模型（user表）、错误码
  ✅ 判断: 需要计划审批吗? → 否（标准CRUD）
  ✅ 写tech-spec.md
  ✅ 发送 TASK-COMPLETED
  ↓
pm-agent:
  ✅ 解除backend/frontend/dba任务的阻塞
  ✅ 同时启动这3个任务
  ↓
backend/frontend/dba 并行工作...
  ↓
qa-agent:
  ✅ 等待全部实现完成
  ✅ 执行P0+P1测试
  ✅ 发送 TEST-REPORT
  ↓
reviewer-agent:
  ✅ 审查代码质量和arch compliance
  ↓
pm-agent:
  ✅ 合成最终交付报告
  ✅ 提交 DELIVERY-REPORT.md
```

### 场景2：修复登录500错误（缺陷修复工作流）
```
qa发现: 登录时返回500

流程:
  1. qa-agent 发送 QA-REPORT
  2. pm-agent 创建fix任务，分配给 backend-agent
  3. backend-agent 修复并提交 BUG-FIXED
  4. qa-agent 做有向回归（仅涉及功能+邻近烟雾）
  5. reviewer-agent 快速审查（可用轻量检查表）
  6. pm-agent 更新 DELIVERY-REPORT
```

### 场景3：决策门控：缓存策略选择
```
architect在设计时发现：
  • 方案A: 进程内缓存 → 开发2h，运维简单，成本$0
  • 方案B: Redis分布式缓存 → 开发4h，支持多进程，成本$200/月

差异>20% → 触发决策门控

步骤:
  1. architect 发送 DECISION-REQUIRED
  2. pm-agent 阻塞依赖任务
  3. 人工选择方案（例如方案A，因为流量小）
  4. pm-agent 通知architect
  5. architect 继续设计，使用选中方案
  6. 后续任务解除阻塞
```

---

## 十三、故障排查

| 现象 | 原因 | 解决 |
|---|---|---|
| 团队已创建但无任务启动 | 首个任务有阻塞（通常是决策门控） | pm-agent会明确说明阻塞原因 |
| Agent卡住不动 | 依赖未完成 或 Agent出错 | 检查TASK-LIST依赖关系 或 重启Agent |
| 直接提交main时被hook拒绝 | 这是设计特性，防止主分支污染 | 创建特性分支: `git checkout -b feature/TASK-ID` |
| Flyway版本冲突 | dba-agent自动递增版本 | pm-agent必须集中分配版本，dba需请求重新分配 |
| 计划审批一直等不到回复 | pm-agent忘记发送或丢失消息 | 检查通信日志 或 手动提醒pm-agent |

---

## 总结

这个Agent Teams系统用**7条核心原则**运作：

1. **pm-agent主导** → 分类、组建、编排、交付
2. **architect设计** → 规范输出，非代码实现
3. **平行实现** → backend/frontend/dba同时工作
4. **质量门控** → 决策→设计→实现→测试→审查→部署
5. **文件域隔离** → 并发任务不互相干扰
6. **分支保护** → 所有编码都在特性分支
7. **人工决策** → 多个方案>20%差异时暂停

**核心价值**：用结构化的Agent角色和消息协议，让多个AI自动化协作完成整个开发流程，同时保留人工决策的关键节点。
