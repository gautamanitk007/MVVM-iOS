//
//  Company+CoreDataProperties.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var bs: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var name: String?
    @NSManaged public var relToCompany: User?

}

extension Company : Identifiable {

}
