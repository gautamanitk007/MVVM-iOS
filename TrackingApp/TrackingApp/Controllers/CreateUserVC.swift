//
//  CreateUserVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit
protocol CreateUserDelegate:AnyObject {
    func didUserAdded(_ user:User)
}
class CreateUserVC: UIViewController {

    @IBOutlet weak var txtPassword: BindingTextField!{
        didSet{
            txtPassword.bind{self.createUserViewModel.userModel.password = $0}
        }
    }
    @IBOutlet weak var txtUserName: BindingTextField!{
        didSet{
            txtUserName.bind{self.createUserViewModel.userModel.username = $0}
        }
    }
    @IBOutlet weak var txtUser: BindingTextField!{
        didSet{
            txtUser.bind{self.createUserViewModel.userModel.name = $0}
        }
    }
    
    @IBOutlet weak var txtEmail: BindingTextField!{
        didSet{
            txtEmail.bind{self.createUserViewModel.userModel.email = $0}
        }
    }
    @IBOutlet weak var txtPhone: BindingTextField!{
        didSet{
            txtPhone.bind{self.createUserViewModel.userModel.phone = $0}
        }
    }
    @IBOutlet weak var txtStreet: BindingTextField!{
        didSet{
            txtStreet.bind{self.createUserViewModel.userModel.street = $0}
        }
    }
    
    @IBOutlet weak var txtSuite: BindingTextField!{
        didSet{
            txtSuite.bind{self.createUserViewModel.userModel.suite = $0}
        }
    }
    @IBOutlet weak var txtCity: BindingTextField!{
        didSet{
            txtCity.bind{self.createUserViewModel.userModel.city = $0}
        }
    }
    
    @IBOutlet weak var txtCompName: BindingTextField!{
        didSet{
            txtCompName.bind{self.createUserViewModel.userModel.companyName = $0}
        }
    }
    @IBOutlet weak var txtCompPhrase: BindingTextField!{
        didSet{
            txtCompPhrase.bind{self.createUserViewModel.userModel.catchPhrase = $0}
        }
    }
    @IBOutlet weak var txtCompBs: BindingTextField!{
        didSet{
            txtCompBs.bind{self.createUserViewModel.userModel.companyBS = $0}
        }
    }
    
    @IBOutlet weak var txtLattitude: BindingTextField!{
        didSet{
            txtLattitude.bind{self.createUserViewModel.userModel.lattitude = $0}
        }
    }
    @IBOutlet weak var txtLongitude: BindingTextField!{
        didSet{
            txtLongitude.bind{self.createUserViewModel.userModel.longitude = $0}
        }
    }
    @IBOutlet weak var txtZipcode: BindingTextField!{
        didSet{
            txtZipcode.bind{self.createUserViewModel.userModel.zipcode = $0}
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var createUserViewModel:CreateUserViewModel!
    weak var delegate:CreateUserDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = NSLocalizedString("Page_Create_User_Title",comment: "")
        self.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Button_Save_Title",comment: "")
      
        self.stopActivity()
        self.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUserVC.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUserVC.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        self.createUserViewModel = nil
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    @IBAction func didSaveUserTapped(){
        self.view.endEditing(true)
        self.createUserViewModel.checkUserCredentials{[weak self]( _, error) in
            guard let self = self else{return}
            if error == nil{
                self.startActivity()
                self.createUserViewModel.saveUser {[weak self](statusCode,user, error) in
                    guard let self = self else{return}
                    self.stopActivity()
                    if statusCode == ResponseCodes.success{
                        self.delegate?.didUserAdded(user!)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.alert(title: Strings.infoTitle.rawValue, message: error!.message!)
                    }
                }
            }else{
                self.alert(title: Strings.infoTitle.rawValue, message: error!)
            }
        }
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 30, right: 0)
        self.baseScrollView.contentInset = contentInsets
        self.baseScrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        self.baseScrollView.contentInset = .zero
        self.baseScrollView.scrollIndicatorInsets = .zero
    }
}
//MARK:- UITextFieldDelegate
extension CreateUserVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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
}

//MARK:- utility
extension CreateUserVC{
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
}
