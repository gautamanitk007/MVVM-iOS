//
//  Validator.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 5/6/21.
//

import UIKit

class Validator: NSObject {

    class func checkCredentails(_ userName:Bool,_ password:Bool)->(Bool,String?){
        var validCredential = false
        var errorMessage:String?
        if userName == true {
            if password == true {
                validCredential = true
                errorMessage = nil
            }else{
                validCredential = false
                errorMessage = NSLocalizedString("Password_Min_Length_Message",comment: "")
            }
        }else{
            if password == true {
                validCredential = false
                errorMessage = NSLocalizedString("UserName_Min_Length_Message",comment: "")
            }else{
                validCredential = false
                errorMessage = NSLocalizedString("UserName_Password_Length_Message",comment: "")
            }
        }
        return (validCredential,errorMessage)
    }
}
