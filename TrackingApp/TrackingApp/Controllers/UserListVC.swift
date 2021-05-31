//
//  UserListVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit

class UserListVC: UIViewController {
    var userViewModel:UserViewModel!
    var userId:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        let logoutButton = UIBarButtonItem(title: "Logout", style:.plain, target: self, action: #selector(UserListVC.logoutTapped))
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    @objc func logoutTapped(){
        self.userViewModel.logoutUser(["token":self.userViewModel.token]) { [weak self ](statusCode, error) in
            guard let self = self else{return}
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}
