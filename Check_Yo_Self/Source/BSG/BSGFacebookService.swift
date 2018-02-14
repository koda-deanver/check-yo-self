//
//  BSGFacebookService.swift
//  stack_300
//
//  Created by Phil Rattazzi on 6/5/17
//  Copyright © 2017 Brook Street Games. All rights reserved.
//
//  Contains functions for interfacing with Facebook.
//

import Foundation
import FacebookLogin
import FacebookCore

enum BSGFacebookError {
    case accessToken, connection
}

class BSGFacebookService{
    
    // MARK: - Static Methods -
    
    ///
    /// Handles login to Facebook.
    ///
    /// - parameter completion: Handles successful login.
    /// - parameter failure: Handles login failure.
    ///
    static func login(completion: @escaping Closure = {}, failure: @escaping Closure = {}) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, ReadPermission.userFriends]) { loginResult in
            switch loginResult {
            case .failed: failure()
            case .cancelled: failure()
            case .success(_, _, _): completion()
            }
        }
    }
    
    ///
    /// Handles log out from Facebook
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
        
        // Set image if available
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
    static func loadUser(completion: @escaping ((id: String, name: String)) -> Void, failure: Closure?){
        
        guard AccessToken.current != nil else {
            failure?()
            return
        }
        
        // Request info
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, name"])) { httpResponse, result in
            switch result {
                
            case .success(let response):
                
            guard let facebookDictionary = response.dictionaryValue, let facebookID = facebookDictionary["id"] as? String, let facebookName = facebookDictionary["name"] as? String else {
                failure?()
                return
            }
            completion((id: facebookID, name: facebookName))
                
            case .failed: failure?()
            }
        }
        connection.start()
    }
    
    ///
    /// Get friends from FB.
    ///
    static func getFriends(completion: @escaping ([(id: String, name: String)]) -> Void, failure: ((BSGFacebookError) -> Void)?){
        
        guard AccessToken.current != nil else {
            failure?(.accessToken)
            return
        }
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "friends"])) { httpResponse, result in
            switch result {
            case .success(let response):
                if let facebookDictionary = response.dictionaryValue{
                    if let friendResponse = facebookDictionary["friends"] as? [String: Any]{
                        if let friends = friendResponse["data"] as? [[String: Any]]{
                            
                            var friendArray: [(id: String, name: String)] = []
                            for friend in friends{
                                guard let facebookID = friend["id"] as? String, let facebookName = friend["name"] as? String else { continue }
                                
                                let friend = (id: facebookID, name: facebookName)
                                friendArray.append(friend)
                            }
                            completion(friendArray)
                        }
                    }
            }
            case .failed: failure?(.connection)
            }
        }
        connection.start()
    }
}

