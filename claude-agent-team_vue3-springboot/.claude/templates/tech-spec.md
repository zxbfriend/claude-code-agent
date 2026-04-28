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

| 方法 | 路径 | 描述 | 权限标识 |
|------|------|------|------|
| GET | /system/{resource}/list | 分页查询 | `{module}:{resource}:list` |
| GET | /system/{resource}/{id} | 详情查询 | `{module}:{resource}:query` |
| POST | /system/{resource}/add | 新增 | `{module}:{resource}:add` |
| PUT | /system/{resource}/edit | 修改 | `{module}:{resource}:edit` |
| DELETE | /system/{resource}/{id} | 删除 | `{module}:{resource}:remove` |

### 3.2 接口详情

#### {接口名称}

- **HTTP 方法**：POST / GET / PUT / DELETE
- **路径**：`/system/{resource}/{action}`
- **描述**：{接口功能描述}
- **权限标识**：`@PreAuthorize("@ss.hasPermi('{module}:{resource}:{action}')")`

**请求参数**

| 字段 | 类型 | 必填 | 校验规则 | 说明 |
|------|------|------|---------|------|
| fieldName | String | 是 | 长度 1-50 | 字段说明 |

**响应参数 (AjaxResult)**

| 字段 | 类型 | 说明 |
|------|------|------|
| code | Integer | 状态码 (200成功) |
| msg | String | 提示消息 |
| data | Object | 业务数据 |

**响应示例（成功）**

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "id": 1,
    "name": "example"
  }
}
```

---

## 4. 数据模型

### 4.2 数据库表设计

#### 表：{table_name}

**描述**：{表的用途说明}

| 字段名 | 数据类型 | 长度 | 可空 | 默认值 | 说明 |
|--------|---------|------|------|--------|------|
| id | BIGINT | 20 | 否 | AUTO_INCREMENT | 主键 |
| {field1} | VARCHAR | 64 | 否 | - | {说明} |
| create_by | VARCHAR | 64 | 是 | - | 创建者 |
| create_time | DATETIME | - | 是 | - | 创建时间 |
| update_by | VARCHAR | 64 | 是 | - | 更新者 |
| update_time | DATETIME | - | 是 | - | 更新时间 |
| remark | VARCHAR | 500 | 是 | - | 备注 |
| del_flag | CHAR | 1 | 否 | '0' | 删除标志（0代表存在 2代表删除） |

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
