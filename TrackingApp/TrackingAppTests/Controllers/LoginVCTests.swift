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
    
    func test_login_with_good_credentials(){
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
       
        let presentedController = UIApplication.appDelegate.window?.rootViewController?.presentedViewController as? ErrorVC
    
        XCTAssertNil(presentedController)
        XCTAssertNil(presentedController?.alertTitle,"No Title in case of success")
        XCTAssertNil(presentedController?.alertMessage,"No message in case of success")
    }

}
