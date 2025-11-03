# 🍎 ios_push_plugin

轻量级 iOS 推送注册插件 —— 基于原生 **APNs (Apple Push Notification Service)** 封装，  
为 Flutter 提供 **简洁、可监听、可调试** 的推送初始化与回调机制。

---

## ✨ 特性 (Features)

✅ 一行代码初始化推送  
✅ 自动回调注册 ID (`onRegId`)  
✅ 通知点击事件回调 (`onNotificationClick`)  
✅ 错误捕获回调 (`onError`)  
✅ 日志可控 (`enableLog`)  
✅ 异步获取 `regId`，即便初始化未完成也能自动等待返回  

---

## ⚙️ 安装 (Installation)

```yaml
dependencies:
  ios_push_plugin: ^0.0.6


