//
//  AppDelegate.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    private let categoryIdentifier = "YesOrNO"
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
        
        self.setupNotification(application)
        
        AppDelegate.configuration = Configuration.load()
        
        createDataContainer { [weak self] container in
            guard let self = self else{return}
            self.persistentContainer = container
            self.coordinator = Coordinator(container: container)
            self.api = API(server: AppDelegate.configuration.server)
            if let loginViewController = self.window?.rootViewController?.children.first as? LoginVC{
                loginViewController.loginViewModel = LoginViewModel(api: self.api, coOrdinator: self.coordinator)
                loginViewController.countryListViewModel = CountryListViewModel(countryList: AppDelegate.configuration.countryList)
                loginViewController.locationService = LocationService()
                NotificationCenter.default.post(name: NSNotification.Name(NotificatioString.AutoLogin.rawValue), object: nil)
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        Log.debug(token)
        let bundleId = Bundle.main.bundleIdentifier
        Log.debug(bundleId!)
        //3.Save the token into local storage and post to app server to generate push notification
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.debug(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Log.debug(userInfo)
        if let aps = userInfo["aps"] as? [String:Any]{
            Log.debug(aps)
        }
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          completionHandler([.banner, .sound, .badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        let identity = response.notification.request.content.categoryIdentifier
        Log.debug(response.actionIdentifier)
        Log.debug(identity)
    }
    
}


extension UIApplication {
  static var appDelegate: AppDelegate { return self.shared.delegate as! AppDelegate}
}

extension AppDelegate{
    func setupNotification(_ application:UIApplication){
        let options:UNAuthorizationOptions = [.badge,.alert,.sound]
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:options) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}


