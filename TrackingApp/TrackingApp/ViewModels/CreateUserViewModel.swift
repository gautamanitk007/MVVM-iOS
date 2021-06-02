//
//  CreateUserViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 2/6/21.
//

import Foundation

class CreateUserViewModel{
    let api:API!
    let token:String!
    var userModel:UserModel
    let cordinator:Coordinator!
    init(api:API,token:String,cordinator:Coordinator, userModel:UserModel) {
        self.token = token
        self.api = api
        self.userModel = userModel
        self.cordinator = cordinator
    }
    
    func saveUser(on completion:@escaping(Int,ApiError?)->()){
        let uId:Int = Int.random(in: 1..<500)*10000
        
        let user =  CreateUser(userId: uId,password:userModel.password, name: userModel.name, email: userModel.email, username: userModel.username,phone: userModel.phone,website: userModel.website,
                           company: SCompany(name: userModel.companyName, bs: userModel.companyBS, catchPhrase: userModel.catchPhrase),
                           address: SAddress(street: userModel.street, suite: userModel.suite, city: userModel.city, zipcode: userModel.zipcode,
                                             geo:SGeoCode(lat: userModel.lattitude, lng: userModel.longitude)))
        let params = user.toDictionary()
    
        let userResource = Resource<SUser>(method:"POST",token:self.token,params:params, urlEndPoint: "users") { data in
            let userResponse = try? JSONDecoder().decode(SUser.self, from: data)
            return userResponse
        }

        self.api.load(resource: userResource) { [weak self](result, error) in
            guard let self = self else{ return }
            if let userResponse = result{
                DispatchQueue.main.async {
                    self.insert(userResponse)
                }
                completion(ResponseCodes.success,error)
            }else{
                completion(error!.statusCode,error)
            }
        }
        
    }
}
//MARK:API to insert in table
extension CreateUserViewModel{
    private func insert(_ response: SUser){
        let user = User.insert(into: self.cordinator.viewContext, for: response)
        let _ = user.managedObjectContext?.saveOrRollback()
    }
}
//MARK:public api
extension CreateUserViewModel{
    func checkUserCredentials(on completion:@escaping(Bool,String?)->()){
        let uName = self.userModel.username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pwd = self.userModel.password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let vName = uName.count >= AllowedLength.userNameLength.rawValue
        let vPassword = pwd.count >= AllowedLength.userPasswordLength.rawValue
        
        if vName == true {
            if vPassword == true {
                completion(true,nil)
            }else{
                completion(false,Strings.password.rawValue)
            }
        }else{
            if vPassword == true {
                completion(true,Strings.userName.rawValue)
            }else{
                completion(false,Strings.userNameAndPassword.rawValue)
            }
        }
    }
}
