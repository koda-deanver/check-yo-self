//
//  User.swift
//  check-yo-self
//
//  Created by Phil on 1/18/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Enumeration -

/// Fields that can be accessed on database.
enum UserDatabaseField: String {
    
    case username = "username"
    case password = "passcode"
    case gems = "gems"
    
    case favoriteColor = "favorite-color"
    case ageGroup = "age-group"
    case favoriteGenre = "favorite-genre"
    case identity = "identity"
    
    case facebookID = "facebook-id"
    case facebookName = "facebook-name"
}

// MARK: - Class -

/// Local representation of information found in *clients* database.
class User {
    
    static var current: User!
    
    let username: String
    let password: String
    var gems: Int = 0
    
    var favoriteColor: CubeColor = .none
    var ageGroup: AgeGroup = .adult
    var favoriteGenre: CollabrationGenre = .foodie
    var identity: Identity = .unknown
    
    var facebookID: String?
    var facebookName: String?
    
    // MARK: - Initializers -
    
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
        
        guard let profileInfo = userInfo["profile"] as? [String: Any] else { return nil }
        
        favoriteColor = CubeColor.color(fromString: profileInfo[UserDatabaseField.favoriteColor.rawValue] as? String)
        
        ageGroup = AgeGroup.ageGroup(fromString: profileInfo[UserDatabaseField.ageGroup.rawValue] as? String)
        
        favoriteGenre = CollabrationGenre.genre(fromString: profileInfo[UserDatabaseField.favoriteGenre.rawValue] as? String)
        
        identity = Identity.identity(fromString: profileInfo[UserDatabaseField.identity.rawValue] as? String)
    }
}
