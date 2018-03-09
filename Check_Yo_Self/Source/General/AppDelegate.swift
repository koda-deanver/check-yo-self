//********************************************************************
//  AppDelegate.swift
//  Check Yo Self
//  Created by Phil on 12/1/16
//
//  Description: Overall settings for app
//********************************************************************

import UIKit
import UserNotifications
import Firebase
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Hide status bar
        //application.isStatusBarHidden = true
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
        

        UNUserNotificationCenter.current().delegate = self
        // Remove pending requests because user has come back to app
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // Override point for customization after application launch.
            // Initialize the Chartboost library
        Chartboost.start(withAppId: "5882482d43150f4771a3bdf1", appSignature: "e6c3203b65f9cbe700de0bf1208656fea12ebe8f", delegate: nil)
        // Configure Firebase shared instance
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        print(url.scheme!)
        if let urlScheme = url.scheme{
            switch urlScheme{
                // Fitbit
                case "devicesscreen":
                    let notification = Notification(
                        name: Notification.Name(rawValue: NotificationConstants.launchNotification),
                        object: nil,
                        userInfo: [UIApplicationLaunchOptionsKey.url: url]
                    )
                    NotificationCenter.default.post(notification)
                    return true
                // Facebook
                case "fb168489043664341":
                    let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
                    return handled;
            default:
                return false
            }
        }else{
            return false
        }
    }
    
    /*func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
     
    }*/
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        PlayerData.sharedInstance.archivePlayer()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Set up notification if user doesn't relaunch app before trigger
        let content = UNMutableNotificationContent()
        content.title = "Hey \(PlayerData.sharedInstance.displayName)"
        content.subtitle = "We miss you!"
        content.body = "Don't forget to Check Yo Self and make the most of your day."
        
        // Set for 2 days
        let secondsUntilAlert = Double((((Configuration.daysUntilComebackAlert * 24) * 60) * 60))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsUntilAlert, repeats: true)
        let request = UNNotificationRequest(identifier: "WeMissYou", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
            if let error = error{
                print("ERROR: \(error)")
            }else{
                print("SUCCESS: Notification scheduled")
            }
        })

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    // Set notifications to appear in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler(.alert)
    }
}

