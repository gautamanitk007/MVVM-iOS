//
//  UserResponse.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//

import Foundation

struct ResCompany:Decodable{
    let name:String
    let bs:String
    let catchPhrase:String
}

struct ResGeoCode:Decodable{
    let lat:String
    let lng:String
}

struct ResAddress:Decodable{
    let street:String
    let suite:String
    let city:String
    let zipcode:String
    let geo:ResGeoCode
}
struct UserResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let username:String
    let phone:String
    let website:String
    let company:ResCompany
    let address:ResAddress
}
