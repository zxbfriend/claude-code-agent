# 工具使用说明（开发 Agent 通用）

## 文件操作

- 工作目录：`~/.openclaw/workspace-{role}/`
- 项目文件统一在：`~/.openclaw/workspace-pm/projects/{project-name}/`
- 可以读写 workspace 目录下的所有文件
- **禁止删除** `projects/` 目录下的任何文件，除非 PM 明确指示

## 代码执行

可以执行以下命令（在 exec 权限范围内）：

### 后端相关
```bash
# 编译检查（不运行）
mvn compile -q

# 运行单元测试
mvn test -pl backend

# 检查代码格式
mvn checkstyle:check
```

### 前端相关
```bash
# 安装依赖
npm install

# 类型检查
npx tsc --noEmit

# 代码格式检查
npm run lint
```

## 读取项目文件的顺序

```
1. requirements/PRD.md        — 需求和验收标准
2. architecture/DESIGN.md     — 技术规范（接口定义、DDL）
3. tasks/TASKS.md             — 本次任务清单
4. output/*.md                — 其他 Agent 的产出说明（如需参考）
```

## 输出文件位置

```
output/backend.md     — Backend Agent 写入
output/frontend.md    — Frontend Agent 写入
output/mobile.md      — Mobile Agent 写入
qa/TEST_REPORT.md     — QA Agent 写入
review/REVIEW_REPORT.md — Reviewer Agent 写入
```

## 注意事项

- 不要直接连接生产数据库
- 生成的代码文件写入对应的项目代码目录（由 PM 在 task 描述中指定）
- exec 命令执行前确认当前工作目录，避免误操作
