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
        return Utility.getBoolValueFromDefaults(forKey:Keys.Remember.rawValue)
    }
    var username:String{
        return "singh007"//Utility.getValue(forKey:Strings.UserId.rawValue)
    }
    var password:String{
        return "admin123!"//Utility.getValue(forKey:Strings.Password.rawValue)
    }
    var token:String{
        return Utility.getValue(forKey:Keys.Token.rawValue)
    }
    var isTokenExist:Bool{
        let tkn = Utility.getValue(forKey:Keys.Token.rawValue)
        if tkn.count > 0 {
            return true
        }
        return false
    }
    var loginedUser:LoginUser?{
        return LoginUser.findOrFetch(in: self.coOrdinator.syncContext, matching: NSPredicate(format: "%K == %@", #keyPath(LoginUser.username),self.username))
    }
}

extension LoginViewModel{
    func checkCredentialsPreconditions(for userName:String,and password:String,on completion:@escaping(Bool,String?,String?,String?)->()){
        let uName = userName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pwd = password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let vName = uName.count >= AllowedLength.userIdLength.rawValue
        let vPassword = pwd.count >= AllowedLength.userPasswordLength.rawValue
        
        self.updateLogin(isRemember: self.isRemember, userName: uName, password: pwd)
        
        if vName == true {
            if vPassword == true {
                completion(true,uName,pwd,nil)
            }else{
                completion(false,uName,pwd,Strings.password.rawValue)
            }
        }else{
            if vPassword == true {
                completion(true,uName,pwd,Strings.userName.rawValue)
            }else{
                completion(false,uName,pwd,Strings.userNameAndPassword.rawValue)
            }
        }
    }
    func updateLogin(isRemember reMember:Bool,userName uName:String,password pwd:String){
        if reMember {
            Utility.saveInDefaults(value: uName, forKey: Keys.UserName.rawValue)
            Utility.saveInDefaults(value: pwd, forKey: Keys.Password.rawValue)
        }else{
            Utility.saveInDefaults(value: "", forKey: Keys.UserName.rawValue)
            Utility.saveInDefaults(value: "", forKey: Keys.Password.rawValue)
        }
        
        Utility.saveBoolInDefaults(reMember, forKey: Keys.Remember.rawValue)
    }
    
}

extension LoginViewModel{
    func insert(_ object:LoginResponse,_ password:String){
        Log.debug(object.token)
        Utility.saveInDefaults(value: object.token, forKey: Keys.Token.rawValue)
        self.coOrdinator.perform {[weak self] in
            guard let self = self else{ return}
            if let loginObj = LoginUser.findOrFetch(in: self.coOrdinator.syncContext, matching: NSPredicate(format: "%K == %@", #keyPath(LoginUser.username),object.user.username)){
                loginObj.token = object.token
                let _ = loginObj.managedObjectContext?.saveOrRollback()
            }else{
                let _ =  LoginUser.insert(into: self.coOrdinator.syncContext, for: object, password: password)
            }
            let _ =  self.coOrdinator.syncContext.saveOrRollback()
        }
    }
    func fetchLogin(for username:String,on completion:@escaping(LoginUser?)->()){
        self.coOrdinator.perform {[weak self] in
            guard let self = self else{ return}
            let loginObj = LoginUser.findOrFetch(in: self.coOrdinator.syncContext, matching: NSPredicate(format: "%K == %@", #keyPath(LoginUser.username),username))
            completion(loginObj)
        }
    }
}
