//
//  User.swift
//  Check_Yo_Self
//
//  Created by Phil on 1/18/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Enumeration -

/// Fields that can be accessed on database.
enum UserDatabaseField: String {
    case username = "username"
    case password = "password"
    case gems = "gems"
    case facebookID = "facebook-id"
    case facebookName = "facebook-name"
}

// MARK: - Struct -

/// Local representation of information found in *clients* database.
struct User {
    
    let username: String
    let password: String
    var gems: Int = 0
    var facebookID: String?
    var facebookName: String?
    
    init(withUsername username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    init?(withUserInfo userInfo: [String: Any]) {
        
        guard let username = userInfo[UserDatabaseField.username.rawValue] as? String, let password = userInfo[UserDatabaseField.password.rawValue] as? String else { return nil }
        
        self.username = username
        self.password = password
        
        let gemsString = userInfo[UserDatabaseField.gems.rawValue] as? String ?? "0"
        gems = Int(gemsString) ?? 0
        
        facebookID = userInfo[UserDatabaseField.facebookID.rawValue] as? String
        facebookName = userInfo[UserDatabaseField.facebookName.rawValue] as? String
    }
}
