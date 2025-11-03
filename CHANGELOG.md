# Changelog

## [0.0.8] - 2025-11-03

### 🐛 Fixed

- 修复 `getRegId()` 可能返回 `null` 的问题。
- 修复推送注册失败时未正确触发 Flutter 回调的问题。

---

## [0.0.7] - 2025-11-03

### 🚀 Added

- 新增 **Stream 版本通知监听**：
  - `clickNotifications`：持续监听点击通知
  - `receiveNotifications`：持续监听前台收到的通知
- 新增 **Future 版本通知获取**：
  - `getClickNotification()`：冷启动或单次点击通知获取
  - `getReceiveNotification()`：前台单次接收通知获取
- 异步获取注册 ID 支持 Future 方式：
  - `getRegId()`，获取完成后自动取消监听
- `NotificationContent` 模型支持 nullable，避免序列化/反序列化崩溃

### ⚙️ Changed

- 调整通知回调处理逻辑：
  - 冷启动点击通知时，先触发 Future/Stream，再触发原生回调
  - 前台通知和点击通知顺序优化，保证 UI 响应一致
- 内部流处理优化：
  - `_clickController` 和 `_receiveController` 支持广播
  - 自动初始化监听，避免重复注册

### 🐛 Fixed

- 修复 Future/Stream 重复触发问题
- 修复 iOS 17+ 前台通知 alert 不显示时回调丢失
- 修复注册 ID 获取可能丢失的问题
- 修复原生回调 JSON 解析异常可能导致崩溃的问题

---

## [0.0.6] - 2025-11-03

### 🚀 Added

- 新增 `setOnReceiveNotification(Function(Map))` 回调事件：App 前台收到通知时触发，可立即获取通知内容，便于 UI 更新或消息处理。
- 新增 `getPendingNotifications()` 接口：获取当前待处理的本地或远程推送列表，支持批量管理与展示。
- 示例 `Example` 中新增：
  - 前台推送接收演示：`setOnReceiveNotification()`
  - 获取待处理通知列表：`getPendingNotifications()`
  - 日志示例结合前台与后台通知，便于调试全流程消息。

### ⚙️ Changed

- 优化通知回调顺序：
  - 前台通知先触发 `onReceiveNotification`，点击通知后再触发 `onClickNotification`。
- 改进 iOS 通知权限流程：
  - 避免重复弹窗
  - 修复冷启动点击通知时回调延迟问题
- 文档更新：
  - 新增前台通知处理示意图
  - 补充 `getPendingNotifications` 使用示例
  - 增强调试日志示例说明

### 🐛 Fixed

- 修复 iOS 17+ 前台通知不显示 alert 时回调丢失问题
- 修复 `setOnClickNotification()` 在 App 冷启动时可能丢失的 edge case
- 修复 Android 13+ 部分设备上通知权限拒绝后重复请求的问题

---

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
