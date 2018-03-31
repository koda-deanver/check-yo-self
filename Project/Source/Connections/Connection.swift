//
//  Connection.swift
//  check-yo-self
//
//  Created by phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Enumerations -

// List of connection types.
enum ConnectionType: String {
    
    case facebook = "Facebook"
    case healthKit = "HealthKit"
    case fitbit = "Fitbit"
    case maps = "Maps"
    case camera = "Camera"
    
    case cube = "Cube"
    case musically = "Musically"
    case emotiv = "Emotiv"
    case occulus = "Occulus"
    case thingyverse = "Thingyverse"
    
    /// Image to be displayed on connections screen.
    var image: UIImage? {
        switch self {
        case .facebook: return #imageLiteral(resourceName: "facebook")
        case .healthKit: return #imageLiteral(resourceName: "health")
        case .fitbit: return #imageLiteral(resourceName: "fitbit")
        case .maps: return #imageLiteral(resourceName: "maps")
        case .camera: return #imageLiteral(resourceName: "camera")
        default: return nil
        }
    }
    
    static var existing: [ConnectionType] = [.facebook, .healthKit, .fitbit, .maps, .camera]
}

/// Every possible state for *ConnectionView*.
enum ConnectionState {
    case connected, unconnected, pending
}

// MARK: - Class -

final class Connection {
    
    // MARK: - Public Members -
    
    /// The type of connection. EX: Fitbit.
    let type: ConnectionType
    /// Current state of connection.
    var state: ConnectionState = .unconnected {
        didSet {
            cell?.style(for: state)
        }
    }
    /// cell that is displaying connection.
    weak var cell: ConnectionCell?
    
    // MARK: - Initializers -
    
    init(withType type: ConnectionType) {
        self.type = type
    }
}
