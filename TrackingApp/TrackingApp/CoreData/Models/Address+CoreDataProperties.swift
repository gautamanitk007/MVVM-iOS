//
//  Address+CoreDataProperties.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var geo: GeoCode?
    @NSManaged public var relToAddress: User?

}

extension Address : Identifiable {

}
