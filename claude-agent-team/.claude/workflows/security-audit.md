# 工作流：安全加固 / 代码审计（Security Audit）

> security-agent 是主角，开发 Agent 是配合角色。

---

## 完整流程

```
安全需求触发
   │
   ▼
Step 1: pm-agent
   ├── 明确审计范围（全量 / 指定模块）
   └── → 调用 security-agent（主角）

Step 2: security-agent（全量扫描）
   ├── OWASP Top 10 检查
   ├── 依赖漏洞扫描（pom.xml / package.json CVE）
   ├── 敏感信息泄露检查
   ├── 问题分级（Critical / High / Medium / Low）
   └── 输出：安全审计报告

Step 3: pm-agent
   ├── 按问题归属分发（backend / frontend）
   ├── 优先处理 Critical → High → Medium
   └── 通知对应 Agent 开始修复

Step 4: [开发 Agents] 修复
   ├── backend-agent：修复后端安全问题
   └── frontend-agent：修复前端安全问题

Step 5: security-agent（复查）
   ├── 验证 Critical 和 High 问题是否真正修复
   └── 输出：复查报告

Step 6: reviewer-agent
   ├── 最终代码质量确认
   └── 输出：Review 结论
```

---

## 关键约束

```
1. security-agent 是主角，先扫描再分发，不能直接让开发 Agent 自查
2. Critical 问题必须在当前版本修复，可阻塞发布
3. 修复后必须由 security-agent 复查（不能只靠 reviewer-agent）
4. pm-agent 按优先级分批派发，Critical 优先
```

---

---
