//
//  ErrorVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit

class ErrorVC: UIViewController {
    @IBOutlet weak var btnOk: RoundedButton!
    @IBOutlet weak var alertView: RoundedView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    var alertTitle: String = ""
    var alertMessage: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alertView.layer.cornerRadius = 12
        self.alertView.layer.masksToBounds = true
        updateTitles()
    }
    
    @IBAction func didOkTapped(_ sender: Any) {
      self.dismiss(animated: true)
    }
    func set(title: String, msg: String?) {
      self.alertTitle = title
      self.alertMessage = msg
    }
}

extension ErrorVC{
    fileprivate func updateTitles() {
        lblTitle.text = self.alertTitle
        if let msg = self.alertMessage{
            self.lblMessage.text = msg
        }else{
            self.lblMessage.isHidden = true
        }
    }
}
