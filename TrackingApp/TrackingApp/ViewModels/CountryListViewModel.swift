//
//  CountryListViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation

class CountryListViewModel {
    private (set) var countryViewModels = [CountryViewModel]()
    init(countryList:[Country]) {
        for country in countryList {
            self.countryViewModels.append(CountryViewModel(countryName: country.name, code: country.code))
        }
    }
    func addCountryViewModel(_ vm:CountryViewModel){
        self.countryViewModels.append(vm)
    }
    
    func numberOfRows(in section:Int)->Int{
        return self.countryViewModels.count
    }
    
    func model(at index:Int) ->CountryViewModel{
        return self.countryViewModels[index]
    }
}
