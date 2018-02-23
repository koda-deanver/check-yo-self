//
//  GeneralViewController.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 12/1/16.
//  Copyright © 2016 ThematicsLLC. All rights reserved.
//

import UIKit
import MBProgressHUD

/// Base class containing common functionality for all View Controllers.
class GeneralViewController: UIViewController {
    
    // MARK: - Public Members -
    
    var screenWidth: CGFloat{ return UIScreen.main.bounds.width }
    var screenHeight: CGFloat{ return UIScreen.main.bounds.height }
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationManager.shared.addObserver(self, forNotificationType: .profileUpdated, handler: #selector(style))
        style()
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Hides keyboard when user taps on screen.
    ///
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    ///
    /// Start progress indicator.
    ///
    func showProgressHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.contentColor = User.current?.favoriteColor.uiColor
    }
    
    ///
    /// Hide progress indicator.
    ///
    func hideProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    ///
    /// Handle error with single button alert.
    ///
    /// - parameter errorMessage: Message to dispplay in alert.
    ///
    func handle(_ errorMessage: String) {
        
        hideProgressHUD()
        
        let alert = BSGCustomAlert(message: errorMessage, options: [(text: "Close", handler: {})])
        self.showAlert(alert)
    }
    
    // MARK: - Private Methods -
    
    @objc func style() {}
    
    ///
    /// Description: Dismisses keyboard.
    ///
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
