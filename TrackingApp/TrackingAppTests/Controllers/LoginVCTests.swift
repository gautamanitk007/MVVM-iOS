//
//  LoginVCTests.swift
//  TrackingAppTests
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import XCTest
@testable import TrackingApp
class LoginVCTests: XCTestCase {

    var sut:LoginVC!
    var api: API!
    var loginViewModel:LoginViewModel!
    var cordinator:Coordinator!
    override func setUp() {
        super.setUp()
        Utility.resetUserDefault()
        //Utility.resetLocalDB(self.cordinator.viewContext)
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: StoryboardID.LoginPageID.rawValue) as? LoginVC
        sut.loginViewModel = nil
        sut.countryListViewModel = nil
        
        self.cordinator = UIApplication.appDelegate.coordinator
        self.api = UIApplication.appDelegate.api
        self.loginViewModel = LoginViewModel(api: self.api,coOrdinator: self.cordinator)
        
        self.sut.loginViewModel = self.loginViewModel
        self.sut.countryListViewModel =  CountryListViewModel(countryList: AppDelegate.configuration.countryList)
        
        self.sut.loadViewIfNeeded()
    }

    override func tearDown()  {
        Utility.resetUserDefault()
        self.api = nil
        self.cordinator = nil
        self.sut = nil
        self.loginViewModel = nil
        
        super.tearDown()
    }
    
    func test_login_with_empty_userId_and_password(){
        //Given
        sut.txtUserName.text = ""
        sut.txtPassword.text = ""

        //When
        let exp = expectation(for: NSPredicate(block:{ vc, _ -> Bool in
            let presentedController = self.getTopController() as? ErrorVC
            return presentedController != nil && presentedController!.alertTitle ==  NSLocalizedString("Information_Title",comment: "") && presentedController!.alertMessage ==  NSLocalizedString("UserName_Password_Length_Message",comment: "")
        }), evaluatedWith: sut, handler: nil)

        self.whenSignIn()

        //Then
        wait(for: [exp], timeout: 2)
        let presentedController = self.getTopController() as? ErrorVC
        presentedController?.didOkTapped(presentedController?.btnOk as Any)
        XCTAssertNotNil(presentedController)
        XCTAssertEqual(presentedController?.alertTitle,NSLocalizedString("Information_Title",comment: ""))
        XCTAssertEqual(presentedController?.alertMessage, NSLocalizedString("UserName_Password_Length_Message",comment: ""))
    }

    func test_login_with_invalid_userId_and_password_length(){

        //Given
        sut.txtUserName.text = "ssdd"
        sut.txtPassword.text = "abc"

        //When
        let exp = expectation(for: NSPredicate(block:{ vc, _ -> Bool in
            let presentedController = self.getTopController() as? ErrorVC
            return presentedController != nil && presentedController!.alertTitle == NSLocalizedString("Information_Title",comment: "") && presentedController!.alertMessage ==  NSLocalizedString("UserName_Password_Length_Message",comment: "")
        }), evaluatedWith: sut, handler: nil)

        self.whenSignIn()

        //Then
        wait(for: [exp], timeout: 2)
        let presentedController = self.getTopController() as? ErrorVC
        presentedController?.didOkTapped(presentedController?.btnOk as Any)

        XCTAssertNotNil(presentedController)
        XCTAssertEqual(presentedController?.alertTitle,NSLocalizedString("Information_Title",comment: ""))
        XCTAssertEqual(presentedController?.alertMessage, NSLocalizedString("UserName_Password_Length_Message",comment: ""))

    }
    func test_login_with_valid_userId_length_and_invalid_password_length(){
        //Given
        sut.txtUserName.text = "singh007"
        sut.txtPassword.text = "abc"

        //When
        let exp = expectation(for: NSPredicate(block:{ vc, _ -> Bool in
            let presentedController = self.getTopController() as? ErrorVC
            return presentedController != nil && presentedController!.alertTitle == NSLocalizedString("Information_Title",comment: "") && presentedController!.alertMessage == NSLocalizedString("Password_Min_Length_Message",comment: "")
        }), evaluatedWith: sut, handler: nil)

        self.whenSignIn()

        //Then
        wait(for: [exp], timeout: 2)
        let presentedController = self.getTopController() as? ErrorVC
        presentedController?.didOkTapped(presentedController?.btnOk as Any)
        XCTAssertNotNil(presentedController)
        XCTAssertEqual(presentedController?.alertTitle,NSLocalizedString("Information_Title",comment: ""))
        XCTAssertEqual(presentedController?.alertMessage,NSLocalizedString("Password_Min_Length_Message",comment: ""))
    }
    func test_login_with_valid_userId_and_password_length(){
        //Given
        self.givenGoodLogin()
        Utility.resetUserDefault()
        //When
        let exp = expectation(for: NSPredicate(block:{ [weak self]( _, _) -> Bool in
            guard let self = self else{return false}
            let presentedController = self.getTopController() as? ErrorVC
            return self.loginViewModel.token.count > 0 && presentedController == nil
        }), evaluatedWith: sut, handler: nil)

        self.whenSignIn()

        //Then
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(self.loginViewModel.token.count > 0, "a successful login")

        let presentedController = self.getTopController() as? ErrorVC
        XCTAssertNil(presentedController)
        XCTAssertNil(presentedController?.alertTitle,"No Title in case of success")
        XCTAssertNil(presentedController?.alertMessage,"No message in case of success")
    }

}

extension LoginVCTests{
    func givenGoodLogin() {
        sut.txtUserName.text = "mehto007"
        sut.txtPassword.text = "admin123!"
    }
    func whenSignIn() {
        sut.didLoginTapped(sut.btnLogin as Any)
    }
    
    func getTopController()-> UIViewController?{
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
