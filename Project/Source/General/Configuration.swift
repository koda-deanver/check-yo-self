//
//  Configuration.swift
//  check-yo-self
//
//  Created by phil on 1/18/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  Acts as control center for app. Various aspects can be tweaked here.
//

import FirebaseCore
import FirebaseDatabase

// MARK: - Type Alias -

typealias Closure = () -> Void
typealias ErrorClosure = (String) -> Void
typealias BoolClosure = (Bool) -> Void
typealias IntClosure = (Int) -> Void

// MARK: - Constants -

struct Constants {
    
    static let rowHeightSmall: CGFloat = 40.0
    static let rowHeightNormal: CGFloat = 60.0

    static let firebaseRootPath = Database.database().reference(fromURL: "https://check-yo-self-18682434.firebaseio.com/")
}

// MARK: - Font -

struct Font {
    
    /// Font used to style titles and important things.
    static let heavy = "Arial Rounded MT Bold"
    /// Font used for the bulk of the app.
    static var main = "Arial"
    /// Font used for things that should never really be styled.
    static let pure = "Arial Rounded MT Bold"
    
    /// Scalable size based on 60 pt for 9 inch iPad.
    static let mediumSize: CGFloat = (60 / 1536) * UIScreen.main.bounds.width
    /// Scalable size based on 40 pt for 9 inch iPad.
    static let smallSize: CGFloat = (40 / 1536) * UIScreen.main.bounds.width
    /// Scalable size based on 100 pt for 9 inch iPad.
    static let largeSize: CGFloat = (100 / 1536) * UIScreen.main.bounds.width
}

// MARK: - Configuration -

/// Configuration for the overall CollabRJabbR universe.
struct Configuration {
    
    // MARK: - From Database -

    static var gamertagMaxLength = 20
    static var passwordMinLength = 8
}

// MARK: - GameConfiguration -

/// Configuration specific to Check Yo Self.
struct GameConfiguration {
    
    // MARK: - From Database -
    
    /// Percentage of time ad is shown when finishing game.
    static var adFrequency = 50
    
    // MARK: - Local -
    
    static let gameRecordMax = 100
    static let questionsPerRound = 20
    static let playsPerDay = 3
}

///
/// Loads general and game configuration from database.
///
/// - parameter completion: Completion handler for configuration finished, success or failure.
///
func loadConfiguration(_ completion: Closure?) {
    
    BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("configuration"), success: { snapshot in
        
        guard let configuration = snapshot.value as? [String: Any] else {
            loadGameConfiguration(completion)
            return
        }
        
        Configuration.gamertagMaxLength = configuration["gamertag-length-max"] as? Int ?? Configuration.gamertagMaxLength
        Configuration.passwordMinLength = configuration["password-length-min"] as? Int ?? Configuration.passwordMinLength
        
        loadGameConfiguration(completion)
    }, failure: { loadGameConfiguration(completion) })
}

///
/// Loads game configuration from database.
///
/// - parameter completion: Completion handler for configuration finished, success or failure.
///
fileprivate func loadGameConfiguration(_ completion: Closure?) {
    
    BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("check-yo-self/configuration"), success: { snapshot in
        
        guard let configuration = snapshot.value as? [String: Any] else { return }
        
        GameConfiguration.adFrequency = configuration["ad-frequency"] as? Int ?? GameConfiguration.adFrequency
        Font.main = configuration["font-main"] as? String ?? Font.main
        
        completion?()
        
    }, failure: completion)
}

