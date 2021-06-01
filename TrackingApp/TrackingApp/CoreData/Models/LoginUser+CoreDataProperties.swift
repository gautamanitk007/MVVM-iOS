//
//  LoginUser+CoreDataProperties.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 1/6/21.
//
//

import Foundation
import CoreData


extension LoginUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginUser> {
        return NSFetchRequest<LoginUser>(entityName: "LoginUser")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var token: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var lattitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var city: String?
    @NSManaged public var street: String?
    @NSManaged public var username: String?

}

extension LoginUser : Identifiable {

}
