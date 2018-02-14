//
//  SkinnedViewController.swift
//  Check_Yo_Self
//
//  Created by Phil on 2/13/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Changes background based on profile.
class SkinnedViewController: GeneralViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = User.current?.ageGroup
    }
}
