//
//  LogUtils.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 02/11/25.
//

import Foundation

public enum LogEvent: String {
    case e = "[‼️] ERROR" // error // swiftlint:disable:this identifier_name
    case i = "[ℹ️] INFO" // info // swiftlint:disable:this identifier_name
    case d = "[💬] DEBUG" // debug // swiftlint:disable:this identifier_name
    case v = "[🔬] VERBOSE" // verbose // swiftlint:disable:this identifier_name
    case w = "[⚠️] WARNING" // warning // swiftlint:disable:this identifier_name
    case s = "[🔥] SEVERE" // severe // swiftlint:disable:this identifier_name
}

/// LogUtils - Have different variations of logs, with proper highlighting markers, in IDE console
/// Have Logs with complete details viz - fileName, lineNo, functionName & columnIndex.

public class LogUtils {
    // 1. The date formatter
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    /// Wrapping Swift.print() within DEBUG flag
    public class func print(_ object: Any) {
        /// Only allowing in DEBUG mode
        if self.isLoggingEnabled {
            Swift.print(object)
        }
    }
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    /// "[‼️] ERROR" // error
    public class func e( _ object: Any, filename: String = #file, line: Int = #line,
                         column: Int = #column, funcName: String = #function) {
        if self.isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)") // swiftlint:disable:this line_length
        }
    }
    /// "[ℹ️] INFO" // info
    public class func i( _ object: Any, filename: String = #file, line: Int = #line,
                         column: Int = #column, funcName: String = #function) {
        if self.isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)") // swiftlint:disable:this line_length
        }
    }
    /// "[💬] DEBUG" // debug
    public class func v( _ object: Any, filename: String = #file, line: Int = #line,
                         column: Int = #column, funcName: String = #function) {
        if self.isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)") // swiftlint:disable:this line_length
        }
    }
    ///"[🔬] VERBOSE" // verbose
    public class func d( _ object: Any, filename: String = #file, line: Int = #line,
                         column: Int = #column, funcName: String = #function) {
        if self.isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)") // swiftlint:disable:this line_length
        }
    }
    ///"[⚠️] WARNING" // warning
    public class func w( _ object: Any, filename: String = #file, line: Int = #line,
                         column: Int = #column, funcName: String = #function) {
        if self.isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.w.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)") // swiftlint:disable:this line_length
        }
    }
    ///"[🔥] SEVERE" // severe
    public class func s( _ object: Any, filename: String = #file, line: Int = #line,
                         column: Int = #column, funcName: String = #function) {
        if self.isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.s.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)") // swiftlint:disable:this line_length
        }
    }
}
// 2. The Date to String extension
public extension Date {
    func toString() -> String {
        return LogUtils.dateFormatter.string(from: self as Date)
    }
}
/// Enable Logs in debug mode only by mentioning below line in AppDelegate
/// #if DEBUG
///  LogUtils.setLoggingEnabled(isEnabled: **true**)
/// #endif
public extension LogUtils {
    private static var isLoggingEnabled: Bool = false
    static func setLoggingEnabled(isEnabled: Bool) {
        self.isLoggingEnabled = isEnabled
    }
}
