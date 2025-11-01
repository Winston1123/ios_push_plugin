# ios_push_plugin

A Flutter plugin that provides **native iOS APNs (Apple Push Notification Service)** integration.  
This plugin allows you to easily initialize APNs, retrieve the device token (`regId`), and handle push notification events.

---

## 🧩 Features

- ✅ Initialize iOS Push Notification Service (`initPush`)
- ✅ Retrieve device registration ID (`getRegId`)
- ✅ Listen for real-time registration ID via `onRegId` event
- ✅ Get iOS system version and manufacturer info
- ✅ Handle push notification click callbacks (`onNotificationClick`)
- ✅ Enable or disable internal logs (`enableLog(true/false)`)

---

## 🚀 Installation

Add this line to your `pubspec.yaml`:

```yaml
dependencies:
  ios_push_plugin: ^0.0.4

