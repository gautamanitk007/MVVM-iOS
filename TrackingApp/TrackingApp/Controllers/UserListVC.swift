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
    var userViewModel:UserViewModel!
    var locationPinViewModel:LocationPinViewModel!
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
        self.navigationItem.title = "Welcome"
        let logoutButton = UIBarButtonItem(image: UIImage(named: "logout.png")!, style: .plain, target: self, action: #selector(UserListVC.logoutTapped))
        self.navigationItem.leftBarButtonItem = logoutButton
        self.stopActivity()
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self
    
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.showPins()
        
    }
    @objc func logoutTapped(){
        self.startActivity()
        self.userViewModel.logoutUser(["token":self.userViewModel.token]) { [weak self ](statusCode, error) in
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
            guard let navController = segue.destination as? UINavigationController else {
                fatalError("NavigationController not found")
            }
            guard let createUserVC = navController.viewControllers.first as? CreateUserVC else {fatalError("CreateUserVC not found")}
            createUserVC.createUserViewModel = CreateUserViewModel(api: self.userViewModel.api, token:self.userViewModel.token,cordinator: self.userViewModel.coOrdinator, userModel: UserModel())
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
        let user = self.userFetchResultController!.object(at: indexPath)
        Log.debug(user.name!)
    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation,regionRadius: CLLocationDistance = 4000) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: regionRadius,longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
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
        self.locationPinViewModel.generateLocationPins()
        self.mapView.addAnnotations(self.locationPinViewModel.locPins!)
    }
}

//MARK:-CreateUserDelegate
extension UserListVC:CreateUserDelegate{
    func didUserAdded() {
        self.mapView.removeAnnotations(self.locationPinViewModel.locPins!)
        self.locationPinViewModel.reGenerateLocation(for: User.fetch(in: self.userViewModel.coOrdinator.viewContext))
        self.showPins()
    }
}
