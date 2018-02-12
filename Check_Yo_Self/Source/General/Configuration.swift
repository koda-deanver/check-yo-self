//
//  Configuration.swift
//  Check_Yo_Self
//
//  Created by Phil Rattazzi on 1/18/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  Acts as control center for app. Various aspects can be tweaked here.
//

import FirebaseCore
import FirebaseDatabase

// MARK: - Type Alias -

typealias Closure = () -> Void
typealias ErrorClosure = (String) -> Void

// MARK: - Constants -

struct Constants {
    
    static let firebaseRootPath = Database.database().reference(fromURL: "https://check-yo-self-18682434.firebaseio.com/")
    
    // Connection that are currently available
    static let connections: [Connection] = [
        Connection(type: .cube),
        Connection(type: .facebook),
        Connection(type: .health),
        Connection(type: .fitbit),
        Connection(type: .maps)
    ]
}

// MARK: - Font -

struct Font {
    static let main = "Arial"
    
    /// Size based on 60 pt for 9 inch iPad.
    static let mediumSize: CGFloat = (60 / 1536) * UIScreen.main.bounds.width
    static let smallSize: CGFloat = (40 / 1536) * UIScreen.main.bounds.width
    static let largeSize: CGFloat = (80 / 1536) * UIScreen.main.bounds.width
}

// MARK: - Configuration -

struct Configuration {
    
    // Ads
    static let showAds = false
    
    // Questions
    static let questionsPerRound = 20
    static let validPhases = 6 /* not including profile */
    
    // For username
    static let usernameMinLength = 1
    static let usernameMaxLength = 20
    static let passcodeLength = 6
    
    // Alerts
    static let daysUntilComebackAlert = 2
}

