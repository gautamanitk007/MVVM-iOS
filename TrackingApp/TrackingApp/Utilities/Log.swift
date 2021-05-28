//
//  Log.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

class Log {
  static func fatal(_ message: String) {
    print("[FATAL]- " + message)
  }
  
  static func debug(_ message: String) {
    guard AppDelegate.configuration.debug else { return }
    print("[DEBUG]- " + message)
  }
  
  static func error(_ error: Error) {
    print("[ERROR]- " + error.localizedDescription)
  }
}
