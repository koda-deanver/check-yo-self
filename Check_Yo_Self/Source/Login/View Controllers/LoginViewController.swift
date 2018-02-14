//
//  LoginViewController.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 1/3/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

///  Initial login screen for app. User can either enter credeentials to log in or create a new account.
final class LoginViewController: GeneralViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var usernameTextField: TextField!
    @IBOutlet private weak var passcodeTextField: TextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    // MARK: - Lifecycle -
    
    ///
    /// Sets initial style.
    ///
    override func style() {
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        messageLabel.font = UIFont(name: Font.main, size: Font.mediumSize * 0.8)
        
        usernameTextField.configure(withBlueprint: TextFieldBlueprint(placeholder: "Username", validCharacters: CharacterType.alphabet + CharacterType.numeric + CharacterType.specialCharacters, maxCharacters: Configuration.usernameMaxLength, minCharacters: Configuration.usernameMinLength, isSecure: false))
        passcodeTextField.configure(withBlueprint: TextFieldBlueprint(placeholder: "Passcode", validCharacters: CharacterType.numeric, maxCharacters: Configuration.passcodeLength, minCharacters: Configuration.passcodeLength, isSecure: true))
        
        loginButton.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
        loginButton.isEnabled = false
        
        createAccountButton.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
    }
    
    /// To prevent temporarily showing this view behind the next.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        loginView.isHidden = false
        createAccountButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = .clear
        loginView.isHidden = true
        createAccountButton.isHidden = true
    }
    
    // MARK: - Private methods -
    
    ///
    /// Checks if user exists, and if password matches.
    ///
    /// - parameter username: Username input from user.
    /// - parameter password: Password input from user.
    ///
    private func validateLogin(username: String, password: String){
        
        showProgressHUD()
        
        DataManager.shared.getUsers(matching: [(field: .username, value: username), (field: .password, value: password)],success: { users in
            
            self.hideProgressHUD()
            
            guard users.count == 1 else {
                let errorText = (users.count == 0) ? "Invalid username/passcode." : "Uh-oh Something is wrong with your account."
                let alert = BSGCustomAlert(message: errorText, options: [(text: "Close", handler: {})])
                self.showAlert(alert)
                return
            }
            
            let user = users[0]
            
            PlayerData.sharedInstance.displayName = user.username
            PlayerData.sharedInstance.gemTotal = user.gems
            
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
            
        }, failure: { errorMessage in
            self.handle(errorMessage)
        })
    }
}

// MARK: - Extension: Actions -

extension LoginViewController {
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        guard let username = usernameTextField.text, let passcode = passcodeTextField.text else { return }
        
        loginButton.isEnabled = username.count >= Configuration.usernameMinLength && passcode.count == Configuration.passcodeLength
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, let passcode = passcodeTextField.text else { return }
        
        validateLogin(username: username, password: passcode)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showCreateNewAccount", sender: self)
    }
}
