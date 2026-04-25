# 项目全局上下文（CLAUDE.md）

> 所有 Agent 启动前必读。本文件是整个 Agent Team 的"宪法"，定义了项目基础信息、技术约束、协作规范。

---

## 项目简介

- **项目名称**：[YOUR_PROJECT_NAME]
- **核心功能**：[请填写项目核心业务描述]
- **当前版本**：v[X.X.X]
- **代码仓库**：[Git 仓库地址]

---

## 技术栈

| 层级 | 技术选型 |
|------|---------|
| 后端语言 | Java 17+ |
| 后端框架 | Spring Boot 3.x |
| ORM | MyBatis-Plus 3.x |
| 数据库 | MySQL 8.0 |
| 缓存 | Redis 7.x |
| 消息队列 | [RabbitMQ / Kafka，按需填写] |
| 前端框架 | [Vue / React，按需填写] |
| 构建工具 | Maven 3.x |
| 容器化 | Docker + Kubernetes |
| CI/CD | GitHub Actions / Jenkins |
| 数据库迁移 | Flyway |

---

## 项目目录结构

```
src/
├── main/
│   ├── java/com/{company}/{project}/
│   │   ├── controller/        # API 控制器层（对外接口）
│   │   ├── service/           # 业务逻辑层
│   │   │   └── impl/          # 接口实现
│   │   ├── repository/        # 数据访问层（Mapper 接口）
│   │   ├── model/
│   │   │   ├── entity/        # 数据库实体类
│   │   │   ├── dto/           # 请求数据传输对象
│   │   │   └── vo/            # 响应视图对象
│   │   ├── config/            # 配置类（Security、Redis、MQ等）
│   │   ├── exception/         # 全局异常处理
│   │   ├── util/              # 工具类
│   │   └── common/            # 公共常量、枚举、响应封装
│   └── resources/
│       ├── mapper/            # MyBatis XML SQL 文件
│       ├── db/migration/      # Flyway 数据库迁移脚本
│       └── application.yml    # 主配置文件
└── test/
    └── java/                  # 单元测试 / 集成测试
```

---

## 接口规范

### URL 格式
```
/api/v{版本号}/{资源名}/{操作}
```

**示例：**
- `GET    /api/v1/users`           # 用户列表
- `GET    /api/v1/users/{id}`      # 用户详情
- `POST   /api/v1/users`           # 创建用户
- `PUT    /api/v1/users/{id}`      # 更新用户
- `DELETE /api/v1/users/{id}`      # 删除用户

### 统一响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "timestamp": 1700000000000
}
```

### 错误码规范
| 错误码 | 含义 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未认证 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |
| 10001~ | 业务自定义错误码 |

---

## 代码规范

- 遵循 **Alibaba Java 开发手册（嵩山版）**
- 所有 public 方法必须有 Javadoc 注释
- 类名：UpperCamelCase；方法名/变量名：lowerCamelCase
- 常量：UPPER_SNAKE_CASE，定义在 `common/constants` 包下
- 禁止使用魔法值，必须定义常量或枚举
- 日志使用 SLF4J，禁止使用 `System.out.println`

---

## 关键约束（所有 Agent 必须遵守）

```
【协作流程 — 最高优先级】
A. 任何开发任务启动前，必须先通过 pm-agent 分析任务类型，pm-agent 是唯一入口
B. 禁止跳过 pm-agent 直接自行编码或调用其他 Agent
C. pm-agent 输出计划后，严格按计划中指定的 Agent 和顺序执行

1. 数据库 Schema 变更 → 必须通过 Flyway 迁移脚本执行，禁止手动 DDL
2. 敏感信息（密码/密钥/Token）→ 必须通过环境变量注入，禁止硬编码
3. 外部输入 → 必须做参数校验（@Valid + 自定义校验器）
4. 接口返回 → 必须使用统一响应封装，禁止裸返回
5. 数据库操作 → 禁止 SELECT *，必须按需查询字段
6. 日志打印 → 禁止打印密码、手机号明文，必须脱敏
7. 异常处理 → 禁止吞异常，必须记录日志或向上抛出
```

---

## Agent 协作规范

### 启动流程（强制）
1. **任何开发任务（新功能/Bug 修复/重构/需求变更/性能优化/安全加固/依赖升级/文档补全），必须先调用 `pm-agent`**
2. `pm-agent` 分析任务类型并输出计划
3. 按计划中指定的 Agent 和顺序执行
4. **禁止跳过 pm-agent 自行编码或调用其他 Agent**

### 调用规则
- **`pm-agent` 是唯一入口**，所有任务必须从 pm-agent 开始
- Agent 之间通过结构化 JSON 传递任务（格式见 `.claude/templates/task-list.md`）
- 每个 Agent 完成任务后，需更新任务状态并通知 pm-agent

### 任务类型与流程对应
| 任务类型 | 对应流程文件 |
|---------|------------|
| 新功能开发 | `.claude/workflows/new-feature.md` |
| Bug 修复 | `.claude/workflows/bug-fix.md` |
| 技术重构 | `.claude/workflows/refactor.md` |
| 需求变更 | `.claude/workflows/change-request.md` |
| 性能优化 | `.claude/workflows/performance.md` |
| 安全加固 | `.claude/workflows/security-audit.md` |
| 依赖升级 | `.claude/workflows/dependency-upgrade.md` |
| 文档补全 | `.claude/workflows/documentation.md` |

### 输出物模板
所有 Agent 的输出物必须使用 `.claude/templates/` 下的对应模板。

---

## 环境信息

| 环境 | 用途 | 说明 |
|------|------|------|
| local | 本地开发 | 开发者自行配置 |
| dev | 开发联调 | 自动部署，每次提交触发 |
| staging | 测试验收 | QA 测试环境，手动触发部署 |
| prod | 生产环境 | 需 reviewer-agent + PM 双重确认 |
