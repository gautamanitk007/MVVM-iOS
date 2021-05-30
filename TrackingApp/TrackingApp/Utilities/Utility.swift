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
    class func getBoolValueFromDefaults(forKey key: String) -> Bool{
        let appDefaults = UserDefaults.standard
        if let value = appDefaults.value(forKey: key){
            return value as! Bool
        }else{
            return false
        }
    }
    class func isTokenExist(forKey key: String) -> Bool{
        let appDefaults = UserDefaults.standard
        if let value = appDefaults.value(forKey: key) as? String {
            if value.count > 0 {
                return true
            }
            return false
        }else{
            return false
        }
    }
    class func getToken(forKey key: String) -> (Bool,String){
        let appDefaults = UserDefaults.standard
        if let value = appDefaults.value(forKey: key) as? String {
            if value.count > 0 {
                return (true,value)
            }
            return (false,"")
        }else{
            return (false,"")
        }
    }
    class func saveTokenInDefaults(value token: String, forKey key: String){
        let appDefaults = UserDefaults.standard
        appDefaults.setValue(token, forKey: key)
        appDefaults.synchronize()
    }
}
