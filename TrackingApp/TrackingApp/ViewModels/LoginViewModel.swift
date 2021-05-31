//
//  LoginViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation
import CoreData
class LoginViewModel{
    let api:API!
    let coOrdinator:Coordinator!
    init( api:API,coOrdinator:Coordinator) {
        self.api = api
        self.coOrdinator = coOrdinator
    }
    
    func loginUser(_ params:[String:String],on completion:@escaping(Int,ApiError?)->()){
        
        let loginResource = Resource<LoginResponse>(method:"POST",params:params, urlEndPoint: "users/login") { data in
            let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)
            return loginResponse
        }
        
        self.api.load(resource: loginResource) { [weak self](result, error) in
            guard let self = self else{ return }
            if let loginResponse = result{
                self.insert(loginResponse, params["password"]!)
                completion(ResponseCodes.success,error)
            }else{
                completion(error!.statusCode,error)
            }
        }
    }
    
}

extension LoginViewModel{
    var isRemember:Bool{
        return Utility.getBoolValueFromDefaults(forKey:Strings.RememberKey.rawValue)
    }
    var userId:String{
        return Utility.getValue(forKey:Strings.UserId.rawValue)
    }
    var password:String{
        return Utility.getValue(forKey:Strings.Password.rawValue)
    }
    var token:String{
        return Utility.getValue(forKey:Strings.TokenKey.rawValue)
    }
}

extension LoginViewModel{
    func checkCredentialsPreconditions(for userId:String,and password:String,on completion:@escaping(Bool,String?,String?,String?)->()){
        let uId = userId.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pwd = password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let vId = uId.count >= AllowedLength.userIdLength.rawValue
        let vPassword = pwd.count >= AllowedLength.userPasswordLength.rawValue
        
        self.updateLogin(isRemember: self.isRemember, userId: uId, password: pwd)
        
        if vId == false && vPassword == false {
            completion(false,nil,nil,Strings.userIdAndPassowrd.rawValue)
        }else if vId == true && vPassword == false{
            completion(false,nil,nil,Strings.password.rawValue)
        }else if vId == false && vPassword == true {
            completion(false,nil,nil,Strings.userId.rawValue)
        }else{
            completion(true,uId,pwd,nil)
        }
    }
    func updateLogin(isRemember reMember:Bool,userId uId:String,password pwd:String){
        if reMember {
            Utility.saveInDefaults(value: uId, forKey: Strings.UserId.rawValue)
            Utility.saveInDefaults(value: pwd, forKey: Strings.Password.rawValue)
        }else{
            Utility.saveInDefaults(value: "", forKey: Strings.UserId.rawValue)
            Utility.saveInDefaults(value: "", forKey: Strings.Password.rawValue)
        }
        
        Utility.saveBoolInDefaults(reMember, forKey: Strings.RememberKey.rawValue)
    }
    
}




extension LoginViewModel{

    func insert(_ object:LoginResponse,_ password:String){
        Log.debug(object.token)
        Utility.saveInDefaults(value: object.token, forKey: Strings.TokenKey.rawValue)
        self.coOrdinator.perform {[weak self] in
            guard let self = self else{ return}
            if let loginObj = Login.findOrFetch(in: self.coOrdinator.syncContext, matching: NSPredicate(format: "%K == %@", #keyPath(Login.userId),object.user.userId)){
                loginObj.token = object.token
                let _ = loginObj.managedObjectContext?.saveOrRollback()
            }else{
                let _ =  Login.insert(into: self.coOrdinator.syncContext, for: object, password: password)
            }
            let _ =  self.coOrdinator.syncContext.saveOrRollback()
        }
    }
    func fetchLogin(on completion:@escaping(Login?)->()){
        self.coOrdinator.perform {[weak self] in
            guard let self = self else{ return}
            let loginObj = Login.findOrFetch(in: self.coOrdinator.syncContext, matching: Login.defaultPredicate)
            completion(loginObj)
        }
    }

    
}
