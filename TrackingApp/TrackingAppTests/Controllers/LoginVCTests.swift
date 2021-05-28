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
    var api: MockAPI!
    override func setUp() {
        super.setUp()

        self.api = MockAPI(api: UIApplication.appDelegate.api)
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "login") as? LoginVC
        self.sut.loginViewModel = LoginViewModel(api: self.api)
        self.api.token = nil
        self.sut.loadViewIfNeeded()
    }

    override func tearDown()  {
        self.api.token = nil
        self.sut = nil
        self.api = nil
        super.tearDown()
    }
    
    func givenGoodLogin() {
        sut.txtUserId.text = "gautam12.amdocs12@gmail.com"
        sut.txtPassword.text = "abc24678!"
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
    
    func test_login_with_empty_userId_and_password(){
        //Given
        sut.txtUserId.text = ""
        sut.txtPassword.text = ""

        //When
        self.whenSignIn()

        //Then
        let presentedController = self.getTopController() as? ErrorVC
        presentedController?.didOkTapped(presentedController?.btnOk as Any)
        XCTAssertNotNil(presentedController)
        XCTAssertEqual(presentedController?.alertTitle,Strings.infoTitle.rawValue)
        XCTAssertEqual(presentedController?.alertMessage,Strings.userIdAndPassowrd.rawValue)
    }

    func test_login_with_invalid_userId_and_password_length(){
     
        //Given
        sut.txtUserId.text = "ssdd"
        sut.txtPassword.text = "abc"

        //When
        self.whenSignIn()

        //Then
        let presentedController = self.getTopController() as? ErrorVC
        presentedController?.didOkTapped(presentedController?.btnOk as Any)

        XCTAssertNotNil(presentedController)
        XCTAssertEqual(presentedController?.alertTitle,Strings.infoTitle.rawValue)
        XCTAssertEqual(presentedController?.alertMessage,Strings.userIdAndPassowrd.rawValue)

    }

    func test_login_with_valid_userId_length_and_invalid_password_length(){
        //Given
        sut.txtUserId.text = "gautam12.amdocs12@gmail.com"
        sut.txtPassword.text = "abc"

        //When
        self.whenSignIn()

        //Then
        let presentedController = self.getTopController() as? ErrorVC
        presentedController?.didOkTapped(presentedController?.btnOk as Any)
        XCTAssertNotNil(presentedController)
        XCTAssertEqual(presentedController?.alertTitle,Strings.infoTitle.rawValue)
        XCTAssertEqual(presentedController?.alertMessage,Strings.password.rawValue)
    }

    func test_login_with_valid_userId_and_password_length(){
        //Given
        self.givenGoodLogin()

        //When
        let exp = expectation(for: NSPredicate(block:{ [weak self]( _, _) -> Bool in
            guard let self = self else{return false}
            return self.api.token != nil
        }), evaluatedWith: sut, handler: nil)

        self.whenSignIn()

        //Then
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(self.api.token, "a successful login")

        let presentedController = self.getTopController() as? ErrorVC

        XCTAssertNil(presentedController)
        XCTAssertNil(presentedController?.alertTitle,"No Title in case of success")
        XCTAssertNil(presentedController?.alertMessage,"No message in case of success")
    }

}
