//
//  NSManagedObjectContext+Extension.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation
import CoreData


extension NSManagedObjectContext{
    
    public func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    public func performSaveOrRollback() {
        perform {
            _ = self.saveOrRollback()
        }
    }
    
    public func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
    public func perform(group: DispatchGroup, block: @escaping () -> ()) {
        group.enter()
        perform {
            block()
            group.leave()
        }
    }
    public func delayedSaveOrRollback(group: DispatchGroup, completion: @escaping (Bool) -> () = { _ in }) {
        let changeCountLimit = 100
        guard changeCountLimit >= changedObjectsCount else { return completion(saveOrRollback()) }
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        group.notify(queue: queue) {
            self.perform(group: group) {
                guard self.hasChanges else { return completion(true) }
                completion(self.saveOrRollback())
            }
        }
    }
    fileprivate var changedObjectsCount: Int {
        return insertedObjects.count + updatedObjects.count + deletedObjects.count
    }
}
