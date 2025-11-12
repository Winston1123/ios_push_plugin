import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ios_push_plugin/ios_push_plugin.dart';

void main() {
  runApp(const MyApp());
}

/// 示例应用入口
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// 示例逻辑实现
class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _regId = '未注册';
  String _lastMessage = '无推送消息';
  bool _isInit = false;

  final _iosPushPlugin = IosPushPlugin.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPushService();
  }

  /// 获取系统版本号
  Future<void> initPlatformState() async {
    try {
      final version = await _iosPushPlugin.getPlatformVersion();
      if (!mounted) return;
      setState(() => _platformVersion = version ?? 'Unknown');
    } on PlatformException {
      setState(() => _platformVersion = '获取系统版本失败');
    }
  }

  /// 初始化推送
  /// 初始化 iOS 推送服务
  Future<void> initPushService() async {
    try {
      // 开启日志
      IosPushPlugin.instance.enableLog(true);
      debugPrint('📢 [IosPush] 日志已启用');

      // 请求权限
      final granted = await IosPushPlugin.instance.requestPermission();
      if (!granted) {
        debugPrint('⚠️ [IosPush] 用户拒绝通知权限');
        return;
      }

      // 初始化推送
      await IosPushPlugin.instance.initPush();
      final regId = await IosPushPlugin.instance.register();
      debugPrint('注册设备 token: $regId');

      // 监听消息
      IosPushPlugin.instance.onMessage.listen((event) {
        debugPrint('📩 收到推送消息: $event');
      });

      setState(() => _isInit = true);
    } catch (e, s) {
      debugPrint('❌ [IosPush] 初始化失败: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS Push Plugin Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('iOS Push Plugin Demo'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSection(
              title: '📱 平台信息',
              child: Text('运行在: $_platformVersion'),
            ),
            _buildSection(
              title: '🔑 注册信息',
              child: Text(
                _isInit ? 'RegId: $_regId' : '尚未初始化推送服务 (initPush 未调用)',
              ),
            ),
            _buildSection(title: '📩 最新推送消息', child: Text(_lastMessage)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: initPushService,
              child: const Text('重新初始化推送'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
