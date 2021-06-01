//
//  CreateUserVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit

class CreateUserVC: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    
    
    @IBOutlet weak var txtSuite: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    
    @IBOutlet weak var btnSearch: RoundedButton!
    @IBOutlet weak var lblLattitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var txtCompName: UITextField!
    @IBOutlet weak var txtCompPhrase: UITextField!
    @IBOutlet weak var txtCompBs: UITextField!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    var createUserViewModel:CreateUserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.setup()
        self.initialise()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUserVC.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUserVC.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    @IBAction func didCancelUserTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didSaveUserTapped(){
        self.view.endEditing(true)
        
//        let sUser =  SUser(userId: self.createUserViewModel.userId,password:self.txtPassword.text!, name: self.txtUser.text!, email: self.txtEmail.text!, username: self.txtUserName.text!,
//                           phone: self.txtPhone.text!,website: self.createUserViewModel.website,
//                           company: SCompany(name: self.txtCompName.text!, bs: self.txtCompBs.text!, catchPhrase: self.txtCompPhrase.text!),
//                           address: SAddress(street: self.txtStreet.text!, suite: self.txtSuite.text!, city: self.txtCity.text!, zipcode: self.txtZipcode.text!, geo: SGeoCode(lat: "34", lng: "341")))
        
        
        self.dismiss(animated: true, completion: nil)
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
    @IBAction func didSearchTapped(_ sender: Any) {
       
    }
}
//MARK:- UITextFieldDelegate
extension CreateUserVC:UITextFieldDelegate{
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

extension CreateUserVC{
    func setup(){
        self.txtUser.delegate = self
        self.txtUserName.delegate = self
        self.txtPassword.delegate = self
        
        self.txtEmail.delegate = self
        self.txtPhone.delegate = self
        self.txtStreet.delegate = self
        
        self.txtSuite.delegate = self
        self.txtCity.delegate = self
        self.txtZipcode.delegate = self
        
        self.txtCompName.delegate = self
        self.txtCompPhrase.delegate = self
        self.txtCompBs.delegate = self
    }
    func initialise(){
        self.txtPassword.text = self.createUserViewModel.password
        self.txtEmail.text = self.createUserViewModel.email
        self.txtPhone.text = self.createUserViewModel.phone
        
        self.txtCompName.text = self.createUserViewModel.companyName
        self.txtCompPhrase.text = self.createUserViewModel.catchPhrase
        self.txtCompBs.text = self.createUserViewModel.companyBS
        
    }
}
