//
//  Constants.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

enum AllowedLength:Int{
    case userNameLength = 2
    case userIdLength = 5
    case userPasswordLength = 4
}
enum SegueIdentifier:String {
    case CreateUserSegue = "createUserSegue"
    case ShowUsersSegue = "showUserSegue"
   
}

struct ResponseCodes {
    static let success = 200
    static let badrequest = 400
    static let token_invalid = 401
    static let login_auth_failed = 403
    static let object_not_found = 404
    static let network_timeout = -1001
    static let server_notReachable = -1003
    static let server_problem = 500
    static let server_down = 503
    
}

enum Strings:String {
    case infoTitle = "Information"
    case warningTitle = "Warning"
    case delegateNilMessage = "Check your delegate"
    case ok = "OK"
    case cancel = "Cancel"
    case save = "Save"
    case error = "Error!"
    case userName = "User Name length should be more than 3 characters"
    case password = "Password length should be more than 4 characters"
    case userId = "User Id length should be more than 5 characters"
    case userIdAndPassowrd = "Please check userid and password length"
  
}
