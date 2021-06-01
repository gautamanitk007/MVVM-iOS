//
//  LoginUser+CoreDataClass.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 1/6/21.
//
//

import Foundation
import CoreData

@objc(LoginUser)
public class LoginUser: NSManagedObject {
    static func insert(into mContext: NSManagedObjectContext,for reponse: LoginResponse,password pwd:String) -> LoginUser{
        let login : LoginUser = mContext.insertObject()
        login.name = reponse.user.name
        login.username = reponse.user.username
        login.password = pwd
        login.token = reponse.token
        login.zipcode = reponse.user.zipcode
        login.lattitude = reponse.user.lattitude
        login.longitude = reponse.user.longitude
        login.city = reponse.user.city
        login.street = reponse.user.street
        return login
    }
}
extension LoginUser: Managed{
    @objc(defaultSortDescriptors) public static var defaultSortDescriptors : [NSSortDescriptor]{
        return [NSSortDescriptor(key: #keyPath(name), ascending: false)]
    }
}
