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
            return loginResponse
        }
        
        self.api.load(resource: loginResource) { [weak self](result, error) in
            guard let self = self else{ return }
            if let loginResponse = result{
                print(loginResponse)
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
        
        if vId == false && vPassword == false {
            completion(false,Strings.userIdAndPassowrd.rawValue)
        }else if vId == true && vPassword == false{
            completion(false,Strings.password.rawValue)
        }else if vId == false && vPassword == true {
            completion(false,Strings.userId.rawValue)
        }else{
            completion(true,nil)
        }
    }
}
