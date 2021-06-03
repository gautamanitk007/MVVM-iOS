//
//  MKMapView+Extension.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 3/6/21.
//

import Foundation
import MapKit
extension MKMapView {
    
    func centerToLocation(_ location: CLLocation,regionRadius: CLLocationDistance = 4000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: regionRadius,longitudinalMeters: regionRadius)
        let myRegion = self.regionThatFits(coordinateRegion)
        //set region for only valid coordinates
        if !(myRegion.span.latitudeDelta.isNaN || myRegion.span.longitudeDelta.isNaN) {
            self.setRegion(myRegion, animated: true)
        }
    }
}
