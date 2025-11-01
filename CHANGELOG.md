# Changelog


## [0.0.5] - 2025-11-01

### 🚀 Added
- 新增 **`setOnError(Function(String))` 回调事件**：可捕获推送初始化、注册、权限请求等过程中出现的异常，便于日志追踪与问题排查。  
- 新增 **`enableLog(bool enable)`** 接口：可动态开启或关闭原生日志输出，支持开发与生产环境灵活切换。  
- 在示例 `Example` 中新增完整演示：
  - 初始化推送服务：`initPush()`
  - 监听注册回调：`setOnRegId()`
  - 监听通知点击：`setOnClickNotification()`
  - 捕获错误信息：`setOnError()`
  - 调试日志演示：`enableLog(true)`

### ⚙️ Changed
- 优化插件初始化流程，确保所有回调注册与原生通信在 **主线程安全执行**。
- 重构日志系统：
  - 增加日志分级（Info / Warn / Error）
  - 优化输出格式与时间戳显示。
- 更新文档说明，新增回调时序说明图与集成建议。

### 🐛 Fixed
- 修复偶发的回调丢失问题（尤其是 `initPush()` 调用过早时）。
- 修复部分设备上 APNs token 未正确格式化的问题。
- 修复 iOS 17+ 首次安装后未自动触发通知权限弹窗的问题。


## [0.0.4] - 2025-11-01
### Added
- 新增 **`onRegId` 回调事件**，在设备成功注册 APNs 后自动触发，Flutter 端可实时获取 `regId`。
- 支持异步获取 `regId`：当调用 `getRegId()` 时尚未生成 Token，会等待系统注册完成后返回。
- 新增示例代码演示 `onRegId`、`onNotificationClick` 的监听方式。

### Changed
- 优化 `didRegisterForRemoteNotificationsWithDeviceToken` 逻辑，保证主线程安全调用。
- 重构状态管理，防止重复回调或空引用。
- 改进日志输出格式，使调试信息更易读。

### Fixed
- 修复 `initPush()` 早于 AppDelegate 初始化导致的 delegate 丢失问题。
- 修复 `getRegId()` 可能返回 `null` 的问题。
- 修复推送注册失败时未正确触发 Flutter 回调的问题。

---
## [0.0.3] - 2025-10-31
### Added
- 完善 iOS APNs 初始化逻辑，确保 Flutter 端 `initPush()` 能正确返回结果。
- 新增 `onNotificationClick` 回调，支持点击通知时获取 payload 数据。
- 添加日志开关，通过 `enableLog(true/false)` 控制调试输出。

### Changed
- 优化 iOS 原生插件方法结构，移除冗余代码，提高可维护性。
- 更新 APNs 代理注册逻辑，修复 `initPush` 不执行或 delegate 为 nil 的问题。

### Fixed
- 修复 iOS 推送注册时 `regId` 可能返回 nil 的问题。
- 修复应用从后台恢复时 badge 数字处理异常。

---

## [0.0.2] - 2025-10-30
- 移除冗余代码，简化插件实现。
- 内部结构优化，提高代码可读性和可维护性。

---

## [0.0.1] - 2025-10-29
- 初始发布 `ios_push_plugin`。
- 提供基础 iOS 推送功能：
  - 初始化推送服务 (`initPush`)
  - 获取设备注册 ID (`getRegId`)
  - 获取平台版本 (`getPlatformVersion`)
  - 获取设备厂商信息 (`getManufacturer`)
  - 日志开关 (`enableLog`)
  - 设置通知点击回调 (`setOnClickNotification`)
- 为未来扩展功能提供接口，如订阅主题、请求权限、处理前台通知等。
