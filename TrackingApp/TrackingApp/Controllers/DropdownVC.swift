//
//  DropdownVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 29/5/21.
//

import UIKit

protocol DropdownDelegate:AnyObject {
    func didSelected(viewModel vm:CountryViewModel)
}

class DropdownVC: UIViewController {
    @IBOutlet weak var cutomTable: UITableView!
    var countryListViewModel:CountryListViewModel!
    weak var delegate:DropdownDelegate?
    private var datasource : TableViewDatasource<GeneralCell,CountryViewModel>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datasource = TableViewDatasource(cellIdentifier: Identifier.GeneralCellIdentifier.rawValue,items: self.countryListViewModel.countryViewModels){(cell,viewModel) in
            cell.configure(viewModel)
        }
        self.cutomTable.dataSource = self.datasource
        self.cutomTable.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.preferredContentSize = CGSize.init(width: 160, height: 260)
    }
    deinit {
        self.datasource = nil
        self.countryListViewModel = nil
    }
}
//MARK:- UITableViewDelegate
extension DropdownVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelected(viewModel: self.countryListViewModel.model(at: indexPath.row))
        self.dismiss(animated: true, completion: nil)
    }
}
