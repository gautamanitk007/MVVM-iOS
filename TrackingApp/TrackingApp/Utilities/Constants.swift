//
//  Constants.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

enum AllowedLength:Int{
    case nameLength = 2
    case userNameLength = 5
    case userPasswordLength = 7
}
enum SegueIdentifier:String {
    case CreateUserSegue = "createUserSegue"
    case ShowUsersSegue = "showUserSegue"
    case DropdownSegue = "dropDownSegue"
   
}
enum Identifier:String {
    case GeneralCellIdentifier = "GeneralCelli"
    case UserCellIdentifier = "UserCelli"
}

enum StoryboardID:String {
    case LoginPageID = "loginPageID"
    case UserListPageID = "userListPageID"
    case CreateUserPageID = "createUserPageID"
    case DropdownPageID = "dropdownPageID"
    case AlertPageID = "alertPageID"
}

struct ResponseCodes {
    static let success = 200
    static let duplicate = 202
    static let badrequest = 400
    static let token_invalid = 401
    static let login_auth_failed = 403
    static let object_not_found = 404
    static let network_timeout = -1001
    static let server_notReachable = -1003
    static let server_problem = 500
    static let server_down = 503
    
}

enum Keys:String{
    case Remember = "isRemember"
    case Token = "tokenKey"
    case UserName = "username"
    case Password = "password"
    case PinView = "pinViewKey"
}

enum NotificatioString: String{
    case AutoLogin = "autoLogin"
}
