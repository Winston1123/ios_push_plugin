# Changelog

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
