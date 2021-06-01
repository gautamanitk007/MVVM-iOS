//
//  Encodable+Extension.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 1/6/21.
//

import Foundation

extension Encodable {
    func toJSONString() -> String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}
