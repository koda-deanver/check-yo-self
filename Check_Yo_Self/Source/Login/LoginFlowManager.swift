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
    func createAccount(for user: User, success: @escaping Closure, failure: @escaping ErrorClosure) {
        
        guard user.favoriteColor != nil, user.ageGroup != nil, user.favoriteGenre != nil, user.identity != nil else {
            failure("Enter all of your profile info!")
            return
        }
        
        validateNewUsername(user.username, success: { username in
            
            if self.validateNewPassword(user.password) {
                DataManager.shared.createUserAccount(for: user, success: { _ in
                    success()
                }, failure: failure)
            } else {
                failure("Password must be between \(NewAccountInfoFieldType.password.minCharacters) and \(NewAccountInfoFieldType.password.maxCharacters) characters")
            }
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
        guard username.count >= NewAccountInfoFieldType.username.minCharacters && username.count <= NewAccountInfoFieldType.username.maxCharacters else {
            failure("Username must be between \(NewAccountInfoFieldType.username.minCharacters) and \(NewAccountInfoFieldType.username.maxCharacters) characters")
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
    
    ///
    /// Check that password meets requirements.
    ///
    /// - parameter password: Password to validate.
    ///
    /// - returns: Bool indicating if password is valid.
    ///
    private func validateNewPassword(_ password: String) -> Bool {
        
        guard password.count >= NewAccountInfoFieldType.password.minCharacters && password.count <= NewAccountInfoFieldType.password.maxCharacters else {
            return false
        }
        
        return true
    }
}
