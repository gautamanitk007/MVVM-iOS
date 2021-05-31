//
//  UserViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation
import CoreData
class UserViewModel{
    let api:API!
    let token:String!
    let coOrdinator:Coordinator!
    init( api:API,token:String,coOrdinator:Coordinator) {
        self.api = api
        self.token = token
        self.coOrdinator = coOrdinator
    }
    
    func getAllUsers(_ params:[String:String],on completion:@escaping(Int,ApiError?)->()){
        
        let uResponse = Resource<[UserInfo]>(method:"Get",params:params, urlEndPoint: "users") { data in
            let uResponse = try? JSONDecoder().decode([UserInfo].self, from: data)
            return uResponse
        }
        self.api.load(resource: uResponse) {(result, error) in
            if let users = result{
                print(users)
                completion(ResponseCodes.success,error)
            }else{
                completion(error!.statusCode,error)
            }
        }
    }
    
    func logoutUser(_ params:[String:String],on completion:@escaping(Int,ApiError?)->()){
        let uResponse = Resource<Dictionary<String,Any>>(method:"POST",params:params, urlEndPoint: "users/logout") { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return (json as! Dictionary<String, Any>)
        }
        self.api.load(resource: uResponse) {(result, error) in
            Utility.saveInDefaults(value: "", forKey: Strings.TokenKey.rawValue)
            if let err = error, err.statusCode != ResponseCodes.success{
                completion(err.statusCode,err)
            }else{
                completion(ResponseCodes.success,error)
            }
        }
    }
    
}

