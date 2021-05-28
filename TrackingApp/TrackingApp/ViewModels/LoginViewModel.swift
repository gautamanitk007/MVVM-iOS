//
//  LoginViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

class LoginViewModel{
    
    let api:API!
    
    init( api:API) {
        self.api = api
    }
    
    func loginUser(_ params:[String:String],on completion:@escaping(Int,ApiError?)->()){
        
        let loginResource = Resource<LoginResponse>(method:"POST",params:params, urlEndPoint: "users/login") { data in
            let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)
            print(loginResponse)
            return loginResponse
        }
        
        self.api.load(resource: loginResource) { [weak self](result, error) in
            guard let self = self else{ return }
            if let loginResponse = result{
                self.api.token = loginResponse.token
                completion(ResponseCodes.success,error)
            }else{
                completion(error!.statusCode,error)
            }
        }
    }
    
}

extension LoginViewModel{
    func checkCredentialsPreconditions(for userId:String,and password:String,on completion:@escaping(Bool,String?)->()){
        let vId = userId.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count >= AllowedLength.userIdLength.rawValue
        let vPassword = password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count >= AllowedLength.userPasswordLength.rawValue
        
        if vId == true && vPassword == true {
            completion(true,nil)
        }else if vId == true && vPassword == false{
            completion(false,Strings.userId.rawValue)
        }else if vPassword == true && vId == false{
            completion(false,Strings.password.rawValue)
        }else{
            completion(false,Strings.password.rawValue)
        }
    }
}
