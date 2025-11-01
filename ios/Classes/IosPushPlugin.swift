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
    private var notificationCallback: ((String?) -> Void)?
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
            notificationCallback = call.arguments as? ((String?) -> Void)
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
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([.alert, .sound])
        onMessage(userInfo: userInfo)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        onMessage(userInfo: userInfo)
        completionHandler()
    }
    
    private func onMessage(userInfo: [AnyHashable: Any]) {
        Logger.log("Notification received: \(userInfo)")
        // 通过回调发送到 Flutter
        let data = (userInfo["aps"] as? [String: Any])?["attributes"] as? [String: Any]? ?? nil
        notificationCallback?(data?["data"] as? String)
        channel.invokeMethod("onNotificationClick", arguments: data?["data"] as? String)
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
