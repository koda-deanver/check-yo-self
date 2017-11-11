//********************************************************************
//  GeneralViewController.swift
//  Check Yo Self
//  Created by Phil on 12/1/16
//
//  Description: Used to provide general behavior for all view controllers
//********************************************************************

import UIKit


class GeneralViewController: UIViewController, UITextFieldDelegate{
    var screenWidth: CGFloat{
        return UIScreen.main.bounds.width
    }
    var screenHeight: CGFloat{
        return UIScreen.main.bounds.height
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    var appSkin: DesignStyle!
    var backgroundImage: UIImageView!
    override func viewDidLoad(){
        super.viewDidLoad()
        self.backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        // Adjust background for age
        if PlayerData.sharedInstance.isAdult{
            self.appSkin = .adult
            self.backgroundImage.image = #imageLiteral(resourceName: "GradientBlack")
        }else{
            self.appSkin = .child
            self.backgroundImage.image = #imageLiteral(resourceName: "GradientWhite")
        }
        self.view.addSubview(self.backgroundImage)
        self.view.sendSubview(toBack: self.backgroundImage)
    }
    
    //********************************************************************
    // hideKeyboardWhenTappedAround
    // Description: Hides keyboard when tapped on screen
    //********************************************************************
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //********************************************************************
    // dismissKeyboard
    // Description: Dismissed keyboard
    //********************************************************************
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


