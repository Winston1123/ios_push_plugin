import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ios_push_plugin_method_channel.dart';

abstract class IosPushPluginPlatform extends PlatformInterface {
  /// Constructs a IosPushPluginPlatform.
  IosPushPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static IosPushPluginPlatform _instance = MethodChannelIosPushPlugin();

  /// The default instance of [IosPushPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelIosPushPlugin].
  static IosPushPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IosPushPluginPlatform] when
  /// they register themselves.
  static set instance(IosPushPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> initPush() {
    throw UnimplementedError('initPush() has not been implemented.');
  }

  Future<String?> getRegId() {
    throw UnimplementedError('getRegId() has not been implemented.');
  }

  void setNotificationClickListener(Function(dynamic) onNotificationClick) {
    throw UnimplementedError(
      'addNotificationClickListener() has not been implemented.',
    );
  }

  void setNotificationReceiveListener(Function(dynamic) onNotificationReceive) {
    throw UnimplementedError(
      'addNotificationReceiveListener() has not been implemented.',
    );
  }

  /// 设置注册ID回调
  void setRegIdListener(RegIdCallback callback) {
    throw UnimplementedError(
      'addNotificationClickListener() has not been implemented.',
    );
  }

  /// 设置错误回调
  void setErrorListener(ErrorCallback callback) {
    throw UnimplementedError(
      'addNotificationClickListener() has not been implemented.',
    );
  }

  Future<String?> getManufacturer() {
    throw UnimplementedError(
      'addNotificationClickListener() has not been implemented.',
    );
  }

  void enableLog(bool enable) {
    throw UnimplementedError(
      'addNotificationClickListener() has not been implemented.',
    );
  }

  // --------------------- 新增取消监听方法 ---------------------
  /// 取消通知点击监听
  void removeNotificationClickListener() {
    throw UnimplementedError(
      'removeNotificationClickListener() has not been implemented.',
    );
  }

  /// 取消通知接收监听
  void removeNotificationReceiveListener() {
    throw UnimplementedError(
      'removeNotificationReceiveListener() has not been implemented.',
    );
  }

  /// 取消注册ID监听
  void removeRegIdListener() {
    throw UnimplementedError('removeRegIdListener() has not been implemented.');
  }

  /// 取消错误回调监听
  void removeErrorListener() {
    throw UnimplementedError('removeErrorListener() has not been implemented.');
  }
}
