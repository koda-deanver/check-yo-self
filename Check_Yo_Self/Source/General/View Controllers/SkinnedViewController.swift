//
//  SkinnedViewController.swift
//  check-yo-self
//
//  Created by phil on 2/13/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Changes background based on profile.
class SkinnedViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    private var backgroundImageView: UIImageView!
    
    // MARK: - Lifecycle -
    
    override func style() {
        super.style()
        setupBackdrop()
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Style with correct backdrop based on age.
    ///
    private func setupBackdrop() {
        
        if backgroundImageView != nil { backgroundImageView?.removeFromSuperview() }
        
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        backgroundImageView.center = view.center
        backgroundImageView.image = User.current.ageGroup.backgroundImage
        
        self.view.addSubview(backgroundImageView)
        self.view.sendSubview(toBack: backgroundImageView)
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Removes background image.
    ///
    func removeBackdrop() {
        backgroundImageView.removeFromSuperview()
    }
}
