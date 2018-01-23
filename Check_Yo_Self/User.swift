//
//  User.swift
//  Check_Yo_Self
//
//  Created by Phil on 1/18/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

struct User {
    
    let username: String
    let password: String
    
    init(withUsername username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    init?(withUserRecord userRecord: (key: String, value: Any)) {
        
        guard let userInfo = userRecord.value as? [String: Any] else { return nil }
        guard let password = userInfo["password"] as? String else { return nil }
        
        self.username = userRecord.key
        self.password = password
    }
}
