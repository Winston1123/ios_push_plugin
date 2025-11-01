//
//  Logger.swift
//  ios_push_plugin
//
//  Created by zhangwentong(Winston) on 2025/11/01.
//  Copyright (c) 
//
//  说明:
//  -----------------------------------------------------------------------------
//  一个轻量级日志工具类，用于控制台输出调试信息。
//  支持按需开启/关闭日志输出，确保生产环境安全。
//  后期可扩展：日志分级(Level)、文件输出、远程日志收集等。
//  -----------------------------------------------------------------------------

import Foundation

/// 日志打印工具类
final class Logger {
    
    /// 是否启用日志输出
    /// - 默认关闭，仅在调试/开发阶段开启。
    static var isEnabled: Bool = false
    
    /// 日志统一前缀（模块标识）
    private static let TAG: String = "📬 [PushModule]"
    
    /// 打印普通信息日志
    /// - Parameter message: 要打印的内容
    static func log(_ message: String) {
        guard isEnabled else { return }
        print("\(timestamp()) \(TAG): \(message)")
    }
    
    /// 打印警告日志
    /// - Parameter message: 警告描述
    static func warn(_ message: String) {
        guard isEnabled else { return }
        print("\(timestamp()) ⚠️ \(TAG) [WARN]: \(message)")
    }
    
    /// 打印错误日志
    /// - Parameter message: 错误描述
    static func error(_ message: String) {
        guard isEnabled else { return }
        print("\(timestamp()) ❌ \(TAG) [ERROR]: \(message)")
    }
    
    /// 获取当前时间戳（格式：HH:mm:ss.SSS）
    /// - Returns: 格式化时间字符串
    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
