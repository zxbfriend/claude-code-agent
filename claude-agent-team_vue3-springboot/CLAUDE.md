# 项目全局上下文（CLAUDE.md）

> 所有 Agent 启动前必读。本文件是整个 Agent Team 的"宪法"，定义了项目基础信息、技术约束、协作规范。

---

## 1. 项目结构
| 目录/文件 | 职能描述 | 关键配置文件 |
| :--- | :--- | :--- |
| `futurefab-admin` | 后端主模块，包含 Web 接口与启动配置 | `application.yml`, `logback.xml` |
| `futurefab-common` | 后端通用模块，核心注解、基础实体与工具类 | `pom.xml` |
| `futurefab-framework` | 后端框架模块，权限校验、多数据源与 MyBatis 配置 | `SecurityConfig.java`, `DruidConfig.java` |
| `futurefab-generator` | 代码生成器模块，使用 Velocity 模板 | `velocity.properties` |
| `futurefab-quartz` | 定时任务框架模块 | `pom.xml` |
| `futurefab-system` | 系统管理业务模块（用户、角色、菜单等） | `SysUserMapper.xml` |
| `futurefab-ui` | 前端 Vue 3 工程 | `package.json`, `vite.config.ts`, `.env.*` |
| `sql` | 数据库脚本目录 | `20260417.sql`, `quartz.sql` |
| `pom.xml` | Maven 父项目配置文件，定义全局依赖与模块 | - |

---

## 2. 后端技术栈
| 技术维度 | 选型与版本 | 备注 |
| :--- | :--- | :--- |
| 编程语言 | Java 17 | - |
| 核心框架 | Spring Boot 4.x | - |
| 持久层 | MyBatis (mybatis-spring-boot-starter 4.0.1) | 配合 PageHelper 2.1.1 |
| 数据库连接池 | Druid 1.2.28 | 支持多数据源动态切换 |
| 安全框架 | Spring Security + JWT (jjwt 0.9.1) | 包含验证码 Kaptcha 2.3.3 |
| 缓存方案 | Redis | 使用 Fastjson2 2.0.61 序列化 |
| 数据库 | MySQL 8.0 |
| API 文档 | SpringDoc OpenAPI 3.0.2 | Swagger 替代方案 |
| 工具库 | Apache POI, Velocity, OSHI | 处理 Excel, 代码生成, 系统监控 |
| 依赖管理 | Maven 3.x | - |

---

## 3. 前端技术栈
| 技术维度 | 选型与版本 | 备注 |
| :--- | :--- | :--- |
| 框架 | Vue 3.5.26 | Composition API, `<script setup>` |
| 状态管理 | Pinia 3.0.4 | - |
| 路由 | Vue Router 4.6.4 | 支持动态路由 |
| 构建工具 | Vite 6.4.1 | - |
| UI 组件库 | Element Plus 2.13.1 | - |
| CSS 方案 | Sass (sass-embedded 1.97.2) | - |
| 网络请求 | Axios 1.13.2 | - |
| 工具库 | VueUse, ECharts, js-cookie | - |
| 包管理器 | npm / pnpm | - |

---

## 4. 后端包结构
| 包名路径 | 职能职责 | 规范建议 |
| :--- | :--- | :--- |
| `com.futurefab.web.controller` | REST API 控制器 | 仅处理请求转发与参数校验 |
| `com.futurefab.system.service` | 业务逻辑接口 | 接口以 `I` 开头，如 `ISysUserService` |
| `com.futurefab.system.service.impl` | 业务逻辑实现 | 包含具体业务逻辑处理 |
| `com.futurefab.system.mapper` | MyBatis Mapper 接口 | 对应 `mapper.xml` 中的 SQL |
| `com.futurefab.system.domain` | 数据库实体类 | 对应数据库表结构 |
| `com.futurefab.system.domain.vo` | 视图对象类 | 用于前端展示的数据封装 |
| `com.futurefab.common.core.domain` | 通用响应与实体 | 如 `AjaxResult`, `BaseEntity`, `R` |
| `com.futurefab.common.utils` | 核心工具包 | 包含 String, Date, Security 等工具 |

---

## 5. 后端编码规范
| 规范项 | 具体要求 | 备注 |
| :--- | :--- | :--- |
| 命名规范 | 类名 UpperCamelCase, 方法/变量 lowerCamelCase | 常量 UPPER_SNAKE_CASE |
| 日志规范 | SLF4J + Logback | 统一使用占位符，严禁 System.out |
| 异常规范 | 自定义 ServiceException | 全局 @RestControllerAdvice 统一返回 AjaxResult |
| URL 设计 | RESTful 风格 | 如 `/system/user/{userId}` |
| 数据库字段 | lower_snake_case | 映射到实体类驼峰命名 |
| 魔法值 | 严禁使用魔法值 | 必须定义在 Constants 或 Enums 中 |
| 测试覆盖率 | 单元测试覆盖率 ≥ 80% | 集成测试覆盖核心业务流 |

---

## 6. 前端编码规范
| 规范项 | 具体要求 | 备注 |
| :--- | :--- | :--- |
| 目录/文件 | kebab-case | 如 `user-profile/index.vue` |
| 组件命名 | PascalCase | 在模板中使用 kebab-case |
| API 优先 | 优先使用 Composition API | 统一使用 `<script setup>` |
| Props/Emits | 必须显式声明类型 | `defineProps`, `defineEmits` |
| 样式作用域 | 必须使用 scoped | 避免全局样式冲突 |
| 提交规范 | feat/fix/docs/style/refactor/test/chore | Git 提交消息格式 |
| 文件限制 | 单文件行数 ≤ 300 | 逻辑复杂时需拆分组件 |
| 覆盖率 | 单元测试覆盖率 ≥ 70% | - |

---

## 7. 常用命令
| 阶段 | 后端命令 (Maven) | 前端命令 (npm/Vite) |
| :--- | :--- | :--- |
| 本地启动 | `mvn spring-boot:run -pl futurefab-admin` | `npm run dev` |
| 单元测试 | `mvn test` | `npm run test:unit` |
| 格式化/检查 | `mvn spotless:apply` | `npm run lint:fix` |
| 项目打包 | `mvn clean package` | `npm run build:prod` |
| 镜像构建 | `docker build -t futurefab-admin .` | - |
| 部署发布 | `kubectl apply -f k8s/` | - |

---

## 8. 工具速查
| 功能 | 命令示例 | 结果判读 |
| :--- | :--- | :--- |
| 端口占用 | `lsof -i :8080` | 查看 PID 与进程名称 |
| 实时日志 | `tail -f logs/sys-info.log \| grep ERROR` | 监控异常输出 |
| 数据库连接 | `mysql -h localhost -u root -p -e "SELECT 1"` | 输出 1 表示连接成功 |
| Redis 测试 | `redis-cli ping` | 返回 PONG 表示正常 |
| 前端依赖树 | `npm ls --depth=0` | 查看顶层包版本 |
| 安全扫描 | `npm audit` / `mvn dependency-check:check` | 查看已知漏洞 |
| 镜像分析 | `dive futurefab-admin:latest` | 分析层大小与效率 |

---

## Agent 协作规范

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
