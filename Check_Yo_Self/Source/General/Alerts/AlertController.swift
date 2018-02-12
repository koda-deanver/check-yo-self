//
//  AlertController.swift
//  Check_Yo_Self
//
//  Created by Phil on 2/11/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit
    
class AlertController: BSGVerticalButtonAlertController {
    
    ///
    /// Change color of alert buttons and backdrop.
    ///
    /// - parameter color: JabbrColor to change alert to.
    ///
    static func changeColor(to color: JabbrColor) {
        AlertController.configure(withAnimationDuration: 0.25, backgroundImage: color.alertBackdrop, buttonImage: color.buttonImage)
    }
}

extension UIViewController {
    
    ///
    /// Show alert on any ViewController.
    ///
    /// Creates a new instance of BSGCustomAlertController and displays in as a child of current ViewController.
    ///
    /// - parameter alert: Custom alert to show.
    /// - parameter color: Color to show alerts in.
    ///
    func showAlert(_ alert: BSGCustomAlert, inColor color: JabbrColor){
        
        AlertController.changeColor(to: color)
        
        DispatchQueue.main.async{
            
            let alertController = BSGVerticalButtonAlertController()
            alertController.alert = alert
            self.addChildViewController(alertController)
            alertController.view.frame = self.view.frame
            alertController.view.layer.zPosition = 10
            self.view.addSubview(alertController.view)
            alertController.didMove(toParentViewController: self)
        }
    }
}
