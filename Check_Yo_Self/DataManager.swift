//
//  DataManager.swift
//  Check_Yo_Self
//
//  Created by Phil Rattazzi on 1/18/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class DataManager {
    
    /// MARK: - Public Members -
    
    static let shared = DataManager()
    
    ///
    /// Attempt to get user with specified credentials.
    ///
    /// - parameter credential: Username and password tuple with user info.
    /// - parameter success: Returns a user object if succeeds.
    /// - parameter failure: Failure handler containing error string.
    ///
    func getUser(withCredentials credentials: (username: String, password: String), success: @escaping (User) -> Void, failure: @escaping (String) -> Void) {
    
        BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("clients"), success: { snapshot in
            
            guard let clients = snapshot.value as? [String: Any] else {
                failure("Connection Error")
                return
            }
            
            // Find matching user
            for userRecord in clients where userRecord.key.lowercased() == credentials.username.lowercased() {
                
                guard let user = User(withUserRecord: userRecord) else {
                    failure("User not found")
                    return
                }
                
                guard user.password == credentials.password else {
                    failure("Incorrect Password")
                    return
                }
                
                success(user)
                return
            }
            failure("User not found")
            
        }, failure: {
            failure("Connection Error")
        })
    }
    
    ///
    /// Check to see if a user with this username exists.
    ///
    /// - parameter username: User to check for
    /// - parameter success: Returns true if user is found and false if user DNE.
    /// - parameter failure: Failure handler containing error string.
    ///
    func checkForUser(withUsername username: String, success: @escaping (Bool) -> Void, failure: @escaping (String) -> Void) {
        
        BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("clients"), success: { snapshot in
            
            guard let clients = snapshot.value as? [String: Any] else {
                failure("Connection Error")
                return
            }
            
            // Find matching user
            for userRecord in clients where userRecord.key.lowercased() == username.lowercased() {
                
                success(false)
                return
            }
            success(true) /* username available */
            
        }, failure: {
            failure("Connection Error")
        })
    }
    
    func createUser(withCredentials credentials: (username: String, password: String), success: @escaping (User) -> Void, failure: @escaping (String) -> Void) {
        
        let userPath = Constants.firebaseRootPath.child("clients/\(credentials.username)")
        BSGFirebaseService.updateNode(atPath: userPath, values: [
            "username" : "\(credentials.username)",
            "password" : "\(credentials.password)"
            ], success: {
                let user = User(withUsername: credentials.username, password: credentials.password)
                success(user)
        }, failure: {
            failure("Failed to create user.")
        })
    }
}
