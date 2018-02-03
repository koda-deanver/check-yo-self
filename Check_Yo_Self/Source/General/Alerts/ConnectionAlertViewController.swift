//********************************************************************
//  ConnectionAlertViewController.swift
//  Who Dat
//
//  Changed from ModeSelectViewController by Phil on 3/7/17
//  Created by Phil on 12/26/16
//
//  Description: Pop up window to display alerts
//********************************************************************

import UIKit

class ConnectionAlertViewController: UIViewController {
    var alert: ConnectionAlert!
    
    @IBOutlet weak var alertBackdrop: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if sender.restorationIdentifier == "okButton"{
            self.alert.okButtonCompletion()
            dismissAnimate()
        }else if sender.restorationIdentifier == "cancelButton"{
            self.alert.cancelButtonCompletion()
            dismissAnimate()
        }
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Set background color for pop up
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAlert()
        showAnimate()
    }
    
    //********************************************************************
    // setUpAlert
    // Description: Show Alert
    //********************************************************************
    func setUpAlert(){
        let playerColor = PlayerData.sharedInstance.cubeColor
        // Set alert Backdrop and button to color
        self.okButton.setBackgroundImage(Media.coloredButtonList[playerColor.intValue()], for: .normal)
        self.alertBackdrop.image = Media.alertBackdropList[playerColor.intValue()]
        self.connectionStatusLabel.textColor = playerColor.rgbColor()
       
        // Set up message
        self.titleLabel.text = self.alert.title
        // Only show status label if there is a status
        if let connectionStatus = self.alert.connectionStatus{
            self.connectionStatusLabel.text = connectionStatus.rawValue
        }else{
            self.connectionStatusLabel.isHidden = true
        }
        
        self.messageTextView.text = self.alert.message
        self.okButton.setTitle(self.alert.okButtonText, for: .normal)
        
        if let cancelButtonText = self.alert.cancelButtonText{
            self.cancelButton.setTitle(cancelButtonText, for: .normal)
        }
        
    }
    
    //********************************************************************
    // showAnimate
    // Description: Animate popup on appearing
    //********************************************************************
    func showAnimate(){
        // Adjust transparent backround for popup window to stand out
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        // Fade in and shrink
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    //********************************************************************
    // dismissAnimate
    // Description: Animate popup on dismiss
    //********************************************************************
    func dismissAnimate(){
        // Fade out and grow
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: {
            finished in
            if finished{
                self.view.removeFromSuperview()
            }
        })
    }
}
