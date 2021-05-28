//
//  LoginResponse.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

struct LoginResponse: Decodable {
    let user: UserInfo
    let token: String
}
