## 一、如何配置
### 1.启用 agent team 功能
修改 settings.json 

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```
### 2.将CLAUDE.md 和 .claude 目录添加到项目根目录

## 二、如何使用
### 多智能体协作推荐的触发语：

请按照项目的 Agent Team 配置处理以下任务，先用 pm-agent 分析，再按流程调用对应 Agent：[你的需求描述]

## 三、如何在老项目中复用：

根据下面的提示词发个ai，让他帮你修改

```
请完整阅读 D:\Github\zhixianweilai\yaoming_shengwu 项目源码，系统梳理并提取以下八类关键信息，逐项补充到 claude-agent-team 配置描述中，确保内容准确、格式统一、可维护：

1. 项目结构  
   以树状层级列出源码根目录下的所有一级与二级目录，标注各目录的职能（如：config、src、tests、docs、scripts、public、build 等），并说明关键配置文件（package.json、pom.xml、Dockerfile、.env.* 等）的位置与作用。

2. 后端技术栈  
   明确后端使用的编程语言与版本（如 Java 17、Node.js 18、Python 3.11）、核心框架（Spring Boot 3.x、Express 4.x、Django 4.x）、持久层方案（JPA/MyBatis、TypeORM、SQLAlchemy）、消息队列（Kafka/RabbitMQ）、缓存（Redis/Memcached）、API 网关、注册中心、安全框架（Spring Security、JWT、OAuth2）、单元测试框架（JUnit 5、PyTest、Mocha）以及依赖管理工具（Maven、Gradle、npm、pip）。

3. 前端技术栈  
   明确前端使用的运行时与版本（Node.js 18）、框架（React 18、Vue 3、Angular 15）、状态管理（Redux Toolkit、Pinia、NgRx）、路由（React Router 6、Vue Router 4）、构建工具（Vite 4、Webpack 5）、UI 组件库（Ant Design Vue、Element Plus、Material-UI）、CSS 方案（Sass、Less、Tailwind、CSS Modules）、单元测试（Jest、Vitest、React Testing Library）、E2E 测试（Cypress、Playwright）以及包管理器（npm、pnpm、yarn）。

4. 后端包结构  
   给出后端源码目录的完整包名约定（如 com.xxx.xxx.{controller|service|repository|config|common|dto|vo|entity|mapper|rpc|mq|scheduler|security}），说明各包职责、分层规范、领域模块划分方式，以及禁止循环依赖的检测规则。

5. 后端编码规范  
   列出命名规范（类名、方法名、常量、枚举、DTO/VO 后缀）、日志规范（SLF4J + Logback，统一使用占位符）、异常规范（自定义 BusinessException、全局 @RestControllerAdvice 统一返回 Result<T>）、RESTful URL 设计、事务边界、幂等实现、数据库字段命名（lower_snake_case）、日期时间格式（ISO 8601）、魔法值禁用、静态代码扫描（SpotBugs、PMD、Checkstyle）阈值、单元测试覆盖率（≥80%）与集成测试策略。

6. 前端编码规范  
   列出文件与目录命名（kebab-case）、组件命名（PascalCase）、组合式 API 优先、Props 类型显式声明、emits 声明、v-for 必须带 key、样式作用域（scoped 或 CSS Modules）、ESLint + Prettier 统一配置、Git 提交消息格式（feat/fix/docs/style/refactor/test/chore）、代码注释比率（≥15%）、单文件行数上限（≤300）、单元测试覆盖率（≥70%）、性能指标（Lighthouse Performance ≥ 85）以及构建产物体积监控（entry point ≤ 250 KB）。

7. 常用命令  
   分别给出后端与前端在开发、测试、构建、部署阶段的常用命令示例，包括：  
   - 本地启动（如 mvn spring-boot:run、npm run dev）  
   - 单元测试（mvn test、npm run test:unit）  
   - 代码格式化与静态检查（mvn spotless:apply、npm run lint:fix）  
   - 打包（mvn clean package、npm run build）  
   - Docker 镜像构建（docker build -t xxx .）  
   - Kubernetes 部署（kubectl apply -f k8s/）  
   并说明各命令的预期输出与常见排错步骤。

8. 工具速查  
   提供开发和运维高频使用的一行式速查表，包括：  
   - 端口占用查询（lsof -i :8080）  
   - 实时日志（tail -f xxx.log | grep ERROR）  
   - 数据库连接测试（mysql -h… -u… -p… -e “SELECT 1”）  
   - Redis 性能测试（redis-benchmark -c 50 -n 100000）  
   - 前端包依赖树（npm ls –depth=0）  
   - 安全漏洞扫描（npm audit、mvn dependency-check:check）  
   - 镜像体积分析（dive xxx:latest）  
   每项给出命令、示例输出片段与结果判读标准。

最终交付：将上述八项内容按顺序整理成 Markdown 表格或 YAML 片段，直接追加写入 claude-agent-team 配置描述文件，确保后续 Agent 可一键读取并准确理解项目上下文。
```