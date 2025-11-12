import 'ios_push_plugin_platform_interface.dart';
import 'dart:async';

/// 🚀 iOS 推送插件主类
///
/// 该类封装了与原生 iOS 推送（APNs）的交互逻辑，
/// 提供统一的初始化、权限申请、设备注册、消息监听等功能。
///
/// ## 功能特性
/// - 初始化并注册 Apple 推送服务（APNs）
/// - 获取设备注册标识（RegId / Device Token）
/// - 前台、后台、点击通知等事件分发
/// - 查询系统信息（如设备制造商）
/// - 支持 Flutter 事件流监听
///
/// ## 使用示例
///
/// ```dart
/// void main() async {
///   // 启用调试日志
///   IosPushPlugin.instance.enableLog(true);
///
///   // 请求通知权限
///   final granted = await IosPushPlugin.instance.requestPermission();
///   if (!granted) {
///     print('用户拒绝通知权限');
///     return;
///   }
///
///   // 初始化推送服务
///   await IosPushPlugin.instance.initPush();
///   final regId = await IosPushPlugin.instance.register();
///   debugPrint('注册设备 token: $regId');
///
///   // 监听通知事件
///   IosPushPlugin.instance.onMessage.listen((event) {
///     print('收到推送消息: $event');
///   });
/// }
/// ```
///
/// ## iOS 端配置说明
/// 1. 在 Xcode 中开启 **Push Notifications** 能力。
/// 2. 确保 `aps-environment` 键已添加到 `Runner.entitlements`。
/// 3. 若使用 JWT 鉴权方式，请上传 `.p8` Key 并配置到 APNs Provider。
///
/// ## 注意事项
/// - Debug 模式下若未启用推送能力，注册可能失败。
/// - `initPush()` 会自动触发 APNs 注册流程。
/// - 若 App 冷启动于通知点击场景，插件将在 Flutter 初始化后自动派发事件。
///
/// 作者: Winston
/// 仓库: https://github.com/Winston1123/ios_push_plugin
/// License: MIT
class IosPushPlugin {
  const IosPushPlugin._();
  static final instance = IosPushPlugin._();

  /// 📱 获取当前 iOS 系统版本号，例如 “iOS 18.0”
  Future<String?> getPlatformVersion() =>
      IosPushPluginPlatform.instance.getPlatformVersion();

  /// 🧩 开启或关闭插件日志输出。
  ///
  /// 用于调试时观察插件行为。
  /// ```dart
  /// IosPushPlugin.instance.enableLog(true);
  /// ```
  void enableLog(bool enable) =>
      IosPushPluginPlatform.instance.enableLog(enable);

  /// 🚀 初始化推送服务。
  ///
  /// 触发 APNs 注册流程，返回结果包含状态信息。
  Future<void> initPush() => IosPushPluginPlatform.instance.initPush();

  /// 🏷️ 获取设备制造商信息。
  ///
  /// iOS 固定返回 `"Apple"`。
  Future<String?> getManufacturer() =>
      IosPushPluginPlatform.instance.getManufacturer();

  /// 🔐 请求通知权限。
  ///
  /// 用户拒绝时返回 `false`，同样会影响后续注册流程。
  Future<bool> requestPermission() =>
      IosPushPluginPlatform.instance.requestPermission();

  /// 🔄 手动触发注册流程。
  ///
  /// 与 [initPush] 类似，用于在特定时机重新注册 APNs。
  Future<dynamic> register() => IosPushPluginPlatform.instance.register();

  /// 💬 推送事件流。
  ///
  /// 监听来自原生的推送事件，包括：
  /// - `message`: 前台推送消息；
  /// - `click`: 用户点击通知；
  /// - `launch`: 冷启动通知；
  ///
  /// ```dart
  /// IosPushPlugin.instance.onMessage.listen((event) {
  ///   print('收到推送事件: $event');
  /// });
  /// ```
  Stream get onMessage => IosPushPluginPlatform.instance.onMessage;
}
