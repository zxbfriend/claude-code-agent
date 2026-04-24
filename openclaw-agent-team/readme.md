# 🤖 OpenClaw 多 Agent 开发系统

> 基于 OpenClaw 框架的多智能体协作开发方案，通过 PM 统一调度各专业 Agent，实现从需求到交付的完整闭环。

---

## 📋 目录

1. [推荐 Agent 阵容](#-推荐-agent-阵容)
2. [模型分配建议](#-模型分配建议)
3. [完整工作流](#-完整工作流)
4. [文件说明](#-文件说明)
5. [部署指南](#-部署指南)
6. [冒烟测试](#-冒烟测试)
7. [常见问题](#-常见问题)

---

## 🎯 推荐 Agent 阵容

### 🔴 核心常驻（每个项目都需要）

| Agent | 职责 | 推荐模型 |
|-------|------|----------|
| 🧠 **PM Agent** — Orchestrator | 唯一入口，接收需求，分析拆解，决定调度哪些 Agent、按什么顺序执行，最后汇总结果回复你 | `claude-opus-4-6` |
| 🏗️ **Architect Agent** | 收到 PM 的任务后，产出技术方案：模块划分、接口定义、数据库 Schema、技术选型建议。后续各开发 Agent 以它的输出为输入，避免各自为战 | `claude-opus-4-6` |
| ⚙️ **Backend Agent** | Java/Spring Boot 开发，实现 API、Service、Repository 层，参考 Architect 产出的接口规范 | `claude-sonnet-4-6` |
| 🎨 **Frontend Agent** | React/Vue 开发，实现页面和组件，对接 Backend 定义的接口文档 | `claude-sonnet-4-6` |
| ✅ **QA Agent** | 根据需求文档和代码，编写测试用例、单元测试、接口测试脚本，验证功能正确性 | `claude-sonnet-4-6` |
| 🔍 **Reviewer Agent** | 对所有 Agent 产出的代码做统一审查：规范性、安全性、性能问题、潜在 Bug，给出修改建议 | `claude-sonnet-4-6` |

### 🟡 按需启动（偶尔需要）

| Agent | 职责 | 推荐模型 |
|-------|------|----------|
| 📱 **Mobile Agent** | React Native 或原生 iOS/Android 开发，只在有移动端需求时被 PM 调度 | `claude-sonnet-4-6` |
| 🗄️ **DBA Agent** | 复杂数据库设计、慢查询优化、数据迁移脚本，简单需求直接由 Backend Agent 兼任即可 | `claude-haiku-4-5` |
| 🚀 **DevOps Agent** | 生成 CI/CD 配置、Dockerfile、K8s 部署文件，发版时才需要 | `claude-haiku-4-5` |
| 📝 **Doc Agent** | 生成接口文档（OpenAPI/Swagger）、技术说明，可以由 Reviewer 兼任或单独设立 | `claude-haiku-4-5` |

---

## 🧩 模型分配建议

| 文件 | 核心设计要点 |
|------|-------------|
| `pm-SOUL.md` | 🌳 流程决策树 + 调度逻辑 + 失败处理 |
| `architect-SOUL.md` | 📐 DESIGN.md 结构规范（DDL/接口定义/任务建议） |
| `backend-SOUL.md` | ☕ Java 包结构规范 + 代码禁止事项 + 自检清单 |
| `frontend-SOUL.md` | 🌐 Axios 封装规范 + token 管理 + 组件规范 |
| `mobile-SOUL.md` | 📲 SecureStore 存储规范 + 导航栈切换逻辑 |
| `qa-SOUL.md` | 🧪 测试用例格式 + 通用必测场景清单 |
| `reviewer-SOUL.md` | 🔎 代码审查维度 + 安全审计模式 + 问题分级 |
| `dba-SOUL.md` | 🗄️ DDL 规范 + 慢查询分析步骤 + 迁移脚本规范 |
| `devops-SOUL.md` | 🐳 多阶段 Dockerfile + docker-compose + CI/CD |
| `doc-SOUL.md` | 📄 OpenAPI 3.0 格式 + README 模板 |


---

## 🔄 完整工作流

```
你（发需求）
    ↓
┌─────────────────────────┐
│  🧠 PM Agent            │  ← 拆解任务，制定执行计划
└─────────────────────────┘
    ↓
┌─────────────────────────┐
│  🏗️ Architect Agent    │  ← 产出技术方案文档
└─────────────────────────┘
    ↓ 并行执行
┌──────────┐  ┌──────────┐  ┌──────────┐
│ ⚙️       │  │ 🎨       │  │ 📱       │
│ Backend  │  │ Frontend │  │ Mobile   │
│ (按需)   │  │          │  │ (按需)   │
└──────────┘  └──────────┘  └──────────┘
    ↓ 并行完成后
┌─────────────────────────┐
│  ✅ QA Agent            │  ← 编写并执行测试
└─────────────────────────┘
    ↓
┌─────────────────────────┐
│  🔍 Reviewer Agent      │  ← 代码审查，输出修改意见
└─────────────────────────┘
    ↓
┌─────────────────────────┐
│  🧠 PM Agent            │  ← 汇总所有结果回复你
└─────────────────────────┘
```

---

## 📁 文件说明

| 文件 | 职责 | 是否必须 |
|--|--|--|
| `SOUL.md` | 🧬 人格、语气、行为边界。每次 session 都加载 | ⭐ 核心 |
| `AGENTS.md` | 📜 操作规程：如何使用记忆、安全规则、何时主动发言。每次 session 都加载 | ⭐ 核心 |
| `IDENTITY.md` | 🎭 Agent 的名字、风格、emoji。通常由 bootstrap 自动生成 | ⭐ 核心 |
| `USER.md` | 👤 使用者是谁、如何称呼、沟通偏好。每次 session 都加载 | ⭐ 核心 |
| `TOOLS.md` | 🛠️ 本地工具的使用约定和注意事项（不控制权限，只是指导） | 💡 建议配置 |
| `HEARTBEAT.md` | 💓 心跳任务的检查清单，保持简短避免 token 浪费 | 🔶 按需 |
| `BOOT.md` | 🚪 Gateway 重启时执行的启动检查清单 | 🔶 按需 |
| `memory/` | 🧠 跨 session 的长期记忆目录 | 🔄 自动生成 |

---

## 🚀 部署指南

### 第一步：创建 Agent 工作目录 + 放置 SOUL.md

#### 1.1 创建所有 Agent 的 workspace

```bash
mkdir -p ~/.openclaw/workspace-pm
mkdir -p ~/.openclaw/workspace-architect
mkdir -p ~/.openclaw/workspace-backend
mkdir -p ~/.openclaw/workspace-frontend
mkdir -p ~/.openclaw/workspace-mobile
mkdir -p ~/.openclaw/workspace-qa
mkdir -p ~/.openclaw/workspace-reviewer
mkdir -p ~/.openclaw/workspace-dba
mkdir -p ~/.openclaw/workspace-devops
mkdir -p ~/.openclaw/workspace-doc
```

#### 1.2 将 SOUL.md 放入对应目录（文件名必须是 `SOUL.md`）

```bash
cp pm-SOUL.md        ~/.openclaw/workspace-pm/SOUL.md
cp architect-SOUL.md ~/.openclaw/workspace-architect/SOUL.md
cp backend-SOUL.md   ~/.openclaw/workspace-backend/SOUL.md
cp frontend-SOUL.md  ~/.openclaw/workspace-frontend/SOUL.md
cp mobile-SOUL.md    ~/.openclaw/workspace-mobile/SOUL.md
cp qa-SOUL.md        ~/.openclaw/workspace-qa/SOUL.md
cp reviewer-SOUL.md  ~/.openclaw/workspace-reviewer/SOUL.md
cp dba-SOUL.md       ~/.openclaw/workspace-dba/SOUL.md
cp devops-SOUL.md    ~/.openclaw/workspace-devops/SOUL.md
cp doc-SOUL.md       ~/.openclaw/workspace-doc/SOUL.md
```

### 第二步：配置 `openclaw.json`

```jsonc
{
  "agents": {
    "defaults": {
      "model": "claude-sonnet-4-6",
      "subagents": {
        "model": "claude-sonnet-4-6",
        "runTimeoutSeconds": 600
      }
    },
    "list": [
      {
        "id": "pm",
        "workspace": "~/.openclaw/workspace-pm",
        "model": "claude-opus-4-6"
      },
      {
        "id": "architect",
        "workspace": "~/.openclaw/workspace-architect",
        "model": "claude-opus-4-6"
      },
      {
        "id": "backend",
        "workspace": "~/.openclaw/workspace-backend",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "frontend",
        "workspace": "~/.openclaw/workspace-frontend",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "mobile",
        "workspace": "~/.openclaw/workspace-mobile",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "qa",
        "workspace": "~/.openclaw/workspace-qa",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "reviewer",
        "workspace": "~/.openclaw/workspace-reviewer",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "dba",
        "workspace": "~/.openclaw/workspace-dba",
        "model": "claude-haiku-4-5"
      },
      {
        "id": "devops",
        "workspace": "~/.openclaw/workspace-devops",
        "model": "claude-haiku-4-5"
      },
      {
        "id": "doc",
        "workspace": "~/.openclaw/workspace-doc",
        "model": "claude-haiku-4-5"
      }
    ]
  },
  "bindings": [
    { "agentId": "pm", "match": { "channel": "telegram" } }
  ]
}
```

### 第三步：重启 OpenClaw + 验证配置

#### 3.1 重启 Gateway

```bash
openclaw restart
```

#### 3.2 验证 Agent 列表

```bash
openclaw agents list
```

#### 3.3 验证 SOUL.md 是否加载

```bash
openclaw agent --agent pm --message "你好，请介绍一下你的职责"
```

---

## 🧪 冒烟测试（从简单场景开始）

### 测试 1：文档生成（最简单，单 Agent）

> **发给 PM：** 帮我给 `src/main/java/com/example/controller/UserController.java` 生成接口文档

**预期结果：** PM 直接 spawn doc agent，返回文档，全程只有 **2 个 Agent** 参与。

---

### 测试 2：Bug 修复（中等复杂度）

> **发给 PM：** 用户登录接口报错，传入正确的用户名密码返回 500，错误信息是 `NullPointerException at UserServiceImpl.java:45`

**预期结果：** PM 拆解 → spawn backend 定位根因 → spawn backend 修复 → spawn qa 验证 → spawn reviewer 审查。

---

### 测试 3：新功能开发（完整链路，最后测）

> **发给 PM：** 开发一个用户登录功能，支持用户名密码登录，登录成功返回 JWT token，前后端都要实现

**预期结果：** 走完完整 **8 步流程**。

---

## ⚠️ 常见问题

| 问题 | 排查方式 |
|--|--|
| 🤷 Sub-agent 没有响应 | `/subagents list` 查看是否 spawn 成功 |
| ❌ SOUL.md 没有生效 | 检查文件名是否正确（必须是 `SOUL.md`，区分大小写） |
| 📊 STATUS 状态没有写入 | 检查各 Agent workspace 下对应的输出文件 |
| ⏰ Sub-agent 超时 | 调大 `runTimeoutSeconds`，或拆解任务粒度 |
| 🎯 PM 没有调度正确的 Agent | 检查 PM 的 `SOUL.md` 关键词识别部分，补充更多触发词 |


# 部署 Agent

## 创建 Agent 工作目录 + 放置 SOUL.md

### 创建所有 agent 的 workspace

```bash
mkdir -p ~/.openclaw/workspace-pm
mkdir -p ~/.openclaw/workspace-architect
mkdir -p ~/.openclaw/workspace-backend
mkdir -p ~/.openclaw/workspace-frontend
mkdir -p ~/.openclaw/workspace-mobile
mkdir -p ~/.openclaw/workspace-qa
mkdir -p ~/.openclaw/workspace-reviewer
mkdir -p ~/.openclaw/workspace-dba
mkdir -p ~/.openclaw/workspace-devops
mkdir -p ~/.openclaw/workspace-doc
```

### 将 SOUL.md 放入对应目录（文件名必须是 SOUL.md）

```bash
cp pm-SOUL.md       ~/.openclaw/workspace-pm/SOUL.md
cp architect-SOUL.md ~/.openclaw/workspace-architect/SOUL.md
cp backend-SOUL.md  ~/.openclaw/workspace-backend/SOUL.md
cp frontend-SOUL.md ~/.openclaw/workspace-frontend/SOUL.md
cp mobile-SOUL.md   ~/.openclaw/workspace-mobile/SOUL.md
cp qa-SOUL.md       ~/.openclaw/workspace-qa/SOUL.md
cp reviewer-SOUL.md ~/.openclaw/workspace-reviewer/SOUL.md
cp dba-SOUL.md      ~/.openclaw/workspace-dba/SOUL.md
cp devops-SOUL.md   ~/.openclaw/workspace-devops/SOUL.md
cp doc-SOUL.md      ~/.openclaw/workspace-doc/SOUL.md
```

## 配置 openclaw.json

```jsonc
{
  "agents": {
    "defaults": {
      "model": "claude-sonnet-4-6",
      "subagents": {
        "model": "claude-sonnet-4-6",
        "runTimeoutSeconds": 600
      }
    },
    "list": [
      {
        "id": "pm",
        "workspace": "~/.openclaw/workspace-pm",
        "model": "claude-opus-4-6"
      },
      {
        "id": "architect",
        "workspace": "~/.openclaw/workspace-architect",
        "model": "claude-opus-4-6"
      },
      {
        "id": "backend",
        "workspace": "~/.openclaw/workspace-backend",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "frontend",
        "workspace": "~/.openclaw/workspace-frontend",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "mobile",
        "workspace": "~/.openclaw/workspace-mobile",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "qa",
        "workspace": "~/.openclaw/workspace-qa",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "reviewer",
        "workspace": "~/.openclaw/workspace-reviewer",
        "model": "claude-sonnet-4-6"
      },
      {
        "id": "dba",
        "workspace": "~/.openclaw/workspace-dba",
        "model": "claude-haiku-4-5"
      },
      {
        "id": "devops",
        "workspace": "~/.openclaw/workspace-devops",
        "model": "claude-haiku-4-5"
      },
      {
        "id": "doc",
        "workspace": "~/.openclaw/workspace-doc",
        "model": "claude-haiku-4-5"
      }
    ]
  },
  "bindings": [
    { "agentId": "pm", "match": { "channel": "telegram" } }
  ]
}
```

## 重启 OpenClaw + 验证配置

### 重启 gateway
```bash
openclaw restart
```

### 验证 agent 列表
```bash
openclaw agents list
```

### 验证 SOUL.md 是否加载（随便问 pm agent 一句）
```bash
openclaw agent --agent pm --message "你好，请介绍一下你的职责"
```

## 冒烟测试（从简单场景开始）

### 测试 1：文档生成（最简单，单 agent）
发给 PM：帮我给 src/main/java/com/example/controller/UserController.java 生成接口文档
预期：PM 直接 spawn doc agent，返回文档，全程只有 2 个 agent 参与。

### 测试 2：Bug 修复（中等复杂度）
发给 PM：用户登录接口报错，传入正确的用户名密码返回 500，错误信息是 NullPointerException at UserServiceImpl.java:45
预期：PM 拆解 → spawn backend 定位根因 → spawn backend 修复 → spawn qa 验证 → spawn reviewer 审查。

### 测试 3：新功能开发（完整链路，最后测）
发给 PM：开发一个用户登录功能，支持用户名密码登录，登录成功返回 JWT token，前后端都要实现
预期：走完完整 8 步流程。

## 可能遇到的问题
| 问题 | 排查方式 |
|-------------------|-----------------------------------------------|
| Sub-agent 没有响应 | /subagents list 查看是否 spawn 成功 |
| SOUL.md 没有生效检 | 查文件名是否正确（必须是 SOUL.md，区分大小写） |
| STATUS 状态没有写入 | 检查各 agent workspace 下对应的输出文件 |
| Sub-agent 超时 | 调大 runTimeoutSeconds，或拆解任务粒度 |
| PM 没有调度正确的 agent | 检查 PM 的 SOUL.md 关键词识别部分，补充更多触发词 |
