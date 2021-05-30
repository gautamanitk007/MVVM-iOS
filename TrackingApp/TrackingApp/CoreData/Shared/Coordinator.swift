//
//  Coordinator.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation
import CoreData

protocol ProcessorContext: AnyObject {
    // The managed object context to use
    var context: NSManagedObjectContext { get }
    
    // Wraps a block such that it is run on the right queue.
    func perform(_ block: @escaping () -> ())
    
    // Eventually saves the context. May batch multiple calls into a single call to `saveOrRollback()`.
    func delayedSaveOrRollback()
}

public final class Coordinator {
    let viewContext: NSManagedObjectContext
    let syncContext: NSManagedObjectContext
    let syncGroup: DispatchGroup = DispatchGroup()
 
    public init(container: NSPersistentContainer) {
        viewContext = container.viewContext
        syncContext = container.newBackgroundContext()
        syncContext.name = "Coordinator"
        syncContext.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
        setup()
    }
    fileprivate func setup() {
        self.perform { [weak self] in
            guard let self = self else{ return}
            self.setupQueryGenerations()
        }
    }
    fileprivate func setupQueryGenerations(){
        let token = NSQueryGenerationToken.current
        viewContext.perform {[weak self] in
            guard let self = self else{ return}
            try! self.viewContext.setQueryGenerationFrom(token)
        }
        syncContext.perform {[weak self] in
            guard let self = self else{ return}
            try! self.syncContext.setQueryGenerationFrom(token)
        }
    }
}

//MARK:-  ProcessorContext
extension Coordinator: ProcessorContext {
    // This is the context that the sync coordinator, change processors, and other sync components do work on.
    var context: NSManagedObjectContext {
        return syncContext
    }
    // This switches onto the sync context's queue. If we're already on it, it will simply run the block.
    func perform(_ block: @escaping () -> ()) {
        syncContext.perform(group: syncGroup, block: block)
    }
    func delayedSaveOrRollback() {
        context.delayedSaveOrRollback(group: syncGroup)
    }
}
