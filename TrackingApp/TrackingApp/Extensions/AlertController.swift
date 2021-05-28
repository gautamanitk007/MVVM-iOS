//
//  AlertController.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation
import UIKit
extension UIViewController{
    func showAlert(title titleValue:String, message msg:String){
        let alert = UIAlertController(title:titleValue, message:msg, preferredStyle: UIAlertController.Style.alert)
        alert.modalPresentationStyle = .popover
        alert.addAction(UIAlertAction(title:Strings.ok.rawValue, style: .default) { _ in})
        present(alert, animated: true)
    }
    func  alert(title titleValue:String,on save:@escaping(String?) -> ()) {
        let alert = UIAlertController(title: titleValue, message: "", preferredStyle:.alert)
        alert.addTextField { textField in
            weak var txtField = textField
            txtField?.resignFirstResponder()
        }
        weak var alert_ = alert
        alert.addAction(UIAlertAction(title: Strings.cancel.rawValue, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Strings.save.rawValue, style: .default, handler: { action in
            if let alertTxtFields = alert_?.textFields{
                if let topupTxtField = alertTxtFields.first,let topupText = topupTxtField.text{
                    if !topupText.isEmpty {
                        save(topupText)
                    }
                }
            }
        }))
        present(alert_!, animated: true)
    }
}
