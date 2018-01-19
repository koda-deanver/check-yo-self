//
//  BSGFirebaseService.swift
//  stack_300
//
//  Created by Phil Rattazzi on 4/28/17
//  Copyright © 2017 Brook Street Games. All rights reserved.
//
//  Contains functions for retrieving and saving data to
//  Firebase server.
//

import FirebaseDatabase
import FirebaseCore
import Firebase

class BSGFirebaseService {

    // MARK: - Static Methods -
    
    ///
    /// Update dictionary of values to path.
    ///
    /// - parameter path: Path to update data.
    /// - parameter values: Values to update to database.
    /// - parameter completion: Successful update completion.
    /// - parameter failure: Handles failure to update data.
    ///
    static func updateNode(atPath path: DatabaseReference, values: [String: Any], completion: @escaping Closure = {}, failure: @escaping Closure = {}) {
        
        checkConnection(completion: { isConnected in
            
            if isConnected {
                path.updateChildValues(values)
                completion()
            } else {
                failure()
            }
            
        })
    }
    
    ///
    /// Get snapshot of data at path.
    ///
    /// - parameter path: Path to retreive data from.
    /// - parameter completion: Successful completion containing snapshot of data.
    /// - parameter failure: Handles failure to get data.
    ///
    static func fetchData(atPath path: DatabaseReference, completion: @escaping (DataSnapshot) -> Void = {_ in }, failure: @escaping Closure = {}){
        
        checkConnection(completion: { isConnected in
            
            if isConnected {
                path.observeSingleEvent(of: .value, with: { snapshot in
                    completion(snapshot)
                })
            } else {
                failure()
            }
            
        })
    }
    
    ///
    /// Remove all children at the specified path.
    ///
    /// - parameter path: Path to remove.
    /// - parameter completion: Successful completion containing snapshot of data.
    /// - parameter failure: Handles failure to get data.
    ///
    static func removeNode(atPath path: DatabaseReference, completion: @escaping Closure, failure: @escaping Closure = {}) {
        
        checkConnection(completion: { isConnected in
            
            if isConnected {
                path.removeValue()
                completion()
            } else {
                failure()
            }
            
        })
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Check for connection to database before acting.
    ///
    /// - parameter completion: Completion handler containing Bool that indicates if there is a connection.
    ///
    private static func checkConnection(completion: @escaping (Bool) -> Void) {
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        
        connectedRef.observeSingleEvent(of: .value, with: { snapshot in
            
            let isConnected = (snapshot.value as? Bool) == true
            completion(isConnected)
        })
    }

}

