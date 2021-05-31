//
//  UserListVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit
import MapKit
import CoreData
class UserListVC: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    var userViewModel:UserViewModel!
    var userId:String!
    lazy var userFetchResultController:NSFetchedResultsController<User>? = {
        let request = User.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.userViewModel.coOrdinator.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()

    lazy var dataSource: CollectionViewDatasource<UserListVC>? = {
        guard let cv = self.collectionView else { fatalError("must have collection view") }
        guard let frc = self.userFetchResultController else{ return nil}
        let dt = CollectionViewDatasource(collectionView: cv, cellIdentifier:Identifier.UserCellIdentifier.rawValue, fetchedResultsController: frc, delegate: self)
        return dt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        let logoutButton = UIBarButtonItem(title: "Logout", style:.plain, target: self, action: #selector(UserListVC.logoutTapped))
        self.navigationItem.leftBarButtonItem = logoutButton
        
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self
        
        
        self.userViewModel.getAllUsers(["isByPass": "1"]) { status, error in
            Log.debug("status:\(status)")
            Log.debug("error:\(error)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    @objc func logoutTapped(){
        self.userViewModel.logoutUser(["token":self.userViewModel.token]) { [weak self ](statusCode, error) in
            guard let self = self else{return}
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func addUserTapped(){
        self.performSegue(withIdentifier: SegueIdentifier.CreateUserSegue.rawValue , sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.CreateUserSegue.rawValue {
            //guard let createUserVC = segue.destination as? CreateUserVC else {fatalError("CreateUserVC not found")}
           
        }
    }

}

//MARK:- CollectionViewDataSourceDelegate
extension UserListVC : CollectionViewDataSourceDelegate{
    func configure(collection cell: UserCell, for object: User){
        cell.configure(object)
    }
}
//MARK:- UICollectionViewDelegateFlowLayout
extension UserListVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left:0, bottom: 10, right: 0)
    }
    
}
