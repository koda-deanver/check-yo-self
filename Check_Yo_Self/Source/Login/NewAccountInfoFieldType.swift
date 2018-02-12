//
//  NewAccountInfoFieldType.swift
//  check-yo-self
//
//  Created by Phil on 2/9/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

/// Type of field that can appear on *New Account* screen.
enum NewAccountInfoFieldType {
    
    case username, password
    
    var tableRow: Int? {
        
        for (index, type) in NewAccountInfoFieldType.all.enumerated() where type == self {
            return index
        }
        return nil /* This type is not in table */
    }
    
    var placeholder: String {
        switch self {
        case .username: return "Username"
        case .password: return "Password"
        }
    }
    
    /// Characters allowed in field
    var validCharacters: [String] {
        switch self {
        case .username: return CharacterType.alphabet + CharacterType.numeric
        case .password: return CharacterType.alphabet + CharacterType.numeric + CharacterType.specialCharacters
        }
    }
    
    /// Minimum characters allowed by field.
    var minCharacters: Int {
        switch self {
        case .username: return Configuration.usernameMinLength
        case .password: return Configuration.passwordMinLength
        }
    }
    
    /// Maximum characters allowed by field.
    var maxCharacters: Int {
        switch self {
        case .username: return Configuration.usernameMaxLength
        case .password: return Configuration.passwordMaxLength
        }
    }
    
    /// All possible field types.
    static var all: [NewAccountInfoFieldType] = [username, password]
}
