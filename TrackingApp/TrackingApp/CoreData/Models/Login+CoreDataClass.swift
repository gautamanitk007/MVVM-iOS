//
//  Login+CoreDataClass.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//
//

import Foundation
import CoreData

@objc(Login)
public class Login: NSManagedObject {
    static func insert(into mContext: NSManagedObjectContext,for reponse: LoginResponse,password pwd:String) -> Login{
        let login : Login = mContext.insertObject()
        login.name = reponse.user.name
        login.userId = reponse.user.userId
        login.password = pwd
        login.token = reponse.token
        return login
    }
}

extension Login: Managed{
    @objc(defaultSortDescriptors) public static var defaultSortDescriptors : [NSSortDescriptor]{
        return [NSSortDescriptor(key: #keyPath(name), ascending: false)]
    }
}
