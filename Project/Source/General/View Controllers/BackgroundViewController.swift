//
//  BackgroundViewController.swift
//  check-yo-self
//
//  Created by phil on 1/19/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Looms in background for the duration of app displaying background image. Only view controllers with clear background can see it.
class BackgroundViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    /// Used to keep background image same width as the screen. Height is variable based on device.
    private var backgroundImageAspectRatio: CGFloat = 2.165
    /// Used to only show *syncingViewController* once.
    private var didSync = false
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        setupBackgroundImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if !didSync {
            performSegue(withIdentifier: "showSyncing", sender: self)
            didSync = true
        } else {
            performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    
    // MARK: - Private methods -
    
    ///
    /// Place background image in every ViewController.
    ///
    private func setupBackgroundImage() {
        
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenWidth * backgroundImageAspectRatio))
        backgroundImageView.center = view.center
        backgroundImageView.image = #imageLiteral(resourceName: "cuberoom")
        
        self.view.addSubview(backgroundImageView)
        self.view.sendSubview(toBack: backgroundImageView)
    }
}
