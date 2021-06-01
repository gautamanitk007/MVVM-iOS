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
        
        let uResponse = Resource<[UserResponse]>(method:"GET",params:params, urlEndPoint: "users") { data in
            let uResponse = try? JSONDecoder().decode([UserResponse].self, from: data)
            return uResponse
        }
        self.api.load(resource: uResponse) {[weak self](result, error) in
            guard let self = self else{return}
            if let userList = result{
                DispatchQueue.main.async {
                    self.cleanUsersData()
                    self.insert(userList)
                }
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
            Utility.saveInDefaults(value: "", forKey: Keys.Token.rawValue)
            if let err = error, err.statusCode != ResponseCodes.success{
                completion(err.statusCode,err)
            }else{
                completion(ResponseCodes.success,error)
            }
        }
    }
    
}

//MARK:API to insert in table
extension UserViewModel{
    private func insert(_ userList:[UserResponse]){
        for response in userList {
            let user = User.insert(into: self.coOrdinator.viewContext, for: response)
            let _ = user.managedObjectContext?.saveOrRollback()
        }
    }
    fileprivate func cleanUsersData(){
        let users = User.fetch(in: self.coOrdinator.viewContext)
        for user in users {
            user.managedObjectContext?.delete(user)
        }
        let _ = self.coOrdinator.viewContext.saveOrRollback()
    }
}

