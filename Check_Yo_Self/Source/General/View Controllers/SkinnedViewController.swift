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
        setupBackdrop()
    }
    
    ///
    /// Style with correct backdrop based on age.
    ///
    private func setupBackdrop() {
        
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        backgroundImageView.center = view.center
        backgroundImageView.image = User.current.ageGroup.backgroundImage
        
        self.view.addSubview(backgroundImageView)
        self.view.sendSubview(toBack: backgroundImageView)
    }
}
