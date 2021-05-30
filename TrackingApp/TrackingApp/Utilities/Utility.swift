//
//  Utility.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation

class Utility: NSObject {
    class func saveBoolInDefaults(_ value: Bool, forKey: String){
        let appDefaults = UserDefaults.standard
        appDefaults.setValue(value, forKey: forKey)
        appDefaults.synchronize()
    }
    class func getBoolValueFromDefaults(_ forKey: String) -> Bool{
        let appDefaults = UserDefaults.standard
        if let value = appDefaults.value(forKey: forKey){
            return value as! Bool
        }else{
            return false
        }
    }
}
