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
            
            DataManager.shared.getUsers(matching: [(field: .uid, value: uid)], success: { users in
                
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
    func updateAccount(for user: User, success: Closure?, failure: ErrorClosure?) {
        
        DataManager.shared.updateAccount(for: user, success: { _ in
            success?()
        }, failure: failure)
    }
    
    ///
    /// Validates password for length, and containing at least one uppercase letter, number, and special character.
    ///
    /// - note: The length is already valid because textField allowed the input, checked here again as precaution.
    ///
    /// - parameter password: The password to validate.
    ///
    /// - returns: True if password is valid, false along with errorString if it is not.
    ///
    func validateNewPassword(_ password: String) -> (Bool, String) {
        
        guard password.count >= Configuration.passwordMinLength && password.count <= Configuration.passwordMaxLength else { return (false, "Password must be between \(Configuration.passwordMinLength) and \(Configuration.passwordMaxLength) characters.") }
        
        var containsUpperCase = false
        var containsNumber = false
        var containsSpecial = false
        
        for character in password {
            
            if CharacterType.uppercaseLetters.contains(String(character)) { containsUpperCase = true }
            if CharacterType.numeric.contains(String(character)) { containsNumber = true }
            if CharacterType.specialCharacters.contains(String(character)) { containsSpecial = true }
        }
        
        guard containsUpperCase, containsNumber, containsSpecial else { return (false, "Password must contain an uppercase letter, a number, and a special character.") }
        
        return (true, "")
    }
    
    ///
    /// Validates gamertag for length, availability, and starting with a letter.
    ///
    /// - note: The length is already valid because textField allowed the input, checked here again as precaution.
    ///
    /// - parameter username: Gamertag to validate.
    /// - parameter success: Success handler containing valid username.
    /// - parameter failure: Failure handler passing error string.
    ///
    func validateNewGamertag(_ gamertag: String, success: Closure?, failure: ErrorClosure?) {
        
        // Must contain letter as first character.
        let firstChar = gamertag[gamertag.startIndex ... gamertag.startIndex]
        guard CharacterType.alphabet.contains(String(firstChar)) else {
            failure?("Gamertag must start with a letter")
            return
        }
        
        // Check for availability.
        DataManager.shared.getUsers(matching: [(field: .gamertag, value: gamertag)], success: { users in
            
            users.isEmpty ? success?() : failure?("Gamertag Taken")
        }, failure: failure)
    }
}
