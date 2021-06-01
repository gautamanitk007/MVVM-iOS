//
//  CreateUserViewModel.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 1/6/21.
//

import Foundation

class CreateUserViewModel{
    
    
    

}

extension CreateUserViewModel{
    var userId:Int{
        return Int.random(in: 1..<500)*10000
    }
    var phone:String{
        return "\(Int.random(in: 1..<50)*10)" + "\(Int.random(in: 2..<50)*10)" + "\(Int.random(in: 3..<50)*10)" + "\(Int.random(in: 4..<50)*10)"
    }
    var email:String{
        return "test\(Int.random(in: 1..<50)*1000)@gmail.com"
    }
    var website:String{
        return "https://bic.konicaminolta.asia/about/"
    }
    var password:String{
        return "admin123!"
    }
    var companyBS:String{
        return "123-456-XXXX"
    }
    var catchPhrase:String{
        return "Company xyz"
    }
    var companyName:String{
        return "Company \(Int.random(in: 1..<50)*1000)"
    }
}
