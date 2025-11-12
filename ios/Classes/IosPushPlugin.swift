//
//  Logger.swift
//  ios_push_plugin
//
//  Created by zhangwentong(Winston) on 2025/11/01.
//  Copyright (c)
import Flutter
import UIKit
import UserNotifications

public class IosPushPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {
    private let manufacturer = "APPLE"
    private let messageEventChannel: MessageEventChannel = MessageEventChannel()
    private var channel: FlutterMethodChannel?
    
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ios_push_plugin", binaryMessenger: registrar.messenger())
        let instance:IosPushPlugin = IosPushPlugin()
        instance.channel =  FlutterMethodChannel(name: "ios_push_plugin/callback", binaryMessenger: registrar.messenger())
        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // EventChannel
        let eventChannel = FlutterEventChannel(
            name: "ios_push_plugin/events",
            binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance.messageEventChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "initPush":
            UNUserNotificationCenter.current().delegate = self
            result(nil)
        case "requestPermission":
            requestNotificationPermission(result: result)
        case "register":
            registerAPNs(result: result)
            result(nil)
        case "getManufacturer":
            result(manufacturer)
        case "enableLog":
            if let isEnabled = call.arguments as? Bool {
                Logger.isEnabled = isEnabled
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - 📱 APNs Registration
    private func registerAPNs(result: @escaping FlutterResult) {
        Logger.log("🚀 Registering for APNs...")
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    private func requestNotificationPermission(result: @escaping FlutterResult) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                Logger.log("Error requesting notification permissions: \(error.localizedDescription)")
                result(false)
            } else {
                result(granted)
                Logger.log("Permission granted: \(granted)")
            }
        }
    }
    
    // MARK: - AppDelegate Hooks
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = -1;
    }
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Logger.log("APNs register success: \(token)")
        channel?.invokeMethod("onCompleted",arguments: token)
        
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.log("APNs register failed: \(error)")
        channel?.invokeMethod("onError", arguments: ["error": error.localizedDescription])
    }
    
    // MARK: - Notification Callbacks
    /// 当 App 在前台时收到推送通知（包括远程推送和本地通知）会触发此方法。
    ///
    /// - Parameters:
    ///   - center: 通知中心对象。
    ///   - notification: 收到的通知对象，包含标题、内容和自定义 payload（userInfo）。
    ///   - completionHandler: 通知展示的回调，必须调用，否则通知不会显示。
    ///
    /// - Note:
    ///   * 默认情况下，App 处于前台时系统不会展示通知横幅。
    ///   * 若希望展示通知提醒（如声音或弹窗），需调用 completionHandler 并传入展示选项。
    ///   * 此方法仅代表「通知已到达」，**用户尚未点击**。
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        completionHandler([.alert, .sound])
        onMessageReceive(content: content)
        
    }
    /// 当用户点击通知（无论 App 在前台、后台或被杀死）时会触发此方法。
    ///
    /// - Parameters:
    ///   - center: 通知中心对象。
    ///   - response: 用户对通知的响应，包含通知内容和点击行为。
    ///   - completionHandler: 系统回调，必须在处理完成后调用。
    ///
    /// - Note:
    ///   * 用户点击通知横幅、锁屏通知或通知中心的消息都会触发。
    ///   * 在这里通常处理导航跳转、数据统计或打开具体页面。
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        // 获取用户点击的动作标识
        let actionId = response.actionIdentifier
        
        // 获取通知本身
        let notification = response.notification
        let content = notification.request.content
        // 根据 actionIdentifier 处理不同情况
        switch actionId {
        case UNNotificationDefaultActionIdentifier:
            // 用户点击通知打开 App
            onMessageClick(content: content)
            
        case UNNotificationDismissActionIdentifier:
            // 用户滑动或关闭通知
            onMessageCancel(content: content)
            
        default:
            // 自定义操作
            Logger.log("Custom action: \(actionId)")
        }
        completionHandler()
    }
    
    private func onMessageReceive(content: UNNotificationContent) {
        Logger.log("Notification received: \(content)")
        // 通过回调发送到 Flutter
        
        messageEventChannel.sendData(["type":"receive","content":content.toFullDictionary()].toJSONString())
    }
    private func onMessageClick(content: UNNotificationContent) {
        Logger.log("Notification received: \(content)")
        // 通过回调发送到 Flutter
        messageEventChannel.sendData(["type":"click","content":content.toFullDictionary()].toJSONString())
        
        
        
        
    }
    private func onMessageCancel(content: UNNotificationContent) {
        Logger.log("Notification cancel: \(content)")
        // 通过回调发送到 Flutter
        
        messageEventChannel.sendData(["type":"cancel","content":content.toFullDictionary()].toJSONString())
        
        
        
    }
    
    
}
// MARK: - AppDelegate Hooks
extension IosPushPlugin {
    
    /// 冷启动 / 热启动通知
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]
    ) -> Bool {
        // 1️⃣ 检查 App 是不是因为通知启动的
        if let launchNotification = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            Logger.log("Cold start notification: \(launchNotification)")
            // 缓存通知，等 Flutter EventChannel 初始化再发送
        }
        return true
    }
    
    /// 前台/后台静默推送（iOS 7+）或带 content-available 的推送
    public func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) -> Bool {
        Logger.log("Received remote notification: \(userInfo)")
        
        // 通过 EventChannel 或 MethodChannel 派发给 Flutter
        messageEventChannel.sendData(["type":"receive","content":["userInfo":userInfo]].toJSONString())
        
        
        // 完成处理
        completionHandler(.newData)
        return true
    }
}

extension UNNotificationCategoryOptions {
    static let stringToValue: [String: UNNotificationCategoryOptions] = {
        var r: [String: UNNotificationCategoryOptions] = [:]
        r["UNNotificationCategoryOptions.customDismissAction"] = .customDismissAction
        r["UNNotificationCategoryOptions.allowInCarPlay"] = .allowInCarPlay
        if #available(iOS 11.0, *) {
            r["UNNotificationCategoryOptions.hiddenPreviewsShowTitle"] = .hiddenPreviewsShowTitle
        }
        if #available(iOS 11.0, *) {
            r["UNNotificationCategoryOptions.hiddenPreviewsShowSubtitle"] = .hiddenPreviewsShowSubtitle
        }
        if #available(iOS 13.0, *) {
            r["UNNotificationCategoryOptions.allowAnnouncement"] = .allowAnnouncement
        }
        return r
    }()
}


extension UNNotificationContent {
    /// 将通知内容完整序列化为 Dictionary
    func toFullDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "subtitle": subtitle,
            "body": body,
            "categoryIdentifier": categoryIdentifier,
            "threadIdentifier": threadIdentifier,
            "launchImageName": launchImageName,
            "userInfo": userInfo
        ]
        
        if let badge = badge { dict["badge"] = badge }
        if let sound = sound { dict["sound"] = String(describing: sound) }
        
        if #available(iOS 12.0, *) {
            dict["summaryArgument"] = summaryArgument
            dict["summaryArgumentCount"] = summaryArgumentCount
        }
        
        if #available(iOS 13.0, *) {
            dict["targetContentIdentifier"] = targetContentIdentifier ?? NSNull()
        }
        
        if #available(iOS 15.0, *) {
            dict["interruptionLevel"] = interruptionLevel.rawValue
            dict["relevanceScore"] = relevanceScore
        }
        
        if #available(iOS 16.0, *) {
            dict["filterCriteria"] = filterCriteria ?? NSNull()
        }
        
        if !attachments.isEmpty {
            dict["attachments"] = attachments.map { att in
                [
                    "identifier": att.identifier,
                    "url": att.url.absoluteString,
                    "type": att.type
                ]
            }
        } else {
            dict["attachments"] = []
        }
        
        return dict
    }
    
    /// 将通知内容序列化为 JSON 字符串（便于日志或跨平台传输）
    func toJSONString(pretty: Bool = true) -> String {
        let dict = toFullDictionary()
        let options: JSONSerialization.WritingOptions = pretty ? [.prettyPrinted] : []
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: options),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }
}
extension Dictionary where Key == String {
    func toJSONString(pretty: Bool = true) -> String {
        let options: JSONSerialization.WritingOptions = pretty ? [.prettyPrinted] : []
        
        guard
            JSONSerialization.isValidJSONObject(self),
            let data = try? JSONSerialization.data(withJSONObject: self, options: options),
            let json = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        
        return json
    }
}
class MessageEventChannel: NSObject, FlutterStreamHandler{
    private var sink:FlutterEventSink? = nil
    private var messageWhenAppKilled: String? = nil
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        if let mess = messageWhenAppKilled {
            sendData(mess)
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
    func sendData(_ data:String?) {
        if sink == nil {
            messageWhenAppKilled = data
        }
        if data == nil {return}
        self.sink?(data)
    }
    
}
