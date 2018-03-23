//
//  GeneralViewController.swift
//  check-yo-self
//
//  Created by phil on 12/1/16.
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
        
        style()
        hideKeyboardWhenTappedAround()
        NotificationManager.shared.addObserver(self, forNotificationType: .profileUpdated, handler: #selector(style))
    }
    
    // MARK: - Public Methods -
    
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
    
    ///
    /// Show alert on any ViewController.
    ///
    /// Creates a new instance of BSGCustomAlertController and displays in as a child of current ViewController.
    ///
    /// - parameter alert: Custom alert to show.
    ///
    func showAlert(_ alert: BSGCustomAlert){
        
        let color = User.current != nil ? User.current.favoriteColor : .none
        BSGVerticalButtonAlertController.configure(withAnimationDuration: 0.25, backgroundImage: color.alertBackdrop, messageFont: Font.main, buttonFont: Font.main, buttonTextColor: .black, buttonImage: color.buttonImage)
        
        let alertController = BSGVerticalButtonAlertController()
        alertController.alert = alert
        self.addChildViewController(alertController)
        alertController.view.frame = self.view.frame
        alertController.view.layer.zPosition = 10
        self.view.addSubview(alertController.view)
        alertController.didMove(toParentViewController: self)
    }
    
    // MARK: - Private Methods -
    
    @objc func style() {}
    
    ///
    /// Sets up dismissal of keyboard when user taps on screen.
    ///
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    ///
    /// Dismisses keyboard.
    ///
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
