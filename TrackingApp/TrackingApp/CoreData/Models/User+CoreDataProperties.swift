//
//  User+CoreDataProperties.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var userId: Int64
    @NSManaged public var username: String?
    @NSManaged public var website: String?
    @NSManaged public var address: Address?
    @NSManaged public var company: Company?

}

extension User : Identifiable {

}
