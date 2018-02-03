//
//  LoginFlowManager.swift
//  Check_Yo_Self
//
//  Created by Phil Rattazzi on 1/23/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

class LoginFlowManager {
    
    // MARK: - Public Members -
    
    static let shared = LoginFlowManager()
    
    // MARK: - Private Members -
    
    private let successAlertTitle = "New account created!"
    private let errorAlertTitle = "Failed to create account."
    
    // MARK: - Public Methods -
    
    ///
    /// Ensure username and password are satisfactory to create a new user.
    ///
    /// - parameter credentials: Username and password to validate.
    /// - parameter viewController: The calling view controller if there is one.
    ///
    func validateNewCredentials(credentials: (username: String, password: String), viewController: GeneralViewController?) {
        
        validateNewUsername(credentials.username, success: { username in
            
            if self.validateNewPassword(credentials.password) {
                self.createAccount(withUsername: username, password: credentials.password, viewController: viewController)
            } else {
                viewController?.displayAlert(withTitle: self.errorAlertTitle, message: ("Password must be between \(NewAccountInfoFieldType.password.minCharacters) and \(NewAccountInfoFieldType.password.maxCharacters) characters"), completion: nil)
            }
        }, failure : { errorString in
            viewController?.displayAlert(withTitle: self.errorAlertTitle, message: errorString, completion: nil)
        })
        
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
    
    ///
    /// Create account with current credentials.
    ///
    /// - parameter username: Username for new account.
    /// - parameter password: Password for new account.
    /// - parameter viewController: The calling view controller if there is one.
    ///
    private func createAccount(withUsername username: String, password: String, viewController: GeneralViewController?) {
        
        DataManager.shared.createUser(withCredentials: (username, password), success: { user in
            viewController?.displayAlert(withTitle: self.successAlertTitle, message: "", completion: {
                viewController?.dismiss(animated: true, completion: nil)
            })
        }, failure: { errorString in
            viewController?.displayAlert(withTitle: self.errorAlertTitle, message: errorString, completion: nil)
        })
    }
}
