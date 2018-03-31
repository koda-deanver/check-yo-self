//
//  CustomTabBar.swift
//  check-yo-self
//
//  Created by phil on 1/10/17.
//  Copyright © 2017 Brook Street Games. All rights reserved.
//

import UIKit

/// Provides custom coloring and other methods.
class CustomTabBar: UITabBarController {

    // MARK: - Public Members -
    
    /// It true, the user is presented with confirmation alert before switching tabs.
    var shouldPromptForTabSwitch = false
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        delegate = self
        
        NotificationManager.shared.addObserver(self, forNotificationType: .profileUpdated, handler: #selector(style))
        style()
    }
    
    ///
    /// Styles tab items with correct color.
    ///
    @objc func style() {
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

// MARK: - UITabBarControllerDelegate -

extension CustomTabBar: UITabBarControllerDelegate {
    
    ///
    /// Ask user before navigating away from *QuestionsViewController* mid-game.
    ///
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if shouldPromptForTabSwitch {
            guard let currentViewController = tabBarController.selectedViewController as? GeneralViewController else { return false }
            currentViewController.showAlert(BSGCustomAlert(message: "Exit game? You will lose your progress.", options: [(text: "Exit", handler: {
                
                self.shouldPromptForTabSwitch = false
                self.selectedViewController = viewController
            }), (text: "Cancel", handler: {})]))
            return false
        } else {
            return true
        }
    }
}
