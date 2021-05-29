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
  
    var loginViewModel:LoginViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.txtUserId.delegate = self
        self.txtPassword.delegate = self
        self.btnCountry.rightImage(image: UIImage(named: "drop.png")!, renderMode:.alwaysOriginal)
        self.stopActivity()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.txtUserId.text = "gautam12.amdocs12@gmail.com"
        self.txtPassword.text = "abc24678!"
    }
    @IBAction func didRememberTapped(_ sender: Any) {
        self.btnRemember.isSelected = !self.btnRemember.isSelected
    }
    @IBAction func didCountryTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "dropDownSegue", sender: nil)
    }

    @IBAction func didLoginTapped(_ sender: Any) {
        self.loginViewModel.checkCredentialsPreconditions(for: self.txtUserId.text!, and: self.txtPassword.text!) { [weak self] (validationSuccess, error )in
            guard let self = self else {return}
            if validationSuccess{
                self.startActivity()
                self.loginViewModel.loginUser(["email":self.txtUserId.text!,"password":self.txtPassword.text!]) { [weak self] (_, error )in
                    guard let self = self else {return}
                    self.stopActivity()
                    if error?.statusCode == ResponseCodes.success{
                        self.performSegue(withIdentifier: SegueIdentifier.ShowUsersSegue.rawValue, sender: nil)
                    }else{
                        self.showAlert(title: Strings.infoTitle.rawValue,message:error!.message!)
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
            let cListViewModel = CountryListViewModel()
            cListViewModel.addCountryViewModel(CountryViewModel(countryName: "Singapore", code: "SG"))
            cListViewModel.addCountryViewModel(CountryViewModel(countryName: "Malaysia", code: "MY"))
            cListViewModel.addCountryViewModel(CountryViewModel(countryName: "Hong Kong", code: "HK"))
            cListViewModel.addCountryViewModel(CountryViewModel(countryName: "Indonesia", code: "IND"))
            cListViewModel.addCountryViewModel(CountryViewModel(countryName: "Australia", code: "AU"))
            cListViewModel.addCountryViewModel(CountryViewModel(countryName: "Thailand", code: "TH"))
            dropDown.countryListViewModel = cListViewModel
    
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
