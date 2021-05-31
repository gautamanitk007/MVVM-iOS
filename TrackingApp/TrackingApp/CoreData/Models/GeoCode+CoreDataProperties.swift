//
//  GeoCode+CoreDataProperties.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//
//

import Foundation
import CoreData


extension GeoCode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeoCode> {
        return NSFetchRequest<GeoCode>(entityName: "GeoCode")
    }

    @NSManaged public var lattitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var relToAddress: Address?

}

extension GeoCode : Identifiable {

}
