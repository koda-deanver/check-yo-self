//
//  AppDelegate.swift
//  check-yo-self
//
//  Created by phil on 12/1/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Public Members -
    
    var window: UIWindow?

    // MARK: - Public Methods -
    
    ///
    /// Initial setup handled when app first launches.
    ///
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Hide status bar
//        application.isStatusBarHidden = true
        
        //Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions:launchOptions)
       
//        DispatchQueue.main.async {
//            // Initialize the Chartboost library.
//            Chartboost.start(withAppId: "5882482d43150f4771a3bdf1", appSignature: "e6c3203b65f9cbe700de0bf1208656fea12ebe8f", delegate: nil)
//        }
//          // Initialize the Chartboost library.
//        Chartboost.start(withAppId: "5882482d43150f4771a3bdf1", appSignature: "e6c3203b65f9cbe700de0bf1208656fea12ebe8f", delegate: nil)
        Chartboost.start(withAppId: "5882482d43150f4771a3bdf1", appSignature: "e6c3203b65f9cbe700de0bf1208656fea12ebe8f") { (success) in
            print("CJAt NPPR \(success)")
        }
        
        // Configure Firebase shared instance.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        return true
    }
    
    ///
    /// Handles opening of outside URLSs in the app.
    ///
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        guard let urlScheme = url.scheme else { return false }
        
        switch urlScheme{
            // Oura
            case "devicesscreen-oura":
                let notification = Notification(
                    name: Notification.Name(rawValue: "oura-launched"),
                    object: nil,
                    userInfo: [UIApplicationLaunchOptionsKey.url: url]
                )
                NotificationCenter.default.post(notification)
                return true
            
            // Fitbit
            case "devicesscreen":
                let notification = Notification(
                    name: Notification.Name(rawValue: "fitbit-launched"),
                    object: nil,
                    userInfo: [UIApplicationLaunchOptionsKey.url: url]
                )
                NotificationCenter.default.post(notification)
                return true
            
            // Facebook
            case "fb252498072687562":
                let handled: Bool = ApplicationDelegate.shared.application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
                return handled
            case "com.googleusercontent.apps.177025070177-08ri4f72bf8vh29p9651dgr3mt9796t2":
                let googleAuthentication = GIDSignIn.sharedInstance()?.handle(url)
                return true
            
        default:
            return false
        }
    }
}

