//
//  LoginViewController.swift
//  check-yo-self
//
//  Created by phil on 1/3/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

///  Initial login screen for app. User can either enter credeentials to log in or create a new account.
final class LoginViewController: GeneralViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var emailTextField: TextField!
    @IBOutlet private weak var passwordTextField: TextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    // MARK: - Lifecycle -
    
    ///
    /// Sets initial style.
    ///
    override func style() {
        
        super.style()
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        messageLabel.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        
        let emailBlueprint = TextFieldBlueprint(withPlaceholder: "Email")
        emailTextField.configure(withBlueprint: emailBlueprint, delegate: nil)
        
        let passwordBlueprint = TextFieldBlueprint(withPlaceholder: "Password", isSecure: true, minCharacters: Configuration.passwordMinLength)
        passwordTextField.configure(withBlueprint: passwordBlueprint, delegate: nil)
        
        loginButton.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        loginButton.isEnabled = false
        
        createAccountButton.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
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
    /// - parameter email: Email input from user.
    /// - parameter password: Password input from user.
    ///
    private func validateLogin(email: String, password: String){
        
        showProgressHUD()
        
        LoginFlowManager.shared.login(withEmail: email, password: password, success: {
            self.hideProgressHUD()
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
        }, failure: { error in
            self.handle(error)
        })
    }
    
    ///
    /// Clears username and passcode text fields.
    ///
    private func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}

// MARK: - Extension: Actions -

extension LoginViewController {
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        loginButton.isEnabled = emailTextField.inputIsValid && passwordTextField.inputIsValid
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextField) {}
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        validateLogin(email: email, password: password)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showCreateNewAccount", sender: self)
    }
}
