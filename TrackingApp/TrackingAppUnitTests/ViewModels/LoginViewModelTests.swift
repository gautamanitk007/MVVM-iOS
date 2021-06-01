//
//  LoginViewModelTests.swift
//  TrackingAppUnitTests
//
//  Created by Gautam Kumar Singh on 31/5/21.
//

import XCTest
import CoreData
@testable import TrackingApp
class LoginViewModelTests: XCTestCase {
    var sut : LoginViewModel!
    override func setUp() {
        super.setUp()
        self.sut = LoginViewModel(api: UIApplication.appDelegate.api, coOrdinator: UIApplication.appDelegate.coordinator)
    }

    override func tearDown()  {
        Utility.resetUserDefault()
        self.sut = nil
        super.tearDown()
    }
    func test_empty_username_and_password(){
        defer{
            self.waitForExpectations(timeout: 0)
        }
        //Given
        let username = ""
        let password = ""
        let expectation = self.expectation(description: "Completion wasn't called")
        //When
        self.sut.checkCredentialsPreconditions(for: username, and: password) { success, uname, pwd, error in
            //Then
            XCTAssertFalse(success)
            XCTAssertEqual(uname,"")
            XCTAssertEqual(pwd,"")
            XCTAssertEqual(error, Strings.userNameAndPassword.rawValue)
            expectation.fulfill()
        }
    }
    func test_in_username_and_password(){
        defer{
            self.waitForExpectations(timeout: 0)
        }
        //Given
        let username = "abc"
        let password = "pqr"
        let expectation = self.expectation(description: "Completion wasn't called")
        //When
        self.sut.checkCredentialsPreconditions(for: username, and: password) { success, uname, pwd, error in
            //Then
            XCTAssertFalse(success)
            XCTAssertEqual(uname,username)
            XCTAssertEqual(pwd,password)
            XCTAssertEqual(error, Strings.userNameAndPassword.rawValue)
            expectation.fulfill()
        }
    }
    func test_valid_username_and_in_password(){
        defer{
            self.waitForExpectations(timeout: 0)
        }
        //Given
        let username = "gautamkkr1"
        let password = "pqr"
        let expectation = self.expectation(description: "Completion wasn't called")
        //When
        self.sut.checkCredentialsPreconditions(for: username, and: password) { success, uId, pwd, error in
            //Then
            XCTAssertFalse(success)
            XCTAssertEqual(uId,username)
            XCTAssertEqual(pwd,password)
            XCTAssertEqual(error, Strings.password.rawValue)
            expectation.fulfill()
        }
    }
    func test_valid_username_and_password(){
        defer{
            self.waitForExpectations(timeout: 0)
        }
        //Given
        let username = "gautamkkr1"
        let password = "pqrwertwee"
        let expectation = self.expectation(description: "Completion wasn't called")
        //When
        self.sut.checkCredentialsPreconditions(for: username, and: password) { success, uId, pwd, error in
            //Then
            XCTAssertTrue(success)
            XCTAssertEqual(uId,username)
            XCTAssertEqual(pwd,password)
            XCTAssertNil(error)
            expectation.fulfill()
        }
    }
    func test_in_valid_username_and_password_and_authenticate_user(){
        defer{
            self.waitForExpectations(timeout: 10)
        }
        //Given
        let username = "gautamkkr12"
        let password = "abc1324678!"
        let expectation = self.expectation(description: "Completion wasn't called")
        //When
        
        self.sut.loginUser(["username":username,"password":password,"token":""]) { statusCode, error in
            //Then
            XCTAssertEqual(statusCode,ResponseCodes.badrequest)
            XCTAssertEqual(error!.message,"bad request")
            expectation.fulfill()
        }
    }
    func test_valid_username_password_authenticate_user(){
        defer{
            self.waitForExpectations(timeout: 10)
        }
        //Given
        let username = "singh007"
        let password = "admin123!"
        let expectation = self.expectation(description: "Completion wasn't called")
        //When
        
        self.sut.loginUser(["username":username,"password":password,"token":""]) { statusCode, error in
            //Then
            XCTAssertEqual(statusCode,ResponseCodes.success)
            XCTAssertEqual(error!.message,"no error")
            expectation.fulfill()
        }
    }
    func test_valid_username_password_authenticated_user_and_loginTable(){
        defer{
            self.waitForExpectations(timeout: 10)
        }
        //Given
        let username = "singh007"
        let password = "admin123!"
        let expectation = self.expectation(description: "Completion wasn't called")
        //When
        
        self.sut.loginUser(["username":username,"password":password,"token":""]) {[weak self](statusCode, error )in
            guard let self = self else{return}
            //Then
            XCTAssertEqual(statusCode,ResponseCodes.success)
            XCTAssertEqual(error!.message,"no error")
            if let login = LoginUser.findOrFetch(in: self.sut.coOrdinator.syncContext, matching: NSPredicate(format: "%K == %@", #keyPath(LoginUser.username),username)){
                XCTAssertEqual(login.username,username)
                XCTAssertEqual(login.password,password)
                XCTAssertEqual(login.token,self.sut.token)
                expectation.fulfill()
            }
        }
    }
}
