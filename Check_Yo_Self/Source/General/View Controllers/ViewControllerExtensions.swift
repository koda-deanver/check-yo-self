//********************************************************************
//  ViewControllerExtensions.swift
//  Who Dat
//  Created by Phil on 3/7/17
//
//  Description: Hold general behavior for custom view controllers
//********************************************************************

import UIKit

extension UIViewController{
    
    func showConnectionAlert(_ alert: ConnectionAlert){
        let alertVC: ConnectionAlertViewController!
        // 1 vs 2 button alerts
        if alert.cancelButtonText == nil{
            alertVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConnectionAlertStandard") as! ConnectionAlertViewController
        }else{
            alertVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConnectionAlertChoice") as! ConnectionAlertViewController
        }
        alertVC.alert = alert
        self.addChildViewController(alertVC)
        alertVC.view.frame = self.view.frame
        self.view.addSubview(alertVC.view)
        alertVC.didMove(toParentViewController: self)
    }
}
