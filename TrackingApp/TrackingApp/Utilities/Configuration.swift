//
//  Configuration.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

struct Configuration: Codable {
  let server: String
  let debug: Bool
}

extension Configuration {
  static func load() -> Configuration {
    let url = Bundle.main.url(forResource: "configuration", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try! decoder.decode(Configuration.self, from: data)
  }
}
