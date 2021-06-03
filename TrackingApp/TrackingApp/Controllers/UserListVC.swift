//
//  UserListVC.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit
import MapKit
import CoreData
import CoreLocation
class UserListVC: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var userListViewModel:UserListViewModel!
   
    lazy var dataSource: CollectionViewDatasource<UserListVC>? = {
        guard let cv = self.collectionView else { fatalError("must have collection view") }
        guard let frc = self.userListViewModel.userFetchResultController else{ return nil}
        let dt = CollectionViewDatasource(collectionView: cv, cellIdentifier:Identifier.UserCellIdentifier.rawValue, fetchedResultsController: frc, delegate: self)
        return dt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Welcome"
        let logoutButton = UIBarButtonItem(image: UIImage(named: "logout.png")!, style: .plain, target: self, action: #selector(UserListVC.logoutTapped))
        self.navigationItem.leftBarButtonItem = logoutButton
        self.stopActivity()
        self.userListViewModel!.getAllUsers { [weak self] (statusCode, error ) in
            guard let self = self else { return }
            if statusCode == ResponseCodes.success{
                self.mapView.showsUserLocation = true
                self.mapView.delegate = self
                self.showPins()
            }
        }
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self
    }
    @objc func logoutTapped(){
        self.startActivity()
        self.userListViewModel.logoutUser(["token":self.userListViewModel.token as Any]) { [weak self ](statusCode, error) in
            guard let self = self else{return}
            self.stopActivity()
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func addUserTapped(){
        self.performSegue(withIdentifier: SegueIdentifier.CreateUserSegue.rawValue , sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.CreateUserSegue.rawValue {
            guard let createUserVC = segue.destination as? CreateUserVC else {fatalError("CreateUserVC not found")}
            createUserVC.createUserViewModel = CreateUserViewModel(api: self.userListViewModel.api, token:self.userListViewModel.token,cordinator: self.userListViewModel.coOrdinator, userModel: UserModel())
            createUserVC.delegate = self
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
        return CGSize(width: 114, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left:0, bottom: 10, right: 0)
    }
    
}
//MARK:- UICollectionViewDelegate
extension UserListVC:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = self.userListViewModel.userFetchResultController!.object(at: indexPath)
        let loc = CLLocation(latitude: (user.address?.geo?.lattitude?.doubleValue())!, longitude: (user.address?.geo?.longitude?.doubleValue())!)
        self.mapView.centerToLocation(loc)
    }
}


//MARK:- UICollectionViewDelegate
extension UserListVC: MKMapViewDelegate {
    
  func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        guard let annotation = annotation as? LocationPin else {return nil}

        var annotationView: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: Keys.PinView.rawValue) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation,reuseIdentifier: Keys.PinView.rawValue)
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return annotationView
    }
}
//MARK:- utility
extension UserListVC{
    fileprivate func startActivity(){
        if self.activityView.isAnimating == false {
            self.activityView.startAnimating()
        }
    }
    fileprivate func stopActivity(){
        if self.activityView.isAnimating == true {
            self.activityView.stopAnimating()
        }
    }
    fileprivate func showPins(){
        if let locPins = self.userListViewModel.locationPinViewModel?.locPins{
            self.mapView.addAnnotations(locPins)
        }else{
            Log.debug("Pins are not available")
        }
    }
}

//MARK:- CreateUserDelegate
extension UserListVC:CreateUserDelegate{
    func didUserAdded(_ user:User){
        let locPin = self.userListViewModel.createLocationPin(for: user)
        self.mapView.addAnnotation(locPin)
    }
}
