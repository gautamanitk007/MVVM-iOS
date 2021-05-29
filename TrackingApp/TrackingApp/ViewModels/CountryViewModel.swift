//
//  CountryViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation

class CountryViewModel {
    var countryName :String
    var countryCode:String
    init(countryName:String,code:String) {
        self.countryName = countryName
        self.countryCode = code
    }
    
}
