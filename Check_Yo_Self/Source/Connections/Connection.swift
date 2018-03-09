//
//  Connection.swift
//  check-yo-self
//
//  Created by Phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Enumerations -

// List of connection types.
enum ConnectionType: String{
    case facebook = "Facebook"
    case healthKit = "HealthKit"
    case fitbit = "Fitbit"
    case cube = "Cube"
    case maps = "Maps"
    case musically = "Musically"
    case emotiv = "Emotiv"
    case occulus = "Occulus"
    case thingyverse = "Thingyverse"
    
    static var existing: [ConnectionType] = [.facebook, .healthKit, .fitbit]
}

/// Every possible state for *ConnectionView*.
enum ConnectionState {
    case connected, unconnected, pending
}

// MARK: - Struct -

struct Connection {
    
    // MARK: - Public Members -
    
    /// The type of connection. EX: Fitbit.
    let type: ConnectionType
    /// Current state of connection.
    var state: ConnectionState = .unconnected
    
    // MARK: - Initializers -
    
    init(withType type: ConnectionType) {
        self.type = type
    }
}
