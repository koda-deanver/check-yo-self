//
//  LoginViewController.swift
//  Check_Yo_Self
//
//  Created by Phil Rattazzi on 1/3/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  Initial login screen for app. User can either enter credeentials to log in or create a new account.
//

import UIKit

class LoginViewController: GeneralViewController {
    
    // MARK: - Lifecycle -
    
    override func viewDidAppear(_ animated: Bool) {
        showLoginAlert(withTitleText: "Log in to Jabbr account")
    }
    
    // MARK: - Private methods -
    
    ///
    /// Show alert prompting user to login.
    ///
    private func showLoginAlert(withTitleText titleText: String) {
        
        let alertController = UIAlertController(title: titleText, message: "Don't have a Jabbr account? Create one!", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField() {
            textField in
            textField.placeholder = "Username"
            textField.borderStyle = .roundedRect
        }
        alertController.addTextField() {
            textField in
            textField.placeholder = "Password"
            textField.borderStyle = .roundedRect
        }
        alertController.addAction(UIAlertAction(title: "Log In", style: .default){
            action in
            guard let username = alertController.textFields?[0].text, let password = alertController.textFields?[1].text else { return /*FIX: Handle error */ }
            self.validateLogin(username: username, password: password)
        })
        alertController.addAction(UIAlertAction(title: "Create Account", style: .default){
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.createNewAccount()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    ///
    /// Checks if user exists, and if password matches.
    ///
    /// - parameter username: Username input from user.
    /// - parameter password: Password input from user.
    ///
    private func validateLogin(username: String, password: String){
        
        DataManager.shared.getUser(withCredentials: (username, password), completion: { user in
            
            PlayerData.sharedInstance.displayName = user.username
            self.launchGame(onTab: 0)
            
        }, failure: { errorMessage in
            
            self.showLoginAlert(withTitleText: errorMessage)
            return
        })
    }
    
    ///
    /// Launches proccess to create new account.
    ///
    private func createNewAccount() {
        performSegue(withIdentifier: "showCreateNewAccount", sender: self)
    }
    
    ///
    /// Start game on specified tab.
    ///
    private func launchGame(onTab tab: Int){
        // Go to Menu
        DispatchQueue.main.async {
            let newView: UITabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarScene") as! UITabBarController
            newView.selectedIndex = tab
            
            let cubeController = newView.viewControllers?[0] as! CubeViewController
            // Show tutorial video on cube screen
            cubeController.newPlayer = true
            cubeController.tabBarController?.setTabsActive(false)
            self.present(newView, animated: true, completion: nil)
        }
    }
}
