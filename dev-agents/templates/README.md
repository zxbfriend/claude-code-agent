# templates/README.md

本目录统一存放 `dev-agents` 的全部输入、输出与交接模板。

说明：只有文件名以 `-template.md` 结尾的文件属于可填写模板，`README.md` 仅为说明文件。

## 命名规则

1. 模板文件统一使用小写字母 + 短横线命名
2. 模板文件名最后一个单词统一为 `template`
3. 命名示例：`task-dispatch-template.md`

## 模板清单

1. `task-dispatch-template.md`：`ProjectManager` 下发任务模板
2. `final-report-template.md`：最终汇总模板
3. `prd-template.md`：需求文档模板
4. `api-template.md`：接口设计模板
5. `requirements-analyst-template.md`：需求分析报告模板
6. `frontend-developer-template.md`：前端开发报告模板
7. `backend-developer-template.md`：后端开发报告模板
8. `code-reviewer-template.md`：代码审查报告模板
9. `qa-engineer-template.md`：测试报告模板
10. `handoff-template.md`：交接模板
11. `decision-template.md`：重要决策记录模板

## 使用原则

1. 所有角色优先从 `D:\Github\openclaw\dev-agents\templates` 读取模板
2. `D:\Github\openclaw\dev-agents\docs`、`D:\Github\openclaw\dev-agents\reports`、`D:\Github\openclaw\dev-agents\handoff` 主要用于存放实例产物
3. 具体角色模板使用关系见 `D:\Github\openclaw\dev-agents\shared\agent-template-map.md`
4. 涉及架构、流程、范围、质量门禁或发布取舍的重大决策，使用 `D:\Github\openclaw\dev-agents\templates\decision-template.md`
