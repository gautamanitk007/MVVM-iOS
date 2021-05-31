//
//  CreateUserVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit

class CreateUserVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
     
    }
    @IBAction func didCancelUserTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didSaveUserTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}
