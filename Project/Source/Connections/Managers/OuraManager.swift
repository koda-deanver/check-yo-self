//
//  OuraManager.swift
//  check-yo-self
//
//  Created by AA10 on 03/07/2020.
//  Copyright © 2020 ThematicsLLC. All rights reserved.
//

import UIKit
import Foundation

final class OuraManager {
    
    static let shared = OuraManager()
    
    private lazy var authenticationController = OuraAuthenticationController(delegate: self)
    
    private var currentToken: String? {
        get { return DataManager.shared.getLocalValue(for: .fitbitToken) }
        set {
            guard let newValue = newValue else { return }
            DataManager.shared.saveLocalValue(newValue, for: .fitbitToken)
        }
    }
    
    private var loginCompletion: BoolClosure?
    
    func login(from viewController: GeneralViewController, completion: BoolClosure?) {
        self.loginCompletion = completion
        authenticationController.login(fromParentViewController: viewController)
    }
    
    func getProfileInfo(success: @escaping ([String:Any]) -> Void, failure: @escaping ErrorClosure){
        
        guard let token = currentToken else {
            failure("Login to Oura to get personal data")
            return
        }
        
        OuraAPI.sharedInstance.authorize(with: token)
        let datePath = "/v1/userinfo"
        
        guard let session = OuraAPI.sharedInstance.session,
            let profileURL = URL(string: "https://api.ouraring.com\(datePath)") else {
                failure("Failed to connect.")
                return
        }
        
        session.dataTask(with: profileURL) { (data, response, error) in
        
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data else {
                failure(error?.localizedDescription ?? "Failed to retreive data.")
                return
            }

            guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                failure("Failed to read data.")
                return
            }
            
            print("PERSONAL INFO : \(dictionary)")
            success(dictionary)
        }.resume()
    }
    
    func getSleepInfo(forToday: Bool = true, success: @escaping ([String:Any]) -> Void, failure: @escaping ErrorClosure){
        
        guard let token = currentToken else {
            failure("Login to Oura to get sleep data")
            return
        }
        
        OuraAPI.sharedInstance.authorize(with: token)
        var datePath = "/v1/sleep"
        
        //The first date is the start date and the second date is the end date (inclusive).
        //If you omit the start date, it will be set to one week ago.
        //If you omit the end date, it will be set to the current day.
        let startDate = Date()
        let endDate = Date() //provide end date with yyyy-MM-dd format
        
        //startDate = "2020-06-02"
        //endDate = "2020-06-05"
        
        //forToday == true ? datePath.append("?start=\(startDate.dateString())") : datePath.append("?start=\(startDate.dateString())&end=\(endDate.dateString())")
        datePath.append("?start=2020-06-02&end=2020-06-05)")
        
        print("URL: \(datePath)");
        guard let session = OuraAPI.sharedInstance.session,
            let profileURL = URL(string: "https://api.ouraring.com\(datePath)") else {
                failure("Failed to connect.")
                return
        }
        
        session.dataTask(with: profileURL) { (data, response, error) in
        
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data else {
                failure(error?.localizedDescription ?? "Failed to retreive data.")
                return
            }

            guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                failure("Failed to read data.")
                return
            }
            
            print("PERSONAL INFO : \(dictionary)")
            success(dictionary)
        }.resume()
    }
    
    func getActivityInfo(forToday: Bool = true, success: @escaping ([String:Any]) -> Void, failure: @escaping ErrorClosure){
            
            guard let token = currentToken else {
                failure("Login to Oura to get heart data")
                return
            }
            
            OuraAPI.sharedInstance.authorize(with: token)
            var datePath = "/v1/activity"
            
            //The first date is the start date and the second date is the end date (inclusive).
            //If you omit the start date, it will be set to one week ago.
            //If you omit the end date, it will be set to the current day.
            let startDate = Date()
            let endDate = Date() //provide end date with yyyy-MM-dd format
            
            //startDate = "2020-06-02"
            //endDate = "2020-06-05"
            
            //forToday == true ? datePath.append("?start=\(startDate.dateString())") : datePath.append("?start=\(startDate.dateString())&end=\(endDate.dateString())")
            datePath.append("?start=2020-06-02&end=2020-06-05)")
            
            print("URL: \(datePath)");
            guard let session = OuraAPI.sharedInstance.session,
                let profileURL = URL(string: "https://api.ouraring.com\(datePath)") else {
                    failure("Failed to connect.")
                    return
            }
            
            session.dataTask(with: profileURL) { (data, response, error) in
            
                guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data else {
                    failure(error?.localizedDescription ?? "Failed to retreive data.")
                    return
                }

                guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                    failure("Failed to read data.")
                    return
                }
                
                print("ACTIVITY INFO : \(dictionary)")
                success(dictionary)
            }.resume()
        }
    
    func getReadinessInfo(forToday: Bool = true, success: @escaping ([String:Any]) -> Void, failure: @escaping ErrorClosure){
        
        guard let token = currentToken else {
            failure("Login to Oura to get readiness data")
            return
        }
        
        OuraAPI.sharedInstance.authorize(with: token)
        var datePath = "/v1/activity"
        
        //The first date is the start date and the second date is the end date (inclusive).
        //If you omit the start date, it will be set to one week ago.
        //If you omit the end date, it will be set to the current day.
        let startDate = Date()
        let endDate = Date() //provide end date with yyyy-MM-dd format
        
        //startDate = "2020-06-02"
        //endDate = "2020-06-05"
        
        //forToday == true ? datePath.append("?start=\(startDate.dateString())") : datePath.append("?start=\(startDate.dateString())&end=\(endDate.dateString())")
        datePath.append("?start=2020-06-02&end=2020-06-05)")
        
        print("URL: \(datePath)");
        guard let session = OuraAPI.sharedInstance.session,
            let profileURL = URL(string: "https://api.ouraring.com\(datePath)") else {
                failure("Failed to connect.")
                return
        }
        
        session.dataTask(with: profileURL) { (data, response, error) in
        
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data else {
                failure(error?.localizedDescription ?? "Failed to retreive data.")
                return
            }

            guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                failure("Failed to read data.")
                return
            }
            
            print("READINESS INFO : \(dictionary)")
            success(dictionary)
        }.resume()
    }
}

// MARK: - Extension: AuthenticationProtocol -

extension OuraManager: OuraAuthenticationProtocol {
    
    func authorizationDidFinish(_ success: Bool) {
        guard let authToken = authenticationController.authenticationToken else {
            return
        }
        print("DID FINISH: \(authToken)")
        currentToken = authToken
        loginCompletion?(success)
    }
}
