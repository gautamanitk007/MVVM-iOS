//
//  Login+CoreDataProperties.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//
//

import Foundation
import CoreData


extension Login {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Login> {
        return NSFetchRequest<Login>(entityName: "Login")
    }

    @NSManaged public var userId: String?
    @NSManaged public var password: String?
    @NSManaged public var name: String?
    @NSManaged public var token: String?

}

extension Login : Identifiable {

}
