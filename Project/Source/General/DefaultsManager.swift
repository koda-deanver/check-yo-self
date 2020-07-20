//
//  DefaultsManager.swift
//  check-yo-self
//
//  Created by AA10 on 20/07/2020.
//  Copyright © 2020 ThematicsLLC. All rights reserved.
//

import Foundation

class DefaultsManager {
    static let shared = DefaultsManager()
    
    func IsFirstAppLaunch() -> Bool {
        let val = UserDefaults.standard.bool(forKey: "first_app_launch")
        return val
//        if val {
//            return val
//        } else {
//            setIsFirstAppLaunch(value: true)
//            return false
//        }
    }
    
    func setIsFirstAppLaunch(value: Bool) {
        UserDefaults.standard.set(value, forKey: "first_app_launch")
        UserDefaults.standard.synchronize()
    }
    
    func IsFirstLogin() -> Bool {
        let val = UserDefaults.standard.bool(forKey: "first_login")
        return val
//        if val {
//            //isFirstLogin value is true
//            return val
//        } else {
//            //isFirstLogin value is false
//            //set isFirstLogin value to true
//            setIsFirstLogin(value: true)
//            return false
//        }
    }
    
    func setIsFirstLogin(value: Bool) {
        UserDefaults.standard.set(value, forKey: "first_login")
        UserDefaults.standard.synchronize()
    }
    
    func shouldShowTutorial() -> Bool {
        return UserDefaults.standard.bool(forKey: "show_tutorial")
    }
    
    func setShowTutorial(value: Bool) {
        UserDefaults.standard.set(value, forKey: "show_tutorial")
        UserDefaults.standard.synchronize()
    }
}
