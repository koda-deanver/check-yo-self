//
//  GeneralViewController.swift
//  Check_Yo_Self
//
//  Created by Phil Rattazzi on 12/1/16.
//  Copyright © 2016 ThematicsLLC. All rights reserved.
//
//  Base class for all View Controllers.
//

import UIKit

class GeneralViewController: UIViewController, UITextFieldDelegate{
    
    // MARK: - Public Members -
    
    var screenWidth: CGFloat{ return UIScreen.main.bounds.width }
    var screenHeight: CGFloat{ return UIScreen.main.bounds.height }
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - Public Methods -
    
    ///
    /// Hides keyboard when user taps on screen.
    ///
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    ///
    /// Display typical alert.
    ///
    /// - parameter title: Title text for alert.
    /// - parameter message: Message text for alert.
    /// - parameter completion: Handler for pressing action button on alert.
    ///
    func displayAlert(withTitle title: String, message: String, completion: Closure?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion?()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Description: Dismisses keyboard.
    ///
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


