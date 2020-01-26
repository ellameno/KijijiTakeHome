//
//  Logger.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation

// Adaptation of third party source - SwiftyBeaver logger
open class Logger {
    private static let timeZone = "EST"
    private static var minLogLevel: Int = 0
    private static var minBusgnagLevel: Int = 3

    private static let formatter = DateFormatter()
    
    public enum Level: Int {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
    }
    
    /// log something generally unimportant (lowest priority)
    open class func verbose(_ message: @autoclosure () -> Any,
                            _ file: String = #file,
                            _ function: String = #function,
                            line: Int = #line,
                            context: Any? = nil) {
        #if swift(>=5)
        custom(level: .verbose, message: message(), file: file, function: function, line: line, context: context)
        #else
        custom(level: .verbose, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// log something which help during debugging (low priority)
    open class func debug(_ message: @autoclosure () -> Any,
                          _ file: String = #file,
                          _ function: String = #function,
                          line: Int = #line,
                          context: Any? = nil) {
        #if swift(>=5)
        custom(level: .debug, message: message(), file: file, function: function, line: line, context: context)
        #else
        custom(level: .debug, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// log something which you are really interested but which is not an issue or error (normal priority)
    open class func info(_ message: @autoclosure () -> Any,
                         _ file: String = #file,
                         _ function: String = #function,
                         line: Int = #line,
                         context: Any? = nil) {
        #if swift(>=5)
        custom(level: .info, message: message(), file: file, function: function, line: line, context: context)
        #else
        custom(level: .info, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// log something which may cause big trouble soon (high priority)
    open class func warning(_ message: @autoclosure () -> Any,
                            _ file: String = #file,
                            _ function: String = #function,
                            line: Int = #line,
                            context: Any? = nil) {
        #if swift(>=5)
        custom(level: .warning, message: message(), file: file, function: function, line: line, context: context)
        #else
        custom(level: .warning, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// log something which will keep you awake at night (highest priority)
    open class func error(_ message: @autoclosure () -> Any,
                          _ file: String = #file,
                          _ function: String = #function,
                          line: Int = #line,
                          context: Any? = nil) {
        #if swift(>=5)
        custom(level: .error, message: message(), file: file, function: function, line: line, context: context)
        #else
        custom(level: .error, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// custom logging to manually adjust values, should just be used by other frameworks
    public class func custom(level: Level, message: @autoclosure () -> Any,
                             file: String = #file,
                             function: String = #function,
                             line: Int = #line,
                             context: Any? = nil) {
        #if swift(>=5)
        dispatch_send(level: level, message: message(),
                      file: file, function: function, line: line, context: context)
        #else
        dispatch_send(level: level, message: message,
                      file: file, function: function, line: line, context: context)
        #endif
    }

    class func dispatch_send(level: Level,
                             message: @autoclosure () -> Any,
                             file: String,
                             function: String,
                             line: Int,
                             context: Any?) {
        
        var resolvedMessage: String = ""
        #if swift(>=5)
        resolvedMessage = "\(message())"
        #else
        // resolvedMessage = "\(message)"
        #endif
        let functionText: String = String(function.split(separator: "(").first ?? "")
        
        guard level.rawValue >= minLogLevel else {
            return
        }
      
        let filename = (file.components(separatedBy: "/").last ?? file).replacingOccurrences(of: ".swift", with: "")
        
        print(
            level.symbol,
            level.name.uppercased(),
            filename,
            "\(functionText):\(line)",
            "--", resolvedMessage)
    }
    
    class var formattedDateString: String {
        if !timeZone.isEmpty {
            formatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        formatter.dateFormat = "HH:mm:ss"
        let dateStr = formatter.string(from: Date())
        return dateStr
    }
    
}

extension Logger.Level {
    var symbol: String {
        switch self {
        case .verbose:
            return "💜"
        case .debug:
            return "💚"
        case .info:
            return "💙"
        case .warning:
            return "💛"
        case .error:
            return "❤️"
        }
    }
    
    var name: String {
        switch self {
        case .verbose: return "verbose"
        case .debug: return "debug"
        case .info: return "info"
        case .warning: return "warning"
        case .error: return "error"
        }
    }
}
