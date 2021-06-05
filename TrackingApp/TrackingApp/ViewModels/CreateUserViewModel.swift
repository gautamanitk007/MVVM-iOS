//
//  CreateUserViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 2/6/21.
//

import Foundation

class CreateUserViewModel:CommonModel{
    let token:String!
    var userModel:UserModel
    init(api:API,token:String,cordinator:Coordinator, userModel:UserModel) {
        self.token = token
        self.userModel = userModel
        super.init(api: api, coOrdinator: cordinator)
    }
    
    func saveUser(on completion:@escaping(Int,User?,ApiError?)->()){
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
                    let user = self.save(userResponse)
                    completion(ResponseCodes.success,user,error)
                }
               
            }else{
                completion(error!.statusCode,nil,error)
            }
        }
        
    }
}
//MARK:API to insert in table
extension CreateUserViewModel{
    private func save(_ response: SUser) -> User{
        let user = User.insert(into: self.coOrdinator.viewContext, for: response)
        let _ = user.managedObjectContext?.saveOrRollback()
        return user
    }
}
//MARK:public api
extension CreateUserViewModel{
    func checkUserCredentials(on completion:@escaping(Bool,String?)->()){
        let uName = self.userModel.username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pwd = self.userModel.password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let vName = uName.count >= AllowedLength.userNameLength.rawValue
        let vPassword = pwd.count >= AllowedLength.userPasswordLength.rawValue
        
        let (allOk,errorMessage) = Validator.checkCredentails(vName, vPassword)
        if allOk {
            completion(true,nil)
        }else{
            completion(false,errorMessage)
        }
    }
}
