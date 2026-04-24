# 技术规格文档模板（Tech Spec）

> 由 architect-agent 输出，是所有开发 Agent 的实现依据。  
> 一旦确定，不得随意变更；如需变更，必须重新通过 pm-agent 评估影响。

---

## 文档信息

**文档版本**：v1.0
**关联任务**：{TASK-ID}
**创建时间**：{YYYY-MM-DD}
**作者**：architect-agent

---

## 1. 背景与目标

{简述这个功能/方案要解决的问题，以及设计目标。}

---

## 2. 系统架构

### 2.1 模块关系

```
{用文字或 Mermaid 图描述模块间的关系}

graph LR
    A[Client] -->|HTTP| B[Controller]
    B --> C[Service]
    C --> D[Repository]
    C --> E[Redis Cache]
    D --> F[(MySQL)]
```

### 2.2 核心流程

```
{描述核心业务流程}

1. 用户发起请求 → Controller 接收并校验参数
2. Controller 调用 Service
3. Service 检查 Redis 缓存
4. 缓存未命中 → 查询数据库
5. 写入缓存 → 返回结果
```

---

## 3. 接口设计

### 3.1 接口列表

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| POST | /api/v1/{resource} | {描述} | 是/否 |
| GET | /api/v1/{resource}/{id} | {描述} | 是/否 |

### 3.2 接口详情

#### {接口名称}

- **HTTP 方法**：POST / GET / PUT / DELETE
- **路径**：`/api/v1/{resource}`
- **描述**：{接口功能描述}
- **认证**：需要 Bearer Token / 不需要

**请求参数**

| 字段 | 类型 | 必填 | 校验规则 | 说明 |
|------|------|------|---------|------|
| fieldName | String | 是 | 长度 1-50 | 字段说明 |
| pageNo | Integer | 否 | 默认 1，最大 100 | 页码 |

**响应参数**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 资源 ID |
| name | String | 名称 |
| createdAt | Long | 创建时间戳（毫秒）|

**业务错误码**

| 错误码 | HTTP 状态码 | 说明 | 触发场景 |
|--------|-----------|------|---------|
| 10001 | 400 | {错误描述} | {触发条件} |
| 10002 | 400 | {错误描述} | {触发条件} |

**请求示例**

```json
{
  "fieldName": "value"
}
```

**响应示例（成功）**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "name": "example"
  }
}
```

**响应示例（失败）**

```json
{
  "code": 10001,
  "message": "错误描述",
  "data": null
}
```

---

## 4. 数据模型

### 4.1 实体关系

```
{ER 图或文字描述实体间关系}

User 1 --- N Order（一个用户有多个订单）
Order 1 --- N OrderItem（一个订单有多个商品）
```

### 4.2 数据库表设计

#### 表：{table_name}

**描述**：{表的用途说明}

| 字段名 | 数据类型 | 长度 | 可空 | 默认值 | 说明 |
|--------|---------|------|------|--------|------|
| id | BIGINT | - | 否 | AUTO_INCREMENT | 主键 |
| {field1} | VARCHAR | 64 | 否 | - | {说明} |
| {field2} | INT | - | 否 | 0 | {说明} |
| created_at | DATETIME | - | 否 | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | 否 | CURRENT_TIMESTAMP | 更新时间 |
| is_deleted | TINYINT | 1 | 否 | 0 | 逻辑删除 |

**索引设计**

| 索引名 | 字段 | 类型 | 说明 |
|--------|------|------|------|
| PRIMARY | id | 主键 | - |
| uk_{field} | {field} | UNIQUE | 唯一约束 |
| idx_{field1}_{field2} | {field1}, {field2} | NORMAL | 查询优化 |

---

## 5. 中间件使用

### Redis

| 用途 | Key 格式 | Value 类型 | TTL |
|------|---------|-----------|-----|
| {用途说明} | `{project}:{module}:{id}` | String / Hash | {时间} |

### 消息队列（如有）

| Topic | 生产者 | 消费者 | 说明 |
|-------|--------|--------|------|
| {topic} | {模块} | {模块} | {说明} |

---

## 6. 关键技术决策

| 决策项 | 选择 | 备选方案 | 选择原因 |
|--------|------|---------|---------|
| 失败计数 | Redis INCR + TTL | 数据库计数 | 避免频繁写库，TTL 自动清理 |
| 并发控制 | Redis 分布式锁 | 数据库乐观锁 | 减少数据库压力 |

---

## 7. 给开发 Agent 的指引

### backend-agent 注意事项

- {注意事项1}
- {注意事项2}

### frontend-agent 注意事项

- {注意事项1}
- {注意事项2}

### dba-agent 注意事项

- {注意事项1}

---

## 8. 变更记录

| 版本 | 时间 | 变更说明 | 影响的 Agent |
|------|------|---------|------------|
| v1.0 | {时间} | 初始版本 | - |
