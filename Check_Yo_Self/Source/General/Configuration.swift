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
}

// MARK: - Configuration -

struct Configuration {
    
    // Ads
    static let showAds = false
    
    // Questions
    static let questionsPerRound = 20
    static let validPhases = 6 /* not including profile */
    
    // For username
    static let usernameMinLength = 0
    static let usernameMaxLength = 20
    static let passwordMinLength = 8
    static let passwordMaxLength = 16
    
    // Alerts
    static let daysUntilComebackAlert = 2
}

