# 操作规程（Mobile Agent）

## 基本原则

- DESIGN.md 是移动端接口对接的唯一依据
- token 等敏感信息必须用 SecureStore，禁止明文存储
- 同时考虑 iOS 和 Android 的差异，不能只测一个平台
- 不写超出 TASKS.md 范围的功能

---

## 任务接收规程

1. 依次读取：`requirements/PRD.md` → `architecture/DESIGN.md` → `tasks/TASKS.md`
2. 重点确认：认证方式、token 刷新逻辑、统一响应结构
3. 信息不足时，在 `output/mobile.md` 列出问题，STATUS 设为 `blocked`

---

## 开发流程

```
1. 确认或创建 HTTP 工具类（含 token 注入、401 处理）
2. 确认或创建 token 安全存储（SecureStore）
3. 确认或创建导航结构（认证栈 / 主应用栈切换）
4. 定义 TypeScript 接口类型
5. 封装 API 调用函数（src/api/*.ts）
6. 实现页面（Screen）
7. 平台差异处理（KeyboardAvoidingView / SafeAreaView 等）
```

---

## 代码自检清单

- [ ] token 使用 SecureStore 存储？
- [ ] 导航栈根据登录状态正确切换？
- [ ] 是否处理了无网络状态的提示？
- [ ] 键盘弹出是否遮挡输入框（KeyboardAvoidingView）？
- [ ] iOS 刘海屏 / Android 状态栏是否正常处理（SafeAreaView）？
- [ ] 是否有接口 loading 状态和防重复提交？

---

## 记忆管理

不需要维护长期记忆，每次任务独立执行。

---

## 阶段进度上报规程

**强制要求**：每完成下表中的一个节点，立即通过 message 工具发送进度消息。

上报格式：
```
📍 Mobile 进度更新
当前阶段：{阶段名}
已完成：{完成的内容}
下一步：{接下来要做什么}
```

上报节点（共 7 个）：

| # | 节点 | 触发时机 |
|---|------|---------|
| 1 | 任务启动 | 读完文档，确认接口规范，准备动手前 |
| 2 | 存储和 HTTP 完成 | SecureStore + Axios 封装完成后 |
| 3 | 导航结构完成 | 认证栈 / 主应用栈导航配置写完后 |
| 4 | API 封装完成 | src/api/ 下所有接口调用函数写完后 |
| 5 | 页面完成 | 所有 Screen 页面写完后 |
| 6 | 平台适配完成 | iOS/Android 差异处理完成后（SafeAreaView 等）|
| 7 | 任务结束 | 写入 STATUS: done 前 |

> 两次上报之间最大间隔不超过 5 分钟。


---

## 安全边界

- 禁止将 token 存入普通 AsyncStorage
- 禁止在代码中打印 token 或用户敏感信息
- 生产包禁止开启 debug 模式
