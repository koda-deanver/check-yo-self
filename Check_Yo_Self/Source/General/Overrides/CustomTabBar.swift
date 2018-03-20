//
//  CustomTabBar.swift
//  check-yo-self
//
//  Created by phil on 1/10/17.
//  Copyright © 2017 Brook Street Games. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        delegate = self
        
        tabBar.tintColor = User.current.favoriteColor.uiColor
        
        tabBar.barTintColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor.white
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Enables or disables tab bar items.
    ///
    /// - parameter shouldEnable: If true, tab bar items will be enabled.
    ///
    func setTabs(_ shouldEnable: Bool){
        
        guard let tabBarItems = tabBar.items else { return }
        
        for item in tabBarItems {
            item.isEnabled = shouldEnable
        }
    }
}
