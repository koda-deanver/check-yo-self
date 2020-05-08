//
//  BSGFacebookService.swift
//  stack_300
//
//  Created by Phil Rattazzi on 6/5/17
//  Copyright © 2017 Brook Street Games. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore

// MARK: - Typealias -

/// Closure containing BSGFacebookError.
typealias BSGFacebookErrorClosure = (BSGFacebookError) -> Void

// MARK: - Enum -

/// Error types returned in Facebook error handlers.
enum BSGFacebookError {
    case missingAccessToken, connectionFailed, missingData, cancelledAction
}

///  Contains functions for interfacing with Facebook.
class BSGFacebookService {
    
    // MARK: - Public Members -
    
    /// Bool indicating is user is currently logged in.
    static var isLoggedIn: Bool { return AccessToken.current != nil }
    
    // MARK: - Static Methods -
    
    ///
    /// Handles login to Facebook.
    ///
    /// - parameter completion: Handler for successful login.
    /// - parameter failure: Handler login failure containing error.
    ///
    static func login(completion: Closure? = nil, failure: BSGFacebookErrorClosure? = nil) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [Permission.publicProfile, Permission.userFriends]) { loginResult in
            switch loginResult {
            case .failed: failure?(.connectionFailed)
            case .cancelled: failure?(.cancelledAction)
            case .success(_, _, _): completion?()
            }
        }
    }
    
    ///
    /// Logs user out of Facebook
    ///
    static func logout() {
        LoginManager().logOut()
    }
    
    ///
    /// Get Facebook user image.
    ///
    /// - parameter facebookID: ID of user to get image for.
    ///
    /// - returns: User Facebook image as UIImage.
    ///
    static func getImage(forID facebookID: String) -> UIImage? {
        
        let picURL = URL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large")!
        let facebookImageData = try? Data(contentsOf: picURL)
        return (facebookImageData != nil) ? UIImage(data: facebookImageData!) : nil
    }
    
    ///
    /// Get user name and pic from Facebook.
    ///
    /// - parameter completion: Closure containing ID and name.
    /// - parameter failure: Handles failure to get user data.
    ///
    static func getUser(completion: @escaping ((id: String, name: String)) -> Void, failure: BSGFacebookErrorClosure? = nil){
        
        guard AccessToken.current != nil else {
            failure?(.missingAccessToken)
            return
        }
        
        // Request info
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, name"])) { httpResponse, result, error in
            print("Response : \(String(describing: httpResponse))")
            print("RESULT : \(String(describing: result))")
            
            if error != nil {
                failure?(.connectionFailed)
                return
            }
            
            
            guard let facebookDictionary = result as? [String: Any], let facebookID = facebookDictionary["id"] as? String, let facebookName = facebookDictionary["name"] as? String else {
                failure?(.missingData)
                return
            }
            completion((id: facebookID, name: facebookName))
            
//            switch result {
//
//            case .success(let response):
//
//            guard let facebookDictionary = response.dictionaryValue, let facebookID = facebookDictionary["id"] as? String, let facebookName = facebookDictionary["name"] as? String else {
//                failure?(.missingData)
//                return
//            }
//            completion((id: facebookID, name: facebookName))
//
//            case .failed: failure?(.connectionFailed)
//            }
        }
        connection.start()
    }
    
    ///
    /// Get friends from FB.
    ///
    static func getFriends(completion: @escaping ([(id: String, name: String)]) -> Void, failure: BSGFacebookErrorClosure? = nil){
        
        guard AccessToken.current != nil else {
            failure?(.missingAccessToken)
            return
        }
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "friends"])) { httpResponse, result, error in
            print("Response : \(String(describing: httpResponse))")
            print("RESULT : \(String(describing: result))")
            
            if error != nil {
                failure?(.connectionFailed)
                return
            }
            
            if let facebookDictionary = result as? [String: Any] {
                if let friendResponse = facebookDictionary["friends"] as? [String: Any] {
                    if let friends = friendResponse["data"] as? [[String: Any]] {
                        
                        var friendArray: [(id: String, name: String)] = []
                        for friend in friends {
                            guard let facebookID = friend["id"] as? String, let facebookName = friend["name"] as? String else { continue }
                            
                            let friend = (id: facebookID, name: facebookName)
                            friendArray.append(friend)
                        }
                        completion(friendArray)
                    }
                }
            }
            
//            switch result {
//            case .success(let response):
//                if let facebookDictionary = response.dictionaryValue{
//                    if let friendResponse = facebookDictionary["friends"] as? [String: Any]{
//                        if let friends = friendResponse["data"] as? [[String: Any]]{
//
//                            var friendArray: [(id: String, name: String)] = []
//                            for friend in friends{
//                                guard let facebookID = friend["id"] as? String, let facebookName = friend["name"] as? String else { continue }
//
//                                let friend = (id: facebookID, name: facebookName)
//                                friendArray.append(friend)
//                            }
//                            completion(friendArray)
//                        }
//                    }
//            }
//            case .failed: failure?(.connectionFailed)
//            }
        }
        connection.start()
    }
}

