import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ios_push_plugin/exception/register_exception.dart';
import 'dart:convert';

import 'ios_push_plugin_platform_interface.dart';

typedef RegIdCallback = void Function(String regId);
typedef ErrorCallback = void Function(String error);

/// An implementation of [IosPushPluginPlatform] that uses method channels.
class MethodChannelIosPushPlugin extends IosPushPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ios_push_plugin');

  MethodChannelIosPushPlugin() {
    methodChannel.setMethodCallHandler(flutterMethod);
  }

  Function(dynamic)? onNotificationClick;
  Function(dynamic)? onNotificationReceive;

  RegIdCallback? _onRegId;
  ErrorCallback? _onError;

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<dynamic> initPush() async {
    try {
      return await methodChannel.invokeMethod('initPush');
    } on PlatformException catch (error) {
      throw RegisterException(error: "${error.message}", errorCode: "10086");
    }
  }

  @override
  Future<String?> getRegId() async {
    return await methodChannel.invokeMethod('getRegId');
  }

  @override
  void enableLog(bool enable) {
    methodChannel.invokeMethod('enableLog', enable);
  }

  Future<dynamic> flutterMethod(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'onNotificationClick':
        notifyClickListener(methodCall.arguments);
        break;
      case 'onNotificationReceive':
        notifyReceiveListener(methodCall.arguments);
        break;
      case 'onRegId':
        _notifyRegIdListener(methodCall.arguments);
        break;
      case 'onError':
        _notifyErrorListener(methodCall.arguments);
        break;
      default:
        break;
    }
  }

  void notifyClickListener(dynamic data) {
    if (data != null && data is String && data.isNotEmpty) {
      data = jsonDecode(data);
    }

    onNotificationClick?.call(data);
  }

  void notifyReceiveListener(dynamic data) {
    if (data != null && data is String && data.isNotEmpty) {
      data = jsonDecode(data);
    }

    onNotificationReceive?.call(data);
  }

  void _notifyRegIdListener(dynamic args) {
    if (args is Map && args['regId'] != null) {
      _onRegId?.call(args['regId'] as String);
    }
  }

  void _notifyErrorListener(dynamic args) {
    if (args is Map && args['error'] != null) {
      _onError?.call(args['error'] as String);
    } else if (args is String) {
      _onError?.call(args);
    }
  }

  @override
  void setNotificationClickListener(Function(dynamic) onNotificationClick) {
    this.onNotificationClick = onNotificationClick;
  }

  @override
  void setNotificationReceiveListener(Function(dynamic) onNotificationReceive) {
    this.onNotificationReceive = onNotificationReceive;
  }

  /// 设置注册ID回调
  @override
  void setRegIdListener(RegIdCallback callback) {
    _onRegId = callback;
  }

  /// 设置错误回调
  @override
  void setErrorListener(ErrorCallback callback) {
    _onError = callback;
  }

  @override
  Future<String?> getManufacturer() async {
    return await methodChannel.invokeMethod('getManufacturer');
  }

  /// 取消通知点击监听
  @override
  void removeNotificationClickListener() {
    onNotificationClick = null;
  }

  /// 取消通知收到监听
  @override
  void removeNotificationReceiveListener() {
    onNotificationReceive = null;
  }

  /// 取消 RegId 监听
  @override
  void removeRegIdListener() {
    _onRegId = null;
  }

  /// 取消错误回调监听
  @override
  void removeErrorListener() {
    _onError = null;
  }
}
