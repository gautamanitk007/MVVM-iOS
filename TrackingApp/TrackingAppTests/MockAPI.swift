//
//  MockAPI.swift
//  TrackingAppTests
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation
@testable import TrackingApp

class MockAPI: API {
    var loginCalled = false
    init(api: API) {
        super.init(server: api.server)
    }
}
