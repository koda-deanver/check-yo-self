//
//  DataManager.swift
//  Check_Yo_Self
//
//  Created by Phil on 1/18/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class DataManager {
    
    static let shared = DataManager()
    
    func getUser(withCredentials credentials: (username: String, password: String), completion: @escaping (User) -> Void, failure: @escaping (String) -> Void) {
    
        BSGFirebaseService.fetchData(atPath: FIREBASE_ROOT.child("clients"), completion: { snapshot in
            
            guard let clients = snapshot.value as? [String: Any] else {
                failure("Connection Error")
                return
            }
            
            // Find matching user
            for userRecord in clients where userRecord.key == credentials.username {
                
                guard let user = User(withUserRecord: userRecord) else {
                    failure("User not found")
                    return
                }
                
                guard user.password == credentials.password else {
                    failure("Incorrect Password")
                    return
                }
                
                completion(user)
                return
            }
            failure("User not found")
            
        }, failure: {
            failure("Connection Error")
        })
    }
}
