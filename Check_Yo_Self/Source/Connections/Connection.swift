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
    case cube = "Cube"
    case facebook = "Facebook"
    case healthKit = "HealthKit"
    case fitbit = "Fitbit"
    case maps = "Maps"
    case musically = "Musically"
    case emotiv = "Emotiv"
    case occulus = "Occulus"
    case thingyverse = "Thingyverse"
}

/// Every possible state for *ConnectionView*.
enum ConnectionState {
    case connected, unconnected, pending
}

// MARK: - Class -

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
        /*switch self.type{
        case .cube:
            self.isConnected = false
        case .facebook:
            if AccessToken.current != nil{
                self.isConnected = true
            }else{
                self.isConnected = false
            }
        case .health:
            PlayerData.sharedInstance.getStepCountHK(completion: {_ in
                self.isConnected = true
            }, failure: {_ in
                self.isConnected = false
            })
        case .fitbit:
            PlayerData.sharedInstance.getHeartRateFB(completion: {_ in
                self.isConnected = true
            }, failure: {errorType in
                switch errorType{
                case .data:
                    self.isConnected = true
                default:
                    self.isConnected = false
                }
            })
        case .maps:
            if PlayerData.sharedInstance.getLocation() != nil{
                self.isConnected = true
            }else{
                self.isConnected = false
            }
        default:
            break
            
        }*/
    
}
