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

  Future<void> initPush() {
    throw UnimplementedError('initPush() has not been implemented.');
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

  Future<bool> requestPermission() {
    throw UnimplementedError('initial() has not been implemented.');
  }

  Future<dynamic> register() {
    throw UnimplementedError('initial() has not been implemented.');
  }

  Stream get onMessage {
    throw UnimplementedError('onMessage() has not been implemented.');
  }
}
