//
//  LoginFlowManager.swift
//  check-yo-self
//
//  Created by phil on 1/23/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation
import Firebase

/// Function for controlling login and account creation process.
final class LoginFlowManager {
    
    // MARK: - Public Members -
    
    static let shared = LoginFlowManager()
    
    // MARK: - Public Methods -
    
    ///
    /// Authenticated user and logs in.
    ///
    /// Firebase authentication is used to validate email and password. Then user is located in database and saved in *User.current* object.
    ///
    /// - parameter email: The email used to sign up.
    /// - parameter password: The password associated with email.
    /// - parameter success: Handler for successful login.
    /// - parameter failure: Handler for failure to login.
    ///
    func login(withEmail email: String, password: String, success: Closure?, failure: ErrorClosure?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
            
            guard let uid = user?.uid, error == nil else {
                failure?("Login failed.")
                return
            }
            
            DataManager.shared.getUsers(matching: [(field: .uid, value: uid), (field: .password, value: password)], success: { users in
                
                guard users.count == 1 else {
                    let errorText = (users.count == 0) ? "Could not find data for user." : "Uh-oh Something is wrong with your account."
                    failure?(errorText)
                    return
                }
                
                let user = users[0]
                User.current = user
                success?()
                
            }, failure: failure)
        })
    }
    
    ///
    /// Create account with current credentials.
    ///
    /// - parameter user: The user to create an account for.
    /// - parameter success: Handler for successful account creation.
    /// - parameter failure: Handler for failed account creation.
    ///
    func updateAccount(for user: User, success: @escaping Closure, failure: @escaping ErrorClosure) {
        
        DataManager.shared.updateAccount(for: user, success: { _ in
            success()
        }, failure: failure)
    }
    
    ///
    /// Check that gamertag is available and meets requirements.
    ///
    /// - note: The length is already valid because textField allowed the input.
    ///
    /// - parameter username: Gamertag to validate.
    /// - parameter success: Success handler containing valid username.
    /// - parameter failure: Failure handler passing error string.
    ///
    func validateNewGamertag(_ gamertag: String, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) {
        
        // Must contain letter as first character.
        let firstChar = gamertag[gamertag.startIndex ... gamertag.startIndex]
        guard CharacterType.alphabet.contains(firstChar.lowercased()) else {
            failure("Gamertag must start with a letter")
            return
        }
        
        // Check for availability.
        DataManager.shared.getUsers(matching: [(field: .gamertag, value: gamertag)], success: { users in
            
            users.isEmpty ? success(gamertag) : failure("Gamertag Taken")
        }, failure: failure)

    }
}
