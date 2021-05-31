//
//  ErrorVCTests.swift
//  TrackingAppTests
//
//  Created by Gautam Kumar Singh on 31/5/21.
//

import XCTest
@testable import TrackingApp
class ErrorVCTests: XCTestCase {
    var sut: ErrorVC!
    override func setUp() {
        super.setUp()
        
        sut = UIStoryboard(name: "UIHelpers", bundle: nil).instantiateViewController(identifier: "alert") as? ErrorVC
    
       
    }

    override func tearDown()  {
        Utility.resetUserDefault()
        self.sut = nil
        super.tearDown()
    }
    func test_alert_with_title_message(){
        //When
        self.sut.set(title: "Hi", msg: "Test Message")
        self.sut.loadViewIfNeeded()
        //Then
        XCTAssertEqual(self.sut.alertTitle, "Hi")
        XCTAssertEqual(self.sut.alertMessage, "Test Message")
        
    }
}
