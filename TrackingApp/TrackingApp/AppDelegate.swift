//
//  AppDelegate.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var configuration: Configuration!
    var window: UIWindow?
    var api:API!
    var coordinator: Coordinator!
    var persistentContainer: NSPersistentContainer!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemBlue
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UIBarButtonItem.appearance().tintColor = .white
        
        AppDelegate.configuration = Configuration.load()
        
        createDataContainer { [weak self] container in
            guard let self = self else{return}
            self.persistentContainer = container
            self.coordinator = Coordinator(container: container)
            self.api = API(server: AppDelegate.configuration.server)
            if let loginViewController = self.window?.rootViewController?.children.first as? LoginVC{
                loginViewController.loginViewModel = LoginViewModel(api: self.api, coOrdinator: self.coordinator)
                loginViewController.countryListViewModel = CountryListViewModel(countryList: AppDelegate.configuration.countryList)
                NotificationCenter.default.post(name: NSNotification.Name(NotificatioString.AutoLogin.rawValue), object: nil)
            }
        }
        //NotificationCenter.default.addObserver(forName:UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { (_) in
        return true
    }
}


extension UIApplication {
  static var appDelegate: AppDelegate { return self.shared.delegate as! AppDelegate}
}
