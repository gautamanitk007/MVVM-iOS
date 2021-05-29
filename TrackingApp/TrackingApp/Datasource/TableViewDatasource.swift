//
//  TableViewDatasource.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import Foundation
import UIKit

class TableViewDatasource<CellType,ViewModel>:NSObject,UITableViewDataSource where CellType : UITableViewCell{
    let cellIdentifier: String
    var items: [ViewModel]
    let configureCell: (CellType, ViewModel) -> ()
   
    init(cellIdentifier: String,items: [ViewModel], configureCell: @escaping (CellType,ViewModel) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    
    }
    func updateItems(_ items: [ViewModel]) {
        self.items = items
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CellType else {
            fatalError("Cell with identifier \(self.cellIdentifier) not found")
        }
        let vm = self.items[indexPath.row]
        self.configureCell(cell, vm)
        return cell
    }
   
}
