# 工作流：文档补全（Documentation）

> 最简单的流程，单 Agent 即可完成。

---

## 完整流程

```
文档需求
   │
   ▼
Step 1: pm-agent
   ├── 明确文档类型和范围
   └── → 直接调用 doc-agent

Step 2: doc-agent
   ├── 读取代码、接口规格、已有文档
   ├── 按需生成：
   │     ├── 接口文档（Markdown / OpenAPI YAML）
   │     ├── README / 部署文档
   │     └── CHANGELOG
   └── 输出：文档文件

Step 3: pm-agent
   └── 确认文档内容准确，标记完成
```

---

## 关键约束

```
1. 文档内容必须与代码实现一致，不能凭空编写
2. 不确定的接口行为必须标注"待确认"
3. 文档补全通常不需要 reviewer-agent 介入（除非是对外发布的正式文档）
```
