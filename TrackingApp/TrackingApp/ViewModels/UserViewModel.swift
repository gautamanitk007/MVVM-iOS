//
//  UserViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

class UserViewModel{
    let api:API!
    init(api:API) {
        self.api = api
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
}

