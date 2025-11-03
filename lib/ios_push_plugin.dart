import 'ios_push_plugin_platform_interface.dart';

//
//  IosPushPlugin.swift
//  ios_push_plugin
//
//  Created by zhangwentong(Winston) on 2025/10/31.
//
//  Copyright © 2025 zhangwentong(Winston).
//  All rights reserved.
//
//  📦 Description:
//  -----------------------------
//  A lightweight iOS push notification bridge for Flutter,
//  providing unified APNs registration and message handling.
//
//  ✅ Features:
//  - Register for APNs and obtain `regId` (device token).
//  - Receive push notifications in foreground and background.
//  - Support Flutter callback for notification click.
//  - Expose native system info like manufacturer.
//
//  🧩 Dart Side Usage Example:
//
//  ```dart
//  import 'package:ios_push_plugin/ios_push_plugin.dart';
//
//  void main() async {
//    // 初始化推送
//    await IosPushPlugin.initPush();
//
//    // 获取注册的 deviceToken（regId）
//    final regId = await IosPushPlugin.getRegId();
//    print('APNs RegId: $regId');
//
//    // 设置点击通知回调
//    IosPushPlugin.setOnClickNotification((data) {
//      print('Notification clicked: $data');
//    });
//  }
//  ```
//
//  📘 iOS Configuration:
//  -----------------------------
//  1. Enable "Push Notifications" capability in Xcode.
//  2. Ensure `aps-environment` key exists in `Runner.entitlements`.
//  3. For JWT key authentication, upload your `.p8` key and set it in APNs provider.
//
//  🧠 Notes:
//  - In Debug mode, APNs registration might fail if provisioning profile
//    doesn't include push capability. Use `--profile` or `--release` build to verify.
//  - The plugin auto-returns pending `getRegId` results once available.
//
//  🔗 Repository:
//  https://github.com/Winston1123/ios_push_plugin
//
//  License: MIT
//

class IosPushPlugin {
  /// 📱 获取当前 iOS 系统版本号。
  ///
  /// 示例：
  /// ```dart
  /// final version = await IosPushPlugin().getPlatformVersion();
  /// print('iOS version: $version');
  /// ```
  Future<String?> getPlatformVersion() {
    return IosPushPluginPlatform.instance.getPlatformVersion();
  }

  /// 🚀 初始化推送服务。
  ///
  /// - 请求用户授权通知权限。
  /// - 注册 APNs。
  /// - 返回注册结果（成功或错误信息）。
  ///
  /// 示例：
  /// ```dart
  /// final result = await IosPushPlugin.initPush();
  /// print(result); // "APNs Init Success"
  /// ```
  static Future<dynamic> initPush() async {
    return await IosPushPluginPlatform.instance.initPush();
  }

  /// 🔑 获取设备注册 ID（APNs Token）。
  ///
  /// - 若已注册，则立即返回。
  /// - 若注册尚未完成，将等待系统返回后异步返回。
  ///
  /// 示例：
  /// ```dart
  /// final regId = await IosPushPlugin.getRegId();
  /// print('RegId: $regId');
  /// ```
  static Future<String?> getRegId() async {
    return await IosPushPluginPlatform.instance.getRegId();
  }

  /// 🏭 获取设备厂商信息。
  ///
  /// 通常返回 `"APPLE"`。
  static Future<String?> getManufacturer() async {
    return await IosPushPluginPlatform.instance.getManufacturer();
  }

  /// 🧾 是否开启日志输出。
  ///
  /// 开启后将输出注册与推送事件日志，便于调试。
  ///
  /// 示例：
  /// ```dart
  /// IosPushPlugin.enableLog(true);
  /// ```
  static void enableLog(bool enable) {
    IosPushPluginPlatform.instance.enableLog(enable);
  }

  /// 🔔 设置通知点击回调。
  ///
  /// 当用户点击推送消息（无论应用在前台或后台），
  /// 原生层会回调此方法并携带推送 payload。
  ///
  /// 示例：
  /// ```dart
  /// IosPushPlugin.setOnClickNotification((data) {
  ///   print('Notification data: $data');
  /// });
  /// ```
  static void setOnClickNotification(Function(dynamic) onClickNotification) {
    IosPushPluginPlatform.instance.setNotificationClickListener(
      onClickNotification,
    );
  }

  /// 🔔 设置通知收到回调。
  ///
  /// 当用户收到推送消息（无论应用在前台或后台），
  /// 原生层会回调此方法并携带推送 payload。
  ///
  /// 示例：
  /// ```dart
  /// IosPushPlugin.setOnReceiveNotification((data) {
  ///   print('Notification data: $data');
  /// });
  /// ```
  static void setOnReceiveNotification(
    Function(dynamic) onReceiveNotification,
  ) {
    IosPushPluginPlatform.instance.setNotificationReceiveListener(
      onReceiveNotification,
    );
  }

  /// 🧩 设置注册 ID（deviceToken）更新回调。
  ///
  /// 用于在注册成功时接收 token。
  ///
  /// 示例：
  /// ```dart
  /// IosPushPlugin.setOnRegId((regId) {
  ///   print('Device registered: $regId');
  /// });
  /// ```
  /// 🔑 设置注册ID回调
  static void setOnRegId(Function(String) onRegId) {
    IosPushPluginPlatform.instance.setRegIdListener(onRegId);
  }

  /// ❌ 设置推送错误回调。
  ///
  /// 当注册或推送出现错误时触发。
  ///
  /// 示例：
  /// ```dart
  /// IosPushPlugin.setOnError((err) {
  ///   print('Push error: $err');
  /// });
  /// ```
  /// ❌ 设置错误回调
  static void setOnError(Function(String) onError) {
    IosPushPluginPlatform.instance.setErrorListener(onError);
  }
}
