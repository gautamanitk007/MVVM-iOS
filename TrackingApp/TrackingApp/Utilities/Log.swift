//
//  Log.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation


enum LogType : String{
    case error = "‼️"
    case debug = "💬"
  
}
class Log{
    static var dateFormat = "yyyy-MM-dd hh:mm:ss"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    fileprivate class func sourceFileName(for path:String) -> String{
        let fileComponents = path.components(separatedBy: "/")
        return fileComponents.isEmpty ? "" : fileComponents.last!
    }
    class func error(_ object : Any , fName : String = #file,line : Int = #line, funcName : String = #function){
        guard AppDelegate.configuration.debug else { return }
        print("\(Date().toString()) \(LogType.error.rawValue)[\(sourceFileName(for: fName))]:\(line) \(funcName) -> \(object)")
    }
    class func debug(_ object : Any , fName : String = #file,line : Int = #line, funcName : String = #function){
        guard AppDelegate.configuration.debug else { return }
        print("\(Date().toString()) \(LogType.debug.rawValue)[\(sourceFileName(for: fName))]:\(line) \(funcName) -> \(object)")
    }
}

extension Date{
    func toString() -> String {
        return Log.dateFormatter.string(from: self)
    }
}
