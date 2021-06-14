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
    @IBOutlet weak var btnLogin: RoundedButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    var countryListViewModel:CountryListViewModel!
    var loginViewModel:LoginViewModel!
    var locationService:LocationService?
    var isRemember:Bool?{
        didSet{
            self.btnRemember.isSelected = isRemember!
            self.txtUserName.text = self.loginViewModel.username
            self.txtPassword.text = self.loginViewModel.password
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setupLocalizedValue()
        
        self.txtUserName.delegate = self
        self.txtPassword.delegate = self
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
    @IBAction func didLoginTapped(_ sender: Any) {
        self.loginViewModel.validateCredentials(for: self.txtUserName.text!, and: self.txtPassword.text!) { [weak self] (allOk,params, error )in
            guard let self = self else {return}
            if allOk{
                self.startActivity()
                self.loginViewModel.loginUser(params!) { (_, error )in
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {return}
                        self.stopActivity()
                        if error?.statusCode == ResponseCodes.success{
                            self.pushUserPage()
                        }else{
                            self.showAlert(title: NSLocalizedString("Information_Title",comment: ""),message:error!.message!)
                        }
                    }
                }
            }else{
                self.showAlert(title: NSLocalizedString("Information_Title",comment: ""),message:error!)
            }
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.ShowUsersSegue.rawValue {
            guard let userListVC = segue.destination as? UserListVC else {fatalError("UserListVC not found")}
            userListVC.userListViewModel =  UserListViewModel(api: self.loginViewModel.api, token: self.loginViewModel.token, coOrdinator: self.loginViewModel.coOrdinator)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.baseScrollView.contentInset = contentInsets
        self.baseScrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        self.baseScrollView.contentInset = .zero
        self.baseScrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func autoLogin(){
        self.loginViewModel.fetchLogin(for: self.loginViewModel.username) { loginUser in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                
                self.isRemember = self.loginViewModel.isRemember
                self.locationService?.requestLocationAuthorization()
                
                if self.loginViewModel.isTokenExist{
                    if let _ = self.navigationController?.topViewController as? LoginVC{
                        self.pushUserPage()
                    }
                }
            }
        }
    }
}

//MARK:- utility
extension LoginVC{
    fileprivate func startActivity(){
        if self.activityView.isAnimating == false {
            self.activityView.startAnimating()
        }
    }
    fileprivate func stopActivity(){
        if self.activityView.isAnimating == true {
            self.activityView.stopAnimating()
        }
    }
    fileprivate func pushUserPage(){
        self.performSegue(withIdentifier: SegueIdentifier.ShowUsersSegue.rawValue, sender:nil)
    }
    fileprivate func setupLocalizedValue(){
        self.txtUserName.placeholder = NSLocalizedString("Login_Text_Field_Placeholder",comment: "")
        self.txtPassword.placeholder = NSLocalizedString("Password_Text_Field_Placeholder",comment: "")
        
        self.btnLogin.setTitle(NSLocalizedString("Login_Button_Title",comment: ""), for: .normal)
        self.btnRemember.setTitle(NSLocalizedString("Remember_Login_Text",comment: ""), for: .normal)
  
        self.btnRemember.setImage(image: UIImage(named: NSLocalizedString("Un_Check_Button_Image_Name",comment: ""))!, renderMode: .alwaysOriginal,state:.normal, semantics: .forceLeftToRight, alignment: .left, left: 12, right: 0)
        self.btnRemember.setImage(image: UIImage(named: NSLocalizedString("Check_Button_Image_Name",comment: ""))!, renderMode: .alwaysOriginal,state:.selected, semantics: .forceLeftToRight, alignment: .left, left: 12, right: 0)
        
    }
}
//MARK:- UITextFieldDelegate
extension LoginVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            self.txtPassword.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return false
    }
}
