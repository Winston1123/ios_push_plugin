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
    private var channel: FlutterMethodChannel
    private var regId: String?
    private var notificationCallback: ((Any) -> Void)?
    private var notificationReceiveCallback: ((Any) -> Void)?
    private let manufacturer = "APPLE"
    private var pendingRegIdResult: FlutterResult?
    
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ios_push_plugin", binaryMessenger: registrar.messenger())
        let instance = IosPushPlugin(channel: channel)
        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "initPush":
            initPush(result: result)
        case "getRegId":
            if let id = regId {
                result(id)
            } else {
                // 暂存 result，等系统回调 didRegisterForRemoteNotifications 后返回
                pendingRegIdResult = result
            }
        case "getManufacturer":
            result(manufacturer)
        case "enableLog":
            if let isEnabled = call.arguments as? Bool {
                Logger.isEnabled = isEnabled
            }
            result(nil)
        case "setNotificationClickListener":
            notificationCallback = call.arguments as? ((Any) -> Void)
            dispatchLaunchNotificationIfNeeded()
            result(nil)
        case "setNotificationReceiveListener":
            notificationReceiveCallback = call.arguments as? ((Any) -> Void)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initPush(result: @escaping FlutterResult) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                    result("APNs Init Success")
                } else {
                    result(FlutterError(code: "10086", message: "APNs permission denied", details: nil))
                }
            }
        }
    }
    
    // MARK: - AppDelegate Hooks
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        if let launchNotification = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            UserDefaults.standard.set(launchNotification, forKey: "PendingNotification")
        }
        return true
    }
    public func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = -1;
    }
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.regId = token
        Logger.log("APNs register success: \(token)")
        
        // 通知 Flutter
        channel.invokeMethod("onRegId", arguments: ["regId": token, "manufacturer": manufacturer])
        // 如果 Flutter 有人在等 result，就返回
        pendingRegIdResult?(token)
        pendingRegIdResult = nil
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.log("APNs register failed: \(error)")
        channel.invokeMethod("onError", arguments: ["error": error.localizedDescription])
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
        let content = response.notification.request.content
        onMessageClick(content: content)
        completionHandler()
    }
    
    private func onMessageReceive(content: UNNotificationContent) {
        Logger.log("Notification received: \(content)")
        // 通过回调发送到 Flutter
        
        notificationReceiveCallback?(content.toJSONString())
        channel.invokeMethod("onNotificationReceive", arguments: content.toJSONString())
        // 清空
        UserDefaults.standard.removeObject(forKey: "PendingNotification")
    }
    private func onMessageClick(content: UNNotificationContent) {
        Logger.log("Notification received: \(content)")
        // 通过回调发送到 Flutter
        
        notificationCallback?(content.toJSONString())
        channel.invokeMethod("onNotificationClick", arguments: content.toJSONString())
        // 清空
        UserDefaults.standard.removeObject(forKey: "PendingNotification")
    }
    // 2️⃣ 在 Flutter 调用 setNotificationClickListener 时，触发冷启动通知
    private func dispatchLaunchNotificationIfNeeded() {
        guard let userInfo = UserDefaults.standard.object(forKey: "PendingNotification") else { return }
        
        Logger.log("Dispatching cold-start notification: \(userInfo)")
        let content = ["userInfo":userInfo]
        // 先调用 Flutter 回调
        notificationCallback?(content.toJSONString())
        
        // 通过 channel 发送给 Flutter
        channel.invokeMethod("onNotificationClick", arguments: content.toJSONString())
        
        // 清空
        UserDefaults.standard.removeObject(forKey: "PendingNotification")
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
