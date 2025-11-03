# 🍎 ios_push_plugin

轻量级 iOS 推送注册插件 —— 基于原生 **APNs (Apple Push Notification Service)** 封装，  
为 Flutter 提供 **简洁、可监听、可调试** 的推送初始化与回调机制。

---

## ✨ 特性 (Features)

✅ 一行代码初始化推送  
✅ 异步获取注册 ID (`getRegId`)  
✅ 通知点击事件回调 (`clickNotifications` / `getClickNotification`)  
✅ 通知接收事件回调 (`receiveNotifications` / `getReceiveNotification`)  
✅ Stream 版本持续监听推送，适合实时 UI 更新  
✅ Future 版本一次性回调，获取完成后自动取消监听  
✅ 错误捕获回调 (`onError`)  
✅ 日志可控 (`enableLog`)  
✅ 自动反序列化 `NotificationContent`，包括 `payload` 和 `custom_data`

---

## ⚙️ 安装 (Installation)

```yaml
dependencies:
  ios_push_plugin: ^0.0.7
```
