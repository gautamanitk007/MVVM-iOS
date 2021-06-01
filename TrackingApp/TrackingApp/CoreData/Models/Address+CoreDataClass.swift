//
//  Address+CoreDataClass.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//
//

import Foundation
import CoreData

@objc(Address)
public class Address: NSManagedObject {
    static func insert(into mContext: NSManagedObjectContext,for response: SAddress) -> Address{
        let address : Address = mContext.insertObject()
        address.street = response.street
        address.suite = response.suite
        address.city =  response.city
        address.zipcode = response.zipcode
        address.geo = GeoCode.insert(into: mContext, for: response.geo)
        return address
    }
}

extension Address: Managed{
    @objc(defaultSortDescriptors) public static var defaultSortDescriptors : [NSSortDescriptor]{
        return [NSSortDescriptor(key: #keyPath(street), ascending: false)]
    }
}
