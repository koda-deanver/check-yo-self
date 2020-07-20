//
//  LoginViewController.swift
//  check-yo-self
//
//  Created by phil on 1/3/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

///  Initial login screen for app. User can either enter credeentials to log in or create a new account.
final class LoginViewController: GeneralViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var emailTextField: TextField!
    @IBOutlet private weak var passwordTextField: TextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    
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
        forgotPassButton.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
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
        
        guard let customTabBar = storyboard?.instantiateViewController(withIdentifier: "customTabBar") as? CustomTabBar, let cubeViewController = customTabBar.viewControllers?[0] as? CubeViewController else { return }
        cubeViewController.newPlayer = true
        
        present(customTabBar, animated: true, completion: nil)
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
            
            if !DefaultsManager.shared.IsFirstLogin() && DefaultsManager.shared.IsFirstAppLaunch(){
                DefaultsManager.shared.setIsFirstLogin(value: true)
            }
            
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
        }, failure: { error in
            self.handle(error)
        })
    }
    
    private func checkUserOnFirebaseAndLogin(result: [String:Any]){
        guard let uid = result["userId"] as? String else {
            self.hideProgressHUD()
            self.showAlert(BSGCustomAlert(message: "User not found"))
            return
        }
        
        DataManager.shared.getUsers(matching: [(field: .uid, value: uid)], success: { users in
            self.hideProgressHUD()
            
            guard users.count == 1 else {
                
                let errorText = (users.count == 0) ? "Could not find data for user." : "Uh-oh Something is wrong with your account."
                self.showAlert(BSGCustomAlert(message: errorText))
                return
            }
            
            let user = users[0]
            User.current = user
            
            if !DefaultsManager.shared.IsFirstLogin() && DefaultsManager.shared.IsFirstAppLaunch(){
                DefaultsManager.shared.setIsFirstLogin(value: true)
            }
            
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
            
        }, failure: { err in
            self.hideProgressHUD()
            self.showAlert(BSGCustomAlert(message: err))
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
    
    @IBAction func forgotPassButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "forgotPassScreen", sender: self)
    }
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        showProgressHUD()
        DataManager.shared.loginOrSignupWithFacebook(success: { (userInfo) in
        print("SERUBF \(userInfo)")
            DataManager.shared.registerFBOnFirebase(result: userInfo, completion: { result in
                self.checkUserOnFirebaseAndLogin(result: result)
            }) { (err) in
                self.hideProgressHUD()
                self.showAlert(BSGCustomAlert(message: err))
            }
        }, failure: { err in
            self.hideProgressHUD()
            self.showAlert(BSGCustomAlert(message: err))
        })
    }
    
    @IBAction func loginWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            self.showAlert(BSGCustomAlert(message: error.localizedDescription))
        } else {
            DataManager.shared.registerGoogleOnFirebase(user: user, completion: { (result) in
                print("HEY \(result)")
                self.checkUserOnFirebaseAndLogin(result: result)
            }) { (err) in
                self.showAlert(BSGCustomAlert(message: err))
            }
        }
    }
    
    
}
