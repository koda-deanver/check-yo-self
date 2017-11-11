//********************************************************************
//  LoginViewController.swift
//  Check Yo Self
//  Created by Phil on 1/3/17
//
//  Description: Initial screen used to set up PlayerData
//********************************************************************

import UIKit
import MapKit

class LoginViewController: GeneralViewController {
    
    @IBAction func editingEnded(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Set up hide keyboard functionality
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        // To hide keyboard after input
        self.hideKeyboardWhenTappedAround()
    }
    
    //********************************************************************
    // viewDidAppear
    // Description: Check for new user (Get questions from Cloudkit)
    // or existing user (load from local storage)
    //********************************************************************
    override func viewDidAppear(_ animated: Bool) {
        newProfileAlert()
    }
    
    //********************************************************************
    // newProfileAlert
    // Description: Launch alert explaining how to enter information
    //********************************************************************
    func newProfileAlert(){
        let alertController = UIAlertController(title: "Welcome to Check Yo Self!", message: "Enter a username", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(){
            textField in
            textField.placeholder = "Username"
            textField.borderStyle = .roundedRect
        }
        alertController.addAction(UIAlertAction(title: "Play", style: .default){
            action in
            let fields = alertController.textFields
            if let chosenName = fields?[0].text{
                self.validateName(chosenName)
            }else{
                print("ERROR: No text in field")
            }
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    //********************************************************************
    // validateName
    // Description: Ensure that chosen name is satisfactory before continuing
    //********************************************************************
    func validateName(_ chosenName: String){
        guard chosenName.characters.count >= USERNAME_MIN_LENGTH else{
            // Display second alert warning of short name
            let alertController = UIAlertController(title: "Username too short!", message: "Your username needs to be at least \(USERNAME_MIN_LENGTH) characters.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField(){
                textField in
                textField.placeholder = "Username"
                textField.borderStyle = .roundedRect
            }
            alertController.addAction(UIAlertAction(title: "Play", style: .default){
                action in
                let fields = alertController.textFields
                if let chosenName = fields?[0].text{
                    self.validateName(chosenName)
                }else{
                    print("Paul blows")
                }
            })
            self.present(alertController, animated: true, completion: nil)
            return
        }
        // name is good launch game
        print("Name Chosen: \(chosenName)")
        // Save New Player Information
        PlayerData.sharedInstance.displayName = chosenName
        self.launchGame(onTab: 0)
    }
    
    //********************************************************************
    // launchGame
    // Description: Start game on specified tab
    //********************************************************************
    func launchGame(onTab tab: Int){
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
