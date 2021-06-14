//
//  CommonModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 3/6/21.
//

import Foundation

class CommonModel{
    let api:API!
    let coOrdinator:Coordinator
    init( api:API,coOrdinator:Coordinator) {
        self.api = api
        self.coOrdinator = coOrdinator
    }
}
