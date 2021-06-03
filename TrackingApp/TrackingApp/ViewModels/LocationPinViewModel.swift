//
//  LocationPinViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 1/6/21.
//

import Foundation
import CoreData

class LocationPinViewModel {
    var users:[User]
    var locPins:[LocationPin]?
    init(users:[User]) {
        self.users = users
        self.locPins = [LocationPin]()
    }
    
    func generateLocationPins(){
        for user in self.users {
            let pin = createPins(for: user)
            self.locPins?.append(pin)
        }
    }
    
    func createPins(for user:User)->LocationPin{
        let cordinate = CLLocationCoordinate2D(latitude:user.address!.geo!.lattitude!.doubleValue(), longitude: user.address!.geo!.longitude!.doubleValue())
        return LocationPin(title: user.username,suite:user.address?.suite, street: user.address?.street, coordinate: cordinate)
    }
    
    func reGenerateLocation(for users:[User]){
        self.users.removeAll()
        self.users = users
        self.generateLocationPins()
    }
   
}
