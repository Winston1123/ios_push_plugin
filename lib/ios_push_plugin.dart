import 'ios_push_plugin_platform_interface.dart';

class IosPushPlugin {
  Future<String?> getPlatformVersion() {
    return IosPushPluginPlatform.instance.getPlatformVersion();
  }

  static Future<dynamic> initPush() async {
    return await IosPushPluginPlatform.instance.initPush();
  }

  static Future<String?> getRegId() async {
    return await IosPushPluginPlatform.instance.getRegId();
  }

  static Future<String?> getManufacturer() async {
    return await IosPushPluginPlatform.instance.getManufacturer();
  }

  static void enableLog(bool enable) {
    IosPushPluginPlatform.instance.enableLog(enable);
  }

  static void setOnClickNotification(Function(dynamic) onClickNotification) {
    IosPushPluginPlatform.instance.setNotificationClickListener(
      onClickNotification,
    );
  }

  /// 🔑 设置注册ID回调
  static void setOnRegId(Function(String) onRegId) {
    IosPushPluginPlatform.instance.setRegIdListener(onRegId);
  }

  /// ❌ 设置错误回调
  static void setOnError(Function(String) onError) {
    IosPushPluginPlatform.instance.setErrorListener(onError);
  }
}
