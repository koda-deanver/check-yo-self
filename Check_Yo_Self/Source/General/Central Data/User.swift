//
//  User.swift
//  check-yo-self
//
//  Created by phil on 1/18/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Enumeration -

/// Fields that can be accessed on database.
enum UserDatabaseField: String {
    
    case uid = "uid"
    case email = "email"
    case gems = "gems"
    
    case gamertag = "gamertag"
    case facebookID = "facebook-id"
    case facebookName = "facebook-name"
    
    case favoriteColor = "favorite-color"
    case ageGroup = "age-group"
    case favoriteGenre = "favorite-genre"
    case identity = "identity"
}

// MARK: - Class -

/// Local representation of information found in *clients* database.
class User {
    
    static var current: User!
    
    // Required
    let uid: String
    let email: String
    var gems: Int = 0 { didSet{ if gems < 0 { gems = 0 }}}
    
    // Optional
    var gamertag: String?
    var facebookID: String?
    var facebookName: String?
    
    // Profile
    var favoriteColor: CubeColor = .none
    var ageGroup: AgeGroup = .adult
    var favoriteGenre: CollabrationGenre = .foodie
    var identity: Identity = .unknown
    
    // MARK: - Initializers -
    
    init(withID uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
    init?(withSnapshot snapshot: [String: Any]) {
        
        guard let uid = snapshot[UserDatabaseField.uid.rawValue] as? String, let email = snapshot[UserDatabaseField.email.rawValue] as? String else { return nil }
        
        self.uid = uid
        self.email = email
        
        let gemsString = snapshot[UserDatabaseField.gems.rawValue] as? String ?? "0"
        gems = Int(gemsString) ?? 0
        
        gamertag = snapshot[UserDatabaseField.gamertag.rawValue] as? String
        facebookID = snapshot[UserDatabaseField.facebookID.rawValue] as? String
        facebookName = snapshot[UserDatabaseField.facebookName.rawValue] as? String
        
        guard let profileInfo = snapshot["profile"] as? [String: Any] else { return nil }
        
        favoriteColor = CubeColor.color(fromString: profileInfo[UserDatabaseField.favoriteColor.rawValue] as? String)
        
        ageGroup = AgeGroup.ageGroup(fromString: profileInfo[UserDatabaseField.ageGroup.rawValue] as? String)
        
        favoriteGenre = CollabrationGenre.genre(fromString: profileInfo[UserDatabaseField.favoriteGenre.rawValue] as? String)
        
        identity = Identity.identity(fromString: profileInfo[UserDatabaseField.identity.rawValue] as? String)
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Turns user into snapshot to be saved to database.
    ///
    /// - returns: Dictionary representation of user.
    ///
    func toSnapshot() -> [String: Any] {
        
        let profileSnapshot: [String: Any] = [
            UserDatabaseField.favoriteColor.rawValue : "\(favoriteColor.rawValue)",
            UserDatabaseField.ageGroup.rawValue : "\(ageGroup.rawValue)",
            UserDatabaseField.favoriteGenre.rawValue : "\(favoriteGenre.rawValue)",
            UserDatabaseField.identity.rawValue : "\(identity.rawValue)"
        ]
        
        var userSnapshot: [String: Any] = [
            UserDatabaseField.uid.rawValue: uid,
            UserDatabaseField.email.rawValue: email,
            "profile": profileSnapshot
        ]
        
        // Add gamertag if present.
        if let gamertag = gamertag {
            userSnapshot[UserDatabaseField.gamertag.rawValue] = gamertag
        }
        
        // Add facebook info if present.
        if let facebookID = facebookID, let facebookName = facebookName {
            userSnapshot[UserDatabaseField.facebookID.rawValue] = facebookID
            userSnapshot[UserDatabaseField.facebookName.rawValue] = facebookName
        }
        
        return userSnapshot
    }
}
