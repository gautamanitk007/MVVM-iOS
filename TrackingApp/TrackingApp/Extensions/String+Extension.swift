//
//  String+Extension.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 1/6/21.
//

import Foundation

extension String{
    func intValue()->Int{
        if let value = Int.init(self){
            return value
        }
        return 0
    }
    func doubleValue()->Double{
        if let value = Double.init(self){
            return value
        }
        return 0.0
    }
}
