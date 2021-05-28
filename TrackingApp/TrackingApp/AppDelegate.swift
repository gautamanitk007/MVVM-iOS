//
//  AppDelegate.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UIWindowSceneDelegate {

    static var configuration: Configuration!
    var api: API!
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemBlue
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UIBarButtonItem.appearance().tintColor = .white
        return true
    }

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let loginViewController = self.window?.rootViewController?.children.first as? LoginVC{
            AppDelegate.configuration = Configuration.load()
            api = API(server: AppDelegate.configuration.server)
            loginViewController.loginViewModel = LoginViewModel(api: self.api)
        }

        guard let _ = (scene as? UIWindowScene) else { return }
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
    }


}

