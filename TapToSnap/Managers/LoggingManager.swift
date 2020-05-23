//
//  LoggingManager.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit
import AFDateHelper

class LoggingManager: NSObject {
    static func LogUseless(_ message: Any?, file: String = #file, line: Int = #line) {
        #if DEBUG
//            print("\(self.stringForLog(message, file: file, line: line))")
        #else
            
        #endif
    }
    
    static func Log(_ message: Any?, file: String = #file, line: Int = #line) {
        let logString = "🗣 \(self.stringForLog(message, file: file, line: line))"
        #if DEBUG
            print(logString)
        #else
            
        #endif
    }
    
    static func LogWarning(_ message: Any?, file: String = #file, line: Int = #line) {
        let logString = "😎 \(self.stringForLog(message, file: file, line: line))"
        #if DEBUG
            print(logString)
        #else
            
        #endif
    }
    
    static func LogError(_ message: Any?, file: String = #file, line: Int = #line) {
        let logString = "🆘 \(self.stringForLog(message, file: file, line: line))"
        #if DEBUG
            print(logString)
        #else
            
        #endif
    }
    
    static func stringForLog(_ message: Any?, file: String, line: Int) -> String {
        guard var className = NSURL(fileURLWithPath: file).lastPathComponent else { return "Invalid File Path" }
        className = className.replacingOccurrences(of: ".swift", with: "")
        return "\(Date().toString(format: .custom("mm:ss.SSS"))): \(message ?? "") | \(className):\(line)"
    }
}
