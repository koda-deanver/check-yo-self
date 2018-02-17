//
//  AgeGroup.swift
//  check-yo-self
//
//  Created by Phil on 2/13/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

/// Contains possible age groups that affect styling of background.
enum AgeGroup: String {
    case youth, adult
    
    /// Image to style skinned VC with.
    var backgroundImage: UIImage {
        switch self {
        case .youth: return #imageLiteral(resourceName: "GradientWhite")
        case .adult: return #imageLiteral(resourceName: "GradientBlack")
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
    case live, foodie, publications, lensed, selling, realEstate = "real-estate"
    
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
    case femaleStraight = "female-straight"
    case femaleGay = "female-gay"
    case unknown = "unknown"
    
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
