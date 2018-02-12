//
//  JabbrColor.swift
//  Check_Yo_Self
//
//  Created by Phil on 2/11/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

/// Represents the six colors of CollabrJabbr.
enum JabbrColor: String {
    
    case red, green, blue, cyan, magenta, yellow, none
    
    /// The background image for alerts.
    var alertBackdrop: UIImage {
        switch self {
        case .red: return #imageLiteral(resourceName: "AlertBackdropRed")
        case .green: return #imageLiteral(resourceName: "AlertBackdropGreen")
        case .blue: return #imageLiteral(resourceName: "AlertBackdropBlue")
        case .cyan: return #imageLiteral(resourceName: "AlertBackdropCyan")
        case .magenta: return #imageLiteral(resourceName: "AlertBackdropMagenta")
        case .yellow: return #imageLiteral(resourceName: "AlertBackdropYellow")
        case .none: return #imageLiteral(resourceName: "AlertBackdropGray")
        }
    }
    
    /// The button image to display on alerts and in the game.
    var buttonImage: UIImage {
        switch self {
        case .red: return #imageLiteral(resourceName: "GameButtonRed")
        case .green: return #imageLiteral(resourceName: "GameButtonGreen")
        case .blue: return #imageLiteral(resourceName: "GameButtonBlue")
        case .cyan: return #imageLiteral(resourceName: "GameButtonCyan")
        case .magenta: return #imageLiteral(resourceName: "GameButtonMagenta")
        case .yellow: return #imageLiteral(resourceName: "GameButtonYellow")
        case .none: return #imageLiteral(resourceName: "GameButtonGray")
        }
    }
    
    ///
    /// Returns a JabbrColor if it matches string, otherwise returns none.
    ///
    /// - parameter string: The string to match a color to.
    ///
    /// - returns: A color matching the given string, if there is one.
    ///
    static func colorFromString(_ string: String) -> JabbrColor {
        return JabbrColor(rawValue: string) ?? .none
    }
}
