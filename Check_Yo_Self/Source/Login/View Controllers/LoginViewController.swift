//
//  LoginViewController.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 1/3/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

///  Initial login screen for app. User can either enter credeentials to log in or create a new account.
class LoginViewController: GeneralViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passcodeTextField: UITextField!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
    }
    
    // MARK: - Private methods -
    
    ///
    /// Checks if user exists, and if password matches.
    ///
    /// - parameter username: Username input from user.
    /// - parameter password: Password input from user.
    ///
    private func validateLogin(username: String, password: String){
        
        DataManager.shared.getUsers(matching: [(field: .username, value: username), (field: .password, value: password)],success: { users in
            
            guard users.count == 1 else {
                let errorText = (users.count == 0) ? "User not found." : "Uh-oh Something is wrong with your account."
                let alert = BSGCustomAlert(message: errorText, options: [(text: "Close", handler: {})])
                self.showAlert(alert)
                return
            }
            
            let user = users[0]
            
            PlayerData.sharedInstance.displayName = user.username
            PlayerData.sharedInstance.gemTotal = user.gems
            
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
            
        }, failure: { errorMessage in
            
            let alert = BSGCustomAlert(message: errorMessage, options: [(text: "Close", handler: {})])
            self.showAlert(alert)
            return
        })
    }
}

// MARK: - Extension: LoginViewController -

extension LoginViewController {
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, let passcode = passcodeTextField.text else { return }
        
        validateLogin(username: username, password: passcode)
    }
}
