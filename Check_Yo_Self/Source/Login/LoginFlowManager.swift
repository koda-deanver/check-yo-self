//
//  LoginFlowManager.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 1/23/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

/// Function for controlling login and account creation process.
class LoginFlowManager {
    
    // MARK: - Public Members -
    
    static let shared = LoginFlowManager()
    
    // MARK: - Public Methods -
    
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
    /// Ensure username is available and fits criteria.
    ///
    /// - parameter user: The user to validate credentials for.
    /// - parameter success: Handler for successful credential validation.
    /// - parameter failure: Handler for failed credential validation.
    ///
    func validateCredentials(for user: User, success: @escaping Closure, failure: @escaping ErrorClosure) {
        
        validateNewUsername(user.username, success: { username in
            success()
        }, failure : failure )
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Check that username is available and meets requirements.
    ///
    /// - parameter username: Username to validate.
    /// - parameter success: Success handler containing valid username.
    /// - parameter failure: Failure handler passing error string.
    ///
    private func validateNewUsername(_ username: String, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) {
        
        // Must meet minimum length.
        guard username.count >= Configuration.usernameMinLength && username.count <= Configuration.usernameMaxLength else {
            failure("Username must be between \(Configuration.usernameMinLength) and \(Configuration.usernameMaxLength) characters")
            return
        }
        
        // Must contain letter as first character.
        let firstChar = username[username.startIndex ... username.startIndex]
        guard CharacterType.alphabet.contains(firstChar.lowercased()) else {
            failure("Username must start with a letter")
            return
        }
        
        // Check for availability.
        DataManager.shared.getUsers(matching: [(field: .username, value: username)], success: { users in
            
            users.isEmpty ? success(username) : failure("Username Taken")
        }, failure: failure)

    }
}
