//
//  UserListViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 3/6/21.
//

import Foundation
import CoreData
class UserListViewModel:CommonModel{
    var token:String!
    var locationPinViewModel:LocationPinViewModel?
    
    lazy var userFetchResultController:NSFetchedResultsController<User>? = {
        let request = User.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coOrdinator.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    init( api:API,token:String,coOrdinator:Coordinator) {
        super.init(api: api, coOrdinator: coOrdinator)
        self.token = token
        self.locationPinViewModel = LocationPinViewModel(users: User.fetch(in: self.coOrdinator.viewContext))
    }
    deinit {
        self.token = nil
        self.locationPinViewModel = nil
        Log.debug("Clean")
    }
    
}

extension UserListViewModel{
    func getAllUsers(on completion:@escaping(Int,ApiError?)->()){
        let resource = Resource<[SUser]>(method:"GET",token:self.token,params:[:], urlEndPoint: "users") { data in
            let uResponse = try? JSONDecoder().decode([SUser].self, from: data)
            return uResponse
        }
        self.api.load(resource: resource) {[weak self](result, error) in
            guard let self = self else{return}
            if let userList = result{
                DispatchQueue.main.async {
                    self.cleanUsersData()
                    self.insert(userList)
                    self.locationPinViewModel?.reGenerateLocation(for: User.fetch(in: self.coOrdinator.viewContext))
                    completion(ResponseCodes.success,error)
                }
            }else{
                completion(error!.statusCode,error)
            }
        }
    }
    
    func logoutUser(_ params:[String:Any],on completion:@escaping(Int,ApiError?)->()){
        let uResponse = Resource<Dictionary<String,Any>>(method:"POST",token:self.token,params:params, urlEndPoint: "users/logout") { data in
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

//MARK: public api
extension UserListViewModel{
    func createLocationPin(for user:User) -> LocationPin{
        let pin =  self.locationPinViewModel?.createPins(for: user)
        self.locationPinViewModel?.locPins?.append(pin!)
        return pin!
    }
}


//MARK:API to insert in table
extension UserListViewModel{
    private func insert(_ userList:[SUser]){
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
