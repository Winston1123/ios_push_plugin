import 'package:flutter_test/flutter_test.dart';
import 'package:ios_push_plugin/ios_push_plugin.dart';
import 'package:ios_push_plugin/ios_push_plugin_platform_interface.dart';
import 'package:ios_push_plugin/ios_push_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIosPushPluginPlatform
    with MockPlatformInterfaceMixin
    implements IosPushPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  
  @override
  void enableLog(bool enable) {
    // TODO: implement enableLog
  }
  
  @override
  Future<String?> getManufacturer() {
    // TODO: implement getManufacturer
    throw UnimplementedError();
  }
  
  @override
  Future<String?> getRegId() {
    // TODO: implement getRegId
    throw UnimplementedError();
  }
  
  @override
  Future initPush() {
    // TODO: implement initPush
    throw UnimplementedError();
  }
  
  @override
  void setNotificationClickListener(Function(dynamic p1) onNotificationClick) {
    // TODO: implement setNotificationClickListener
  }
  
  @override
  void setErrorListener(ErrorCallback callback) {
    // TODO: implement setErrorListener
  }
  
  @override
  void setRegIdListener(RegIdCallback callback) {
    // TODO: implement setRegIdListener
  }
  
  @override
  void setNotificationReceiveListener(Function(dynamic p1) onNotificationReceive) {
    // TODO: implement setNotificationReceiveListener
  }
}

void main() {
  final IosPushPluginPlatform initialPlatform = IosPushPluginPlatform.instance;

  test('$MethodChannelIosPushPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIosPushPlugin>());
  });

  test('getPlatformVersion', () async {
    IosPushPlugin iosPushPlugin = IosPushPlugin();
    MockIosPushPluginPlatform fakePlatform = MockIosPushPluginPlatform();
    IosPushPluginPlatform.instance = fakePlatform;

    expect(await iosPushPlugin.getPlatformVersion(), '42');
  });
}
