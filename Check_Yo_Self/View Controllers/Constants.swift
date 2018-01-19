//********************************************************************
//  PlayerData.swift
//  Check Yo Self
//  Created by Phil on 1/18/17
//
//  Description: Provide easy to use general control over app
//********************************************************************

import FirebaseCore
import FirebaseDatabase

// MARK: - Type Alias -

typealias Closure = () -> Void

// MARK: - Constants -

let FIREBASE_ROOT = Database.database().reference(fromURL: "https://check-yo-self-18682434.firebaseio.com/")
let SHOW_ADS = false

let QUESTIONS_PER_ROUND = 20
// not including profile
let VALID_PHASES = 6

// For username
let USERNAME_MIN_LENGTH = 3

// ALERTS
let DAYS_FOR_COME_BACK_ALERT = 2

// Connection that are currently available
let CONNECTIONS: [Connection] = [
    Connection(type: .cube),
    Connection(type: .facebook),
    Connection(type: .health),
    Connection(type: .fitbit),
    Connection(type: .maps)
]
