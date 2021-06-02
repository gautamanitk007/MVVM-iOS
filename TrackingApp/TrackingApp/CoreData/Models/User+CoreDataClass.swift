//
//  User+CoreDataClass.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    static func insert(into mContext: NSManagedObjectContext,for response: SUser) -> User{
        let user : User = mContext.insertObject()
        user.name = response.name
        user.username = response.username
        user.userId = Int64(response.userId)
        user.email = response.email
        user.website = response.website
        user.phone = response.phone
        user.address = Address.insert(into: mContext, for: response.address)
        user.company = Company.insert(into: mContext, for: response.company)
        return user
    }
    
}
extension User: Managed{
    @objc(defaultSortDescriptors) public static var defaultSortDescriptors : [NSSortDescriptor]{
        return [NSSortDescriptor(key: #keyPath(username), ascending: true)]
    }
}
