//
//  UserInfo.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

struct UserInfo: Decodable {
    let _id: String
    let name: String
    let username: String
    let zipcode:String
    let lattitude:String
    let longitude:String
    let city:String
    let street:String
}
