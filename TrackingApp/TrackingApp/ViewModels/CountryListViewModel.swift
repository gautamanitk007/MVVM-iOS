//
//  CountryListViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation

class CountryListViewModel {
    private (set) var countryViewModels = [CountryViewModel]()

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
