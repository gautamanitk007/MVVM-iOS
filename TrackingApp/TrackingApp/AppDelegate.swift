//
//  AppDelegate.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var configuration: Configuration!
    var window: UIWindow?
    var token:String?
    var api:API!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemBlue
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UIBarButtonItem.appearance().tintColor = .white
        
        AppDelegate.configuration = Configuration.load()
        self.api = API(server: AppDelegate.configuration.server)
        if let loginViewController = self.window?.rootViewController?.children.first as? LoginVC{
            loginViewController.loginViewModel = LoginViewModel(api: self.api)
        }
        
        return true
    }
}

extension UIApplication {
  static var appDelegate: AppDelegate { return self.shared.delegate as! AppDelegate}
}
