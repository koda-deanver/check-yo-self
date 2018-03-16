//
//  Configuration.swift
//  check-yo-self
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
typealias BoolClosure = (Bool) -> Void
typealias IntClosure = (Int) -> Void

// MARK: - Constants -

struct Constants {
    
    static let rowHeightNormal: CGFloat = 60.0

    static let firebaseRootPath = Database.database().reference(fromURL: "https://check-yo-self-18682434.firebaseio.com/")
}

// MARK: - Font -

struct Font {
    
    /// Font used to style titles and important things.
    static let heavy = "Arial Rounded MT Bold"
    /// Font used for the bulk of the app.
    static let main = "Arial"
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

struct Configuration {
    
    // Ads
    static let showAds = false
    
    // Questions
    static let questionsPerRound = 20
    
    // For username
    static let usernameMinLength = 1
    static let usernameMaxLength = 20
    static let passcodeLength = 6
    
    // Alerts
    static let daysUntilComebackAlert = 2
}

