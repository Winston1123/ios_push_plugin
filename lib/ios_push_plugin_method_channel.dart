import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ios_push_plugin_platform_interface.dart';



/// An implementation of [IosPushPluginPlatform] that uses method channels.
class MethodChannelIosPushPlugin extends IosPushPluginPlatform {
  /// The method channel used to interact with the native platform.
  /// MethodChannel
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('ios_push_plugin');

  //#region register
  var _completer = Completer<dynamic>();
  final callback = const MethodChannel('ios_push_plugin/callback');
  //#endregion
  final eventChannel = const EventChannel('ios_push_plugin/events');

  @override
  Future<String?> getPlatformVersion() =>
      methodChannel.invokeMethod<String>('getPlatformVersion');

  @override
  void enableLog(bool enable) =>
      methodChannel.invokeMethod('enableLog', enable);

  @override
  Future<String?> getManufacturer() async =>
      await methodChannel.invokeMethod('getManufacturer');

  @override
  Future<void> initPush() => methodChannel.invokeMethod('initPush');

  @override
  Future<bool> requestPermission() async {
    final result = await methodChannel.invokeMethod<bool>('requestPermission');
    return result ?? false;
  }

  @override
  Future<dynamic> register() async {
    _completer = Completer();
    callback.setMethodCallHandler((handle) async {
      if (handle.method == 'onCompleted') {
        _completer.complete(handle.arguments as String);
      } else if (handle.method == 'onError') {
        _completer.complete(handle.arguments);
      }
    });
    await methodChannel.invokeMethod('register');

    return await _completer.future;
  }

  @override
  Stream get onMessage => eventChannel.receiveBroadcastStream();
}
