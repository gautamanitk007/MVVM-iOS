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
    @IBOutlet weak var btnLogin: RoundedButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    var countryListViewModel:CountryListViewModel!
    var loginViewModel:LoginViewModel!
    var isRemember:Bool?{
        didSet{
            self.btnRemember.isSelected = isRemember!
            self.txtUserName.text = self.loginViewModel.username
            self.txtPassword.text = self.loginViewModel.password
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.txtUserName.delegate = self
        self.txtPassword.delegate = self
        self.btnCountry.setImage(image: UIImage(named: "drop.png")!, renderMode: .alwaysOriginal, semantics: .forceRightToLeft, alignment: .right, left: 0, right: 60)
        self.btnRemember.setImage(image: UIImage(named: "circle_unchecked.png")!, renderMode: .alwaysOriginal, semantics: .forceLeftToRight, alignment: .left, left: 12, right: 0)
       
        
        self.stopActivity()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.autoLogin), name:NSNotification.Name(NotificatioString.AutoLogin.rawValue), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func didRememberTapped(_ sender: Any) {
        self.loginViewModel.updateLogin(isRemember:!self.btnRemember.isSelected,userName: self.txtUserName.text!,password: self.txtPassword.text!)
        self.isRemember = self.loginViewModel.isRemember
    }
    @IBAction func didCountryTapped(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifier.DropdownSegue.rawValue , sender: nil)
    }

    @IBAction func didLoginTapped(_ sender: Any) {
        
        self.loginViewModel.checkCredentialsPreconditions(for: self.txtUserName.text!, and: self.txtPassword.text!) { [weak self] (allOk,uName,pwd, error )in
            guard let self = self else {return}
            if allOk{
                self.startActivity()
                self.loginViewModel.loginUser(["username":uName!,"password":pwd!]) { (_, error )in
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {return}
                        self.stopActivity()
                        if error?.statusCode == ResponseCodes.success{
                            self.showUserPage()
                        }else{
                            self.showAlert(title: Strings.infoTitle.rawValue,message:error!.message!)
                        }
                    }
                }
            }else{
                self.showAlert(title: Strings.infoTitle.rawValue,message:error!)
            }
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.ShowUsersSegue.rawValue {
            guard let userListVC = segue.destination as? UserListVC else {fatalError("UserListVC not found")}
            let (uViewModel,locPinViewModel) = sender as! (UserViewModel,LocationPinViewModel)
            userListVC.userViewModel = uViewModel
            userListVC.locationPinViewModel = locPinViewModel
            userListVC.loginedUser = self.loginViewModel.loginedUser
        }else if segue.identifier == SegueIdentifier.DropdownSegue.rawValue{
            guard let dropDown = segue.destination as? DropdownVC else {fatalError("DropdownVC not found")}
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
        self.loginViewModel.fetchLogin(for: self.loginViewModel.username) { _ in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                if self.loginViewModel.isTokenExist{
                    if let _ = self.navigationController?.topViewController as? UserListVC{
                        Log.debug("TopVC")
                    }else{
                        self.startLogin()
                    }
                }
                self.isRemember = self.loginViewModel.isRemember
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
    func startLogin(){
        self.stopActivity()
        self.showUserPage()
    }
    func showUserPage(){
        self.startActivity()
        let userViewModel = UserViewModel(api: self.loginViewModel.api, token: self.loginViewModel.token ,coOrdinator: self.loginViewModel.coOrdinator)
        userViewModel.getAllUsers() {(status, error) in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else{return}
                self.stopActivity()
                if status == ResponseCodes.success{
                    let locationPinViewModel = LocationPinViewModel(users: User.fetch(in: self.loginViewModel.coOrdinator.viewContext))
                    self.performSegue(withIdentifier: SegueIdentifier.ShowUsersSegue.rawValue, sender: (userViewModel,locationPinViewModel))
                }else{
                    self.showAlert(title: Strings.infoTitle.rawValue, message: error!.message)
                }
            }
        }
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
