//
//  LoginVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation
import UIKit
class CellClass: UITableViewCell {
    
}
class LoginVC: UIViewController {
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet var contentView:UIView!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var btnCountry: RoundedButton!
    @IBOutlet weak var btnCreateUser: RoundedButton!
    @IBOutlet weak var btnLogin: RoundedButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    var countryListViewModel:CountryListViewModel!
    var loginViewModel:LoginViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.txtUserId.delegate = self
        self.txtPassword.delegate = self
        self.btnCountry.rightImage(image: UIImage(named: "drop.png")!, renderMode:.alwaysOriginal)
        self.stopActivity()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.autoLogin), name:NSNotification.Name(NotificatioString.AutoLogin.rawValue), object: nil)
        self.txtUserId.text = "gautamkkr1"//"gautam12.amdocs12@gmail.com"
        self.txtPassword.text = "abc1324678!"//"abc24678!"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    @IBAction func didRememberTapped(_ sender: Any) {
        self.btnRemember.isSelected = !self.btnRemember.isSelected
    }
    @IBAction func didCountryTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "dropDownSegue", sender: nil)
    }

    @IBAction func didLoginTapped(_ sender: Any) {
        self.loginViewModel.checkCredentialsPreconditions(for: self.txtUserId.text!, and: self.txtPassword.text!) { [weak self] (allOk,uId,pwd, error )in
            guard let self = self else {return}
            if allOk{
                self.startActivity()
                self.loginViewModel.fetchLogin {[weak self]  login in
                    guard let self = self else {return}
                    if let obj = login{
                        self.startLogin(obj)
                    }else{
                        self.loginViewModel.loginUser(["userId":uId!,"password":pwd!,"token":""]) { (_, error )in
                            DispatchQueue.main.async {[weak self] in
                                guard let self = self else {return}
                                self.stopActivity()
                                if error?.statusCode == ResponseCodes.success{
                                    self.performSegue(withIdentifier: SegueIdentifier.ShowUsersSegue.rawValue, sender: nil)
                                }else{
                                    self.showAlert(title: Strings.infoTitle.rawValue,message:error!.message!)
                                }
                            }
                        }
                    }
                }
                
            }else{
                self.showAlert(title: Strings.infoTitle.rawValue,message:error!)
            }
        }
    }
    @IBAction func didCreateUserTapped(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifier.CreateUserSegue.rawValue, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.ShowUsersSegue.rawValue {
            //guard let homeVC = segue.destination as? UserListVC else {fatalError("UserListVC not found")}
          
        }else if segue.identifier == SegueIdentifier.CreateUserSegue.rawValue{
            //guard let navController = segue.destination as? UINavigationController else {fatalError("NavigationController not found")}
            //guard let registrationVC = navController.viewControllers.first as? CreateUserVC else {fatalError("CreateUserVC not found")}
        }else if segue.identifier == "dropDownSegue"{
            guard let dropDown = segue.destination as? DropdownVC else {fatalError("UserListVC not found")}
            dropDown.delegate = self
            dropDown.countryListViewModel = self.countryListViewModel
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = ((notification.userInfo! as NSDictionary).object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! CGRect).size
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            var frame:CGRect = self.view.frame
            frame.origin.y = -keyboardSize.height/4
            self.view.frame =  frame
        })
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            var frame:CGRect = self.view.frame
            frame.origin.y = 0
            self.view.frame =  frame
        })
    }
    
    @objc func autoLogin(){
        self.loginViewModel.fetchLogin {[weak self]  login in
            guard let self = self else {return}
            if let obj = login{
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    if let _ = self.navigationController?.topViewController as? UserListVC{
                        Log.debug("TopVC")
                    }else{
                        self.startLogin(obj)
                    }
                }
            }
        }
    }
}

//MARK:- utility
extension LoginVC{
    func startActivity(){
        if self.activityView.isAnimating == false {
            self.activityView.startAnimating()
        }
    }
    func stopActivity(){
        if self.activityView.isAnimating == true {
            self.activityView.stopAnimating()
        }
    }
    func startLogin(_ login:Login){
        self.stopActivity()
        self.performSegue(withIdentifier: SegueIdentifier.ShowUsersSegue.rawValue, sender: login)
    }
}
//MARK:- UITextFieldDelegate
extension LoginVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            self.txtPassword.becomeFirstResponder()
            return true
        }else{
            return textField.resignFirstResponder()
        }
    }
}

//MARK:- DropdownDelegate
extension LoginVC : DropdownDelegate{
    func didSelected(viewModel vm: CountryViewModel) {
        self.btnCountry.setTitle(vm.countryName, for: .normal)
    }
}
