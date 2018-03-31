//
//  ProfileInfo.swift
//  check-yo-self
//
//  Created by phil on 2/13/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  Conatins enumerations for profile data of user.
//

import Foundation

/// Represents the six colors of CollabrJabbr.
enum CubeColor: String {
    
    case red, green, blue, cyan, magenta, yellow, none
    
    /// The background image for alerts.
    var alertBackdrop: UIImage {
        switch self {
        case .red: return #imageLiteral(resourceName: "alert-backdrop-red")
        case .green: return #imageLiteral(resourceName: "alert-backdrop-green")
        case .blue: return #imageLiteral(resourceName: "alert-backdrop-blue")
        case .cyan: return #imageLiteral(resourceName: "alert-backdrop-cyan")
        case .magenta: return #imageLiteral(resourceName: "alert-backdrop-magenta")
        case .yellow: return #imageLiteral(resourceName: "alert-backdrop-yellow")
        case .none: return #imageLiteral(resourceName: "alert-backdrop-gray")
        }
    }
    
    /// The background image for connection buttons.
    var connectionBackdrop: UIImage {
        switch self {
        case .red: return #imageLiteral(resourceName: "raised-square-red")
        case .green: return #imageLiteral(resourceName: "raised-square-green")
        case .blue: return #imageLiteral(resourceName: "raised-square-blue")
        case .cyan: return #imageLiteral(resourceName: "raised-square-cyan")
        case .magenta: return #imageLiteral(resourceName: "raised-square-magenta")
        case .yellow: return #imageLiteral(resourceName: "raised-square-yellow")
        case .none: return #imageLiteral(resourceName: "raised-square-gray")
        }
    }
    
    /// The button image to display on alerts and in the game.
    var buttonImage: UIImage {
        switch self {
        case .red: return #imageLiteral(resourceName: "button-sharp-red")
        case .green: return #imageLiteral(resourceName: "button-sharp-green")
        case .blue: return #imageLiteral(resourceName: "button-sharp-blue")
        case .cyan: return #imageLiteral(resourceName: "button-sharp-cyan")
        case .magenta: return #imageLiteral(resourceName: "button-sharp-magenta")
        case .yellow: return #imageLiteral(resourceName: "button-sharp-yellow")
        case .none: return #imageLiteral(resourceName: "button-sharp-gray")
        }
    }
    
    /// Color in UIColor form.
    var uiColor: UIColor {
        
        switch self{
        case .red: return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .green: return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case .blue: return UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .cyan: return UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .magenta: return UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .yellow: return UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case .none: return UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        }
    }
    
    ///
    /// Returns a JabbrColor if it matches string, otherwise returns none.
    ///
    /// - parameter string: The string to match a color to.
    ///
    /// - returns: A color matching the given string, if there is one.
    ///
    static func color(fromString string: String?) -> CubeColor {
        guard let string = string else { return .none }
        return CubeColor(rawValue: string) ?? .none
    }
}

/// Contains possible age groups that affect styling of background.
enum AgeGroup: String {
    case youth, adult
    
    /// Image to style skinned VC with.
    var backgroundImage: UIImage {
        switch self {
        case .youth: return #imageLiteral(resourceName: "gradient-white")
        case .adult: return #imageLiteral(resourceName: "gradient-black")
        }
    }
    
    /// Color to style labels with.
    var textColor: UIColor {
        switch self {
        case .youth: return .black
        case .adult: return .white
        }
    }
    
    ///
    /// Returns an AgeGroup if it matches string, otherwise defaults to adult.
    ///
    /// - parameter string: Value to get AgeGroup for.
    ///
    /// - returns: An AgeGroup matching the given string.
    ///
    static func ageGroup(fromString string: String?) -> AgeGroup {
        guard let string = string else { return .adult }
        return AgeGroup(rawValue: string) ?? .adult
    }
}

/// Contains all genres of collabration used to choose avatar.
enum CollabrationGenre: String {
    case general, live, foodie, publications, lensed, selling, realEstate = "real-estate"
    
    ///
    /// Returns a CollabrationGenre if it matches string, otherwise defaults to live.
    ///
    /// - parameter string: Value to get CollabrationGenre for.
    ///
    /// - returns: A CollabrationGenre matching the given string.
    ///
    static func genre(fromString string: String?) -> CollabrationGenre {
        guard let string = string else { return .live }
        return CollabrationGenre(rawValue: string) ?? .live
    }
}

/// Contains all possible identities used to choose avatar.
enum Identity: String {
    case straightMale = "male-straight"
    case gayMale = "male-gay"
    case straightFemale = "female-straight"
    case gayFemale = "female-gay"
    case unknown = "unknown"
    
    /// Value to show in avatar description.
    var displayedIdentity: String {
        switch self {
        case .straightMale, .gayMale: return "male"
        case .straightFemale, .gayFemale: return "female"
        case .unknown: return "unknown"
        }
    }
    
    ///
    /// Returns an Identity if one matches string, otherwise defaults to unknown.
    ///
    /// - parameter string: Value to get genre for.
    ///
    /// - returns: An Identity matching the given string.
    ///
    static func identity(fromString string: String?) -> Identity {
        guard let string = string else { return .unknown }
        return Identity(rawValue: string) ?? .unknown
    }
}
