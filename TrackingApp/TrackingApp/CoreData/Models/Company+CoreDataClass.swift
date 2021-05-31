//
//  Company+CoreDataClass.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//
//

import Foundation
import CoreData

@objc(Company)
public class Company: NSManagedObject {
    static func insert(into mContext: NSManagedObjectContext,for response: ResCompany) -> Company{
        let company : Company = mContext.insertObject()
        company.name = response.name
        company.catchPhrase = response.catchPhrase
        company.bs =  response.bs
        return company
    }
}

extension Company: Managed{
    @objc(defaultSortDescriptors) public static var defaultSortDescriptors : [NSSortDescriptor]{
        return [NSSortDescriptor(key: #keyPath(name), ascending: false)]
    }
}
