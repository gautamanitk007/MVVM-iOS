//
//  CollectionViewDatasource.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//

import Foundation
import UIKit
import CoreData
protocol CollectionViewDataSourceDelegate: AnyObject {
    associatedtype Object: NSFetchRequestResult
    associatedtype Cell: UICollectionViewCell
    func configure(collection cell: Cell, for object: Object)
}

fileprivate enum Update<Object> {
    case insert(IndexPath)
    case update(IndexPath, Object)
    case move(IndexPath, IndexPath)
    case delete(IndexPath)
}

class CollectionViewDatasource<Delegate: CollectionViewDataSourceDelegate>: NSObject, UICollectionViewDataSource,NSFetchedResultsControllerDelegate {
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    required init(collectionView: UICollectionView, cellIdentifier: String, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.collectionView = collectionView
        self.cellIdentifier = cellIdentifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        self.updates = []
        super.init()
        fetchedResultsController.delegate = self
        reloadDataSource()
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    var selectedObject: Object? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
        return objectAtIndexPath(indexPath)
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        let  _ = self.fetchedResultsController.fetchedObjects?.count
        return fetchedResultsController.object(at: indexPath)
    }
    
    func reloadDataSource(){
        try! fetchedResultsController.performFetch()
        collectionView.reloadData()
    }
    
    deinit{
        self.updates.removeAll()
    }
    // MARK: Private
    fileprivate let collectionView: UICollectionView
    fileprivate let cellIdentifier: String
    fileprivate let fetchedResultsController: NSFetchedResultsController<Object>
    fileprivate weak var delegate: Delegate!
    fileprivate var updates: [Update<Object>]
    
    fileprivate func processUpdates(_ updates: [Update<Object>]?) {
        guard let updates = updates else { return collectionView.reloadData() }
        collectionView.performBatchUpdates({
            for update in updates {
                switch update {
                case .insert(let indexPath):
                    self.collectionView.insertItems(at: [indexPath])
                case .update(let indexPath, let object):
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? Cell{
                        self.delegate.configure(collection : cell, for: object)
                    }
                   
                case .move(let indexPath, let newIndexPath):
                    self.collectionView.deleteItems(at: [indexPath])
                    self.collectionView.insertItems(at: [newIndexPath])
                case .delete(let indexPath):
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        }, completion: { _ in
            //print("Update done:\(value)")
        })
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = objectAtIndexPath(indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        delegate.configure(collection : cell, for: object)
        return cell
    }
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPathR = newIndexPath else { fatalError("Index path should be not nil") }
            updates.append(.insert(indexPathR))
        case .update:
            guard let indexPathR = indexPath else { fatalError("Index path should be not nil") }
            let object = objectAtIndexPath(indexPathR)
            updates.append(.update(indexPathR, object))
        case .move:
            guard let indexPathR = indexPath else { fatalError("Index path should be not nil") }
            guard let newIndexPathR = newIndexPath else { fatalError("New index path should be not nil") }
            updates.append(.move(indexPathR, newIndexPathR))
        case .delete:
            guard let indexPathR = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.delete(indexPathR))
        @unknown default: break
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        processUpdates(updates)
    }
}
