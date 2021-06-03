//
//  Utility.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation
import CoreData
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
    class func saveInDefaults(value str: String, forKey key: String){
        let appDefaults = UserDefaults.standard
        appDefaults.setValue(str, forKey: key)
        appDefaults.synchronize()
    }
    class func getValue(forKey key: String) -> String{
        let appDefaults = UserDefaults.standard
        if let value = appDefaults.value(forKey: key) as? String {
            return value
        }else{
            return ""
        }
    }
    class func resetUserDefault(){
        Utility.saveInDefaults(value: "", forKey: Keys.UserName.rawValue)
        Utility.saveInDefaults(value: "", forKey: Keys.Password.rawValue)
        Utility.saveInDefaults(value: "", forKey: Keys.Token.rawValue)
        Utility.saveBoolInDefaults( false, forKey: Keys.Remember.rawValue)
    }
    class func resetLocalDB(_ context: NSManagedObjectContext){
        if let login = LoginUser.findOrFetch(in: context, matching: LoginUser.defaultPredicate){
            login.managedObjectContext?.delete(login)
        }
        let users = User.fetch(in: context)
        for user in users {
            user.managedObjectContext?.delete(user)
        }
        let _ = context.saveOrRollback()
    }
}
