//
//  UserResponse.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//

import Foundation


struct SCompany:Convertor{
    let name:String
    let bs:String
    let catchPhrase:String
}

struct SGeoCode:Convertor{
    let lat:String
    let lng:String
}

struct SAddress:Convertor{
    let street:String
    let suite:String
    let city:String
    let zipcode:String
    let geo:SGeoCode
}
struct SUser: Convertor {
    let userId: Int
    let name: String
    let email: String
    let username:String
    let phone:String
    let website:String
    let company:SCompany
    let address:SAddress
}

protocol Convertor:Decodable{
    func toDictionary() -> [String : Any]
}

extension Convertor{
    func toDictionary() -> [String : Any] {
        let reflect = Mirror(reflecting: self)
        let children = reflect.children
        let dictionary = toAnyHashable(elements: children)
        return dictionary
    }
    
    func toAnyHashable(elements: AnyCollection<Mirror.Child>) -> [String : Any] {
        var dictionary: [String : Any] = [:]
        for element in elements {
            if let key = element.label {
                
                if let collectionValidHashable = element.value as? [AnyHashable] {
                    dictionary[key] = collectionValidHashable
                }
                
                if let validHashable = element.value as? AnyHashable {
                    dictionary[key] = validHashable
                }
                
                if let convertor = element.value as? Convertor {
                    dictionary[key] = convertor.toDictionary()
                }
                
                if let convertorList = element.value as? [Convertor] {
                    dictionary[key] = convertorList.map({ e in
                        e.toDictionary()
                    })
                }
            }
        }
        return dictionary
    }
}
struct CreateUser:Convertor {
    let userId: Int
    let password: String
    let name: String
    let email: String
    let username:String
    let phone:String
    let website:String
    let company:SCompany
    let address:SAddress
    
}


