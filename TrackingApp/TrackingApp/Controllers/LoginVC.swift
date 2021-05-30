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
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    var countryListViewModel:CountryListViewModel!
    var loginViewModel:LoginViewModel!
    var isRemember:Bool?{
        didSet{
            self.btnRemember.isSelected = isRemember!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.txtUserId.delegate = self
        self.txtPassword.delegate = self
        self.btnCountry.setImage(image: UIImage(named: "drop.png")!, renderMode: .alwaysOriginal, semantics: .forceRightToLeft, alignment: .right, left: 0, right: 60)
        self.btnRemember.setImage(image: UIImage(named: "circle_unchecked.png")!, renderMode: .alwaysOriginal, semantics: .forceLeftToRight, alignment: .left, left: 12, right: 0)
       
        
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
        self.isRemember = Utility.getBoolValueFromDefaults(forKey:Strings.RememberKey.rawValue)
    }
    @IBAction func didRememberTapped(_ sender: Any) {
        self.loginViewModel.updateRemember(!self.btnRemember.isSelected)
        self.isRemember = Utility.getBoolValueFromDefaults(forKey:Strings.RememberKey.rawValue)
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
                    let (isExist,value) = Utility.getToken(forKey: Strings.TokenKey.rawValue)
                    if isExist{
                        DispatchQueue.main.async {[weak self] in
                            guard let self = self else {return}
                            self.startLogin()
                        }
                    }else{
                        self.loginViewModel.loginUser(["userId":uId!,"password":pwd!,"token":value]) { (_, error )in
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
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.ShowUsersSegue.rawValue {
            guard let userListVC = segue.destination as? UserListVC else {fatalError("UserListVC not found")}
            userListVC.userViewModel = UserViewModel(api: self.loginViewModel.api, coOrdinator: self.loginViewModel.coOrdinator)
            userListVC.userId = self.txtUserId.text
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
            if let obj = login,let token = obj.token, token.count > 0{
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    if let _ = self.navigationController?.topViewController as? UserListVC{
                        Log.debug("TopVC")
                    }else{
                        self.startLogin()
                    }
                    self.isRemember = Utility.getBoolValueFromDefaults(forKey:Strings.RememberKey.rawValue)
                }
            }else{
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    self.isRemember = Utility.getBoolValueFromDefaults(forKey:Strings.RememberKey.rawValue)
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
    func startLogin(){
        self.stopActivity()
        self.performSegue(withIdentifier: SegueIdentifier.ShowUsersSegue.rawValue, sender: nil)
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
