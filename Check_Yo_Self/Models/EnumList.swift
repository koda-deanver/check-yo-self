//********************************************************************
//  PlayerData.swift
//  Check Yo Self
//  Created by Phil on 3/8/17
//
//  Description: Hold all enumerations
//********************************************************************

import Foundation

// The phases of Collabration
enum CreationPhase: String{
    case check = "Check"
    case brainstorm = "Brainstorm"
    case develop = "Develop"
    case align = "Align"
    case improve = "Improve"
    case make = "Make"
    case none = "Profile"
}

enum AvatarIdentity{
    case male
    case female
    case other
}

// Possible errors to handle
enum ErrorType{
    case question(String)
    case connection(Error)
    case permissions(String)
    case data(String)
}

// List of connectable devices
enum ConnectionType: String{
    case cube = "Cube"
    case facebook = "Facebook"
    case health = "Health"
    case fitbit = "Fitbit"
    case maps = "Maps"
    case musically = "Musically"
    case emotiv = "Emotiv"
    case occulus = "Occulus"
    case thingyverse = "Thingyverse"
}

// Color of player and associated information
enum CubeColor: String{
    case none = "None"
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
    case cyan = "Cyan"
    case magenta = "Magenta"
    case yellow = "Yellow"
    
    func intValue() -> Int{
        switch self{
        case .none:
            return 0
        case .red:
            return 1
        case .green:
            return 2
        case .blue:
            return 3
        case .cyan:
            return 4
        case .magenta:
            return 5
        case .yellow:
            return 6
        }
    }
    
    static func cubeColorForInt(_ value: Int) -> CubeColor?{
        switch value{
        case 0:
            return .none
        case 1:
            return .red
        case 2:
            return .green
        case 3:
            return .blue
        case 4:
            return .cyan
        case 5:
            return .magenta
        case 6:
            return .yellow
        default:
            return nil
        }
    }
    
    func rgbColor() -> UIColor{
        switch self{
        case .none:
            return UIColor(colorLiteralRed: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        case .red:
            return UIColor(colorLiteralRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .green:
            return UIColor(colorLiteralRed: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case .blue:
            return UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .cyan:
            return UIColor(colorLiteralRed: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .magenta:
            return UIColor(colorLiteralRed: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .yellow:
            return UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        }
    }
}

// Style of background (Adult/Kid)
enum DesignStyle{
    case adult
    case child
}

// Status of connection
enum ConnectionStatus: String{
    case connected = "Connected"
    case notConnected = "Not Connected"
}
