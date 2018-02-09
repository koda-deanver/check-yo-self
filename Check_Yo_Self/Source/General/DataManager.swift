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
    
    // MARK: - Public Members -
    
    static let shared = DataManager()
    
    // MARK: - Public Methods -
    
    ///
    /// Searches the *client* database for users matching query.
    ///
    /// This method looks for **all** users with matching *userDatabaseField* value in database. Each user found is appended to an array and returned. This method fails if there is a connection error.
    ///
    /// - warning: This method will not retreive a user that does not have all data required to create *User* object.
    ///
    /// - parameter userDatabaseField: Field to search for match in.
    /// - parameter desiredValue: The value that should be present in specified *userDatabaseField*.
    /// - parameter success: Called when there is no error and users are found/not found. Returns array.
    /// - parameter failure: Called when there is connection error.
    ///
    func getUsers(matching query: [(field: UserDatabaseField, value: String)], success: @escaping ([User]) -> Void, failure: @escaping (String) -> Void) {
        
        fetchAllClients(success: { clients in
            
            var users: [User] = []
           
            searchingUsers: for userRecord in clients {
                
                guard let userInfo = userRecord.value as? [String: Any], let user = User(withUserInfo: userInfo) else { continue }
                
                // Filter users that do not meet conditions
                for condition in query {
                    let actualValue = userInfo[condition.field.rawValue] as? String
                    let expectedValue = condition.value
                    
                    guard actualValue == expectedValue else { continue searchingUsers }
                }
                
                users.append(user)
            }
            
            success(users)
            
        }, failure: failure)
    }
    
    ///
    /// Create a new user with specified credentials.
    ///
    /// - parameter success: Returns user on successful create.
    /// - parameter failure: Failure handler containing error string.
    ///
    func createUser(withCredentials credentials: (username: String, password: String), success: @escaping (User) -> Void, failure: @escaping (String) -> Void) {
        
        let userPath = Constants.firebaseRootPath.child("clients/\(credentials.username)")
        BSGFirebaseService.updateData(atPath: userPath, values: [
            "username" : "\(credentials.username)",
            "password" : "\(credentials.password)"
            ], success: {
                let user = User(withUsername: credentials.username, password: credentials.password)
                success(user)
        }, failure: {
            failure("Failed to create user.")
        })
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Fetches dictionary of all clients in *clients* database section.
    ///
    /// - parameter success: Returns client dictionary.
    /// - parameter failure: Connection error blocked attempt at reading clients.
    ///
    private func fetchAllClients(success: @escaping ([String: Any]) -> Void, failure: @escaping (String) -> Void) {
        
        BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("clients"), success: { snapshot in
            
            guard let clients = snapshot.value as? [String: Any] else {
                failure("Connection Error")
                return
            }
        
            success(clients)
            
        }, failure: {
            failure("Connection Error.")
        })
    }
}
