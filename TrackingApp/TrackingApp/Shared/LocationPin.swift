//
//  LocationPin.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 1/6/21.
//

import Foundation
import MapKit

class LocationPin: NSObject, MKAnnotation {
    let title: String?
    let street: String?
    let suite : String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?,suite:String?,street: String?,coordinate: CLLocationCoordinate2D) {
        self.title = title?.capitalized
        self.suite = suite
        self.street = street
        self.coordinate = coordinate
        super.init()
    }
    var subtitle: String?{
        return self.suite! + "," + self.street!
    }
}
