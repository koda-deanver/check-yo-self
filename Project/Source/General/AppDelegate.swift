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
        application.isStatusBarHidden = true
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
       
        // Initialize the Chartboost library.
        Chartboost.start(withAppId: "5882482d43150f4771a3bdf1", appSignature: "e6c3203b65f9cbe700de0bf1208656fea12ebe8f", delegate: nil)
        
        // Configure Firebase shared instance.
        FirebaseApp.configure()
        
        return true
    }
    
    ///
    /// Handles opening of outside URLSs in the app.
    ///
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        guard let urlScheme = url.scheme else { return false }
        
        switch urlScheme{
            
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
            case "fb168489043664341":
                let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
                return handled
            
        default:
            return false
        }
    }
}

