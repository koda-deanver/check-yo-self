//
//  AgeGroup.swift
//  check-yo-self
//
//  Created by Phil on 2/13/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

/// Contains possible age groups that affect styling.
enum AgeGroup {
    case youth, adult
    
    /// Image to style skinned VC with.
    var backgroundImage: UIImage {
        switch self {
        case .youth: return #imageLiteral(resourceName: "GradientWhite")
        case .adult: return #imageLiteral(resourceName: "GradientBlack")
        }
    }
}
