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
  Future initPush() {
    // TODO: implement initPush
    throw UnimplementedError();
  }
  
  @override
  // TODO: implement onMessage
  Stream get onMessage => throw UnimplementedError();
  
  @override
  Future<dynamic> register() {
    // TODO: implement register
    throw UnimplementedError();
  }
  
  @override
  Future<bool> requestPermission() {
    // TODO: implement requestPermission
    throw UnimplementedError();
  }

 

  
}

void main() {
  final IosPushPluginPlatform initialPlatform = IosPushPluginPlatform.instance;

  test('$MethodChannelIosPushPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIosPushPlugin>());
  });

  test('getPlatformVersion', () async {
    IosPushPlugin iosPushPlugin = IosPushPlugin.instance;
    MockIosPushPluginPlatform fakePlatform = MockIosPushPluginPlatform();
    IosPushPluginPlatform.instance = fakePlatform;

    expect(await iosPushPlugin.getPlatformVersion(), '42');
  });
}
