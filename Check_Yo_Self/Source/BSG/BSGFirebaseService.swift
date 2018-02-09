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

    // MARK: - Static Members -
    
    /// Used to force a second attempt after strange first fail 
    static var isFirstAttempt = true
    
    // MARK: - Static Methods -
    
    ///
    /// Update dictionary of values to path.
    ///
    /// - parameter path: Path to update data.
    /// - parameter values: Values to update to database.
    /// - parameter success: Successful update completion.
    /// - parameter failure: Handles failure to update data.
    ///
    static func updateData(atPath path: DatabaseReference, values: [String: Any], success: @escaping Closure = {}, failure: @escaping Closure = {}) {
        
        checkConnection(completion: { isConnected in
            
            if isConnected {
                path.updateChildValues(values)
                success()
            } else {
                if isFirstAttempt {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                        updateData(atPath: path, values: values, success: success, failure: failure)
                    } )
                } else {
                    failure()
                }
                isFirstAttempt = false
            }
            
        })
    }
    
    ///
    /// Get snapshot of data at path.
    ///
    /// - parameter path: Path to retreive data from.
    /// - parameter success: Successful completion containing snapshot of data.
    /// - parameter failure: Handles failure to get data.
    ///
    static func fetchData(atPath path: DatabaseReference, success: @escaping (DataSnapshot) -> Void = {_ in }, failure: @escaping Closure = {}){
        
        checkConnection(completion: { isConnected in
            
            if isConnected {
                path.observeSingleEvent(of: .value, with: { snapshot in
                    success(snapshot)
                })
            } else {
                if isFirstAttempt {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                        fetchData(atPath: path, success: success, failure: failure)
                    } )
                } else {
                    failure()
                }
                isFirstAttempt = false
            }
            
        })
    }
    
    ///
    /// Remove all children at the specified path.
    ///
    /// - parameter path: Path to remove.
    /// - parameter success: Successful completion containing snapshot of data.
    /// - parameter failure: Handles failure to get data.
    ///
    static func removeData(atPath path: DatabaseReference, success: @escaping Closure, failure: @escaping Closure = {}) {
        
        checkConnection(completion: { isConnected in
            
            if isConnected {
                path.removeValue()
                success()
            } else {
                if isFirstAttempt {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                        removeData(atPath: path, success: success, failure: failure)
                    } )
                } else {
                    failure()
                }
                isFirstAttempt = false
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

