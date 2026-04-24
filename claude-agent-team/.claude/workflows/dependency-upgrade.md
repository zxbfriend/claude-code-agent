# 工作流：第三方依赖升级（Dependency Upgrade）

> 链路简单，QA 回归是关键。

---

## 完整流程

```
升级需求
   │
   ▼
Step 1: pm-agent
   ├── 明确升级范围（后端/前端/全栈）
   └── → 派发开发 Agent

Step 2: [开发 Agents]
   ├── backend-agent：更新 pom.xml 版本，处理 Breaking Change
   └── frontend-agent：更新 package.json，处理兼容性问题

Step 3: qa-agent（全量回归）
   ├── 全量回归（升级可能引入兼容性问题）
   ├── 重点关注依赖包的 Breaking Change 影响项
   └── 输出：回归测试报告

Step 4: reviewer-agent
   ├── 检查是否有兼容性问题遗漏
   ├── 检查新版本是否引入新的 CVE
   └── 输出：Review 结论
```

---

## 关键约束

```
1. qa-agent 做全量回归（依赖升级影响面广，不能只做定向回归）
2. 如果依赖包升级涉及安全漏洞修复，同步通知 security-agent 验证
3. Major 版本升级（如 Spring Boot 2.x → 3.x）需要 architect-agent 评估影响
```

---

---
