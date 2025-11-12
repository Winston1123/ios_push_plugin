# 🍎 ios_push_plugin

轻量级 iOS 推送注册插件 —— 基于原生 **APNs (Apple Push Notification Service)** 封装，  
为 Flutter 提供 **简洁、可监听、可调试** 的推送初始化与回调机制。

---

## ✨ 特性 (Features)

- ✅ 一行代码初始化推送服务 (`initPush`)  
- ✅ 持续监听推送事件 (`onMessage` Stream)  
  - Stream 版本：实时更新 UI  
  - Future 版本：一次性回调，自动取消监听  
- ✅ 错误捕获回调 (`onError`)  
- ✅ 插件日志可控 (`enableLog`)  
- ✅ 自动反序列化 `NotificationContent`  
  - 包含 `payload` 和 `custom_data`  
- ✅ 请求通知权限 (`requestPermission`)  
- ✅ 获取设备制造商信息 (`getManufacturer`)  
- ✅ 手动触发注册流程 (`register`)  


## ⚙️ 安装 (Installation)

```yaml
dependencies:
  ios_push_plugin: ^0.1.1
```
