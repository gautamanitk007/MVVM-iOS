//
//  UserResponse.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//

import Foundation

struct SCompany:Decodable,Encodable{
    let name:String
    let bs:String
    let catchPhrase:String
}

struct SGeoCode:Decodable,Encodable{
    let lat:String
    let lng:String
}

struct SAddress:Decodable,Encodable{
    let street:String
    let suite:String
    let city:String
    let zipcode:String
    let geo:SGeoCode
}
struct SUser: Decodable,Encodable {
    let userId: Int
    let name: String
    let email: String
    let username:String
    let phone:String
    let website:String
    let company:SCompany
    let address:SAddress
}
