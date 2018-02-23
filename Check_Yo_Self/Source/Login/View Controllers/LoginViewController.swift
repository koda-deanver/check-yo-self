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
        
        messageLabel.font = UIFont(name: Font.main, size: Font.mediumSize)
        
        let usernameBlueprint = TextFieldBlueprint(withPlaceholder: "Username", maxCharacters: Configuration.usernameMaxLength, minCharacters: Configuration.usernameMinLength)
        usernameTextField.configure(withBlueprint: usernameBlueprint, delegate: nil)
        
        let passcodeBlueprint = TextFieldBlueprint(withPlaceholder: "Passcode", isSecure: true, maxCharacters: Configuration.passcodeLength, minCharacters: Configuration.passcodeLength, limitCharactersTo: CharacterType.numeric)
        passcodeTextField.configure(withBlueprint: passcodeBlueprint, delegate: nil)
        
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
        
        clearTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = .clear
        loginView.isHidden = true
        createAccountButton.isHidden = true
    }
    
    // MARK: - Public Methods -
    
    /// Used to present the cube screen for first time user and display tutorial video. Called from *ProfileViewController*.
    func presentCubeScreenWithVideo() {
        
        guard let cubeViewController = storyboard?.instantiateViewController(withIdentifier: "cubeViewController") as? CubeViewController else { return }
        cubeViewController.newPlayer = true
        present(cubeViewController, animated: true, completion: nil)
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
            self.clearTextFields()
            
            guard users.count == 1 else {
                let errorText = (users.count == 0) ? "Invalid username/passcode." : "Uh-oh Something is wrong with your account."
                let alert = BSGCustomAlert(message: errorText, options: [(text: "Close", handler: {})])
                self.showAlert(alert, inColor: .none)
                return
            }
            
            let user = users[0]
            User.current = user
            
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
            
        }, failure: { errorMessage in
            self.clearTextFields()
            self.handle(errorMessage)
        })
    }
    
    ///
    /// Clears username and passcode text fields.
    ///
    private func clearTextFields() {
        usernameTextField.text = ""
        passcodeTextField.text = ""
    }
}

// MARK: - Extension: Actions -

extension LoginViewController {
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        guard let username = usernameTextField.text, let passcode = passcodeTextField.text else { return }
        
        loginButton.isEnabled = username.count >= Configuration.usernameMinLength && passcode.count == Configuration.passcodeLength
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextField) {
        
        /*if sender == usernameTextField {
            passcodeTextField.becomeFirstResponder()
        } else {
            passcodeTextField.resignFirstResponder()
        }*/
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, let passcode = passcodeTextField.text else { return }
        
        validateLogin(username: username, password: passcode)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showCreateNewAccount", sender: self)
    }
}
