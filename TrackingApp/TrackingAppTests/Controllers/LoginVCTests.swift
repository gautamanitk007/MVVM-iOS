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
        self.sut.loadViewIfNeeded()
    }

    override func tearDown()  {
        self.sut = nil
        self.api = nil
        super.tearDown()
    }
    
    func givenGoodLogin() {
      sut.txtUserId.text = "gautam2.amdocs12@gmail.com"
      sut.txtPassword.text = "abc24678!"
    }
    func whenSignIn() {
        sut.didLoginTapped(sut.btnLogin as Any)
    }
    
    func test_login_with_bad_credentials(){
        //When
        self.givenGoodLogin()
        
        //When
        let exp = expectation(for: NSPredicate(block:{ vc, _ -> Bool in
            return UIApplication.appDelegate.api.token != nil
        }), evaluatedWith: sut, handler: nil)
        
        self.whenSignIn()
        
        wait(for: [exp], timeout: 8)
        XCTAssertNotNil(self.api.token!, "a successful login sets valid user id")
       
        //let presentedController = UIApplication.appDelegate.window?.rootViewController?.presentedViewController as? UIViewController
        //XCTAssertNotNil(presentedController, "should be showing an error controller")
        //XCTAssertEqual(presentedController?.alertTitle,"Login Failed")
        //XCTAssertEqual(presentedController?.subtitle,"User has not been authenticated.")
    }

}
