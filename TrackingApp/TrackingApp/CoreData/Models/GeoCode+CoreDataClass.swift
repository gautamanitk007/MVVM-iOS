//
//  GeoCode+CoreDataClass.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//
//

import Foundation
import CoreData

@objc(GeoCode)
public class GeoCode: NSManagedObject {
    static func insert(into mContext: NSManagedObjectContext,for response: SGeoCode) -> GeoCode{
        let geoCode : GeoCode = mContext.insertObject()
        geoCode.lattitude = response.lat
        geoCode.longitude = response.lng
        return geoCode
    }
}

extension GeoCode: Managed{
    @objc(defaultSortDescriptors) public static var defaultSortDescriptors : [NSSortDescriptor]{
        return [NSSortDescriptor(key: #keyPath(lattitude), ascending: false)]
    }
}
