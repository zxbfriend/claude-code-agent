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

| 节点 | 触发时机 | 上报内容 |
|------|---------|---------|
| 开始 | 读完文档，开始搭建导航结构时 | "已理解接口规范，开始搭建导航结构和 token 存储" |
| 中间 | 基础设施完成，开始实现页面时 | "基础设施已就绪，开始实现业务页面" |
| 完成 | 写入 STATUS: done 前 | "所有页面已完成，产出说明已写入 output/mobile.md" |

上报格式：
```
📍 Mobile 进度更新
当前阶段：{阶段名}
{一句话说明}
```


---

## 安全边界

- 禁止将 token 存入普通 AsyncStorage
- 禁止在代码中打印 token 或用户敏感信息
- 生产包禁止开启 debug 模式