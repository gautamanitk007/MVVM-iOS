//
//  AlertController.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation
import UIKit
extension UIViewController{
    func alert(title titleValue:String, message msg:String){
        let alert = UIAlertController(title:titleValue, message:msg, preferredStyle: UIAlertController.Style.alert)
        alert.modalPresentationStyle = .popover
        alert.addAction(UIAlertAction(title:Strings.ok.rawValue, style: .default) { _ in})
        present(alert, animated: true)
    }
    
    func showAlert(title: String,message: String? ) {
        let alertController = UIStoryboard(name: "UIHelpers", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.AlertPageID.rawValue) as! ErrorVC
        alertController.set(title: title, msg: message)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .flipHorizontal
        UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true)
    }
}

