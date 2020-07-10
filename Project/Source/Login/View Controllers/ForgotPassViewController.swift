//
//  ForgotPassViewController.swift
//  check-yo-self
//
//  Created by AA10 on 19/06/2020.
//  Copyright © 2020 ThematicsLLC. All rights reserved.
//

import UIKit
import Firebase

final class ForgotPassViewController: GeneralViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sendResetPassBtn: UIButton!
    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    ///
    /// Sets initial style.
    ///
    override func style() {
        
        super.style()
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        messageLabel.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        
        let emailBlueprint = TextFieldBlueprint(withPlaceholder: "Email")
        emailTF.configure(withBlueprint: emailBlueprint, delegate: nil)
        
        sendResetPassBtn.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        sendResetPassBtn.isEnabled = false
        
        loginBtn.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        clearTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.backgroundColor = .clear
    }
    
    private func clearTextFields() {
        emailTF.text = ""
    }
    
    @IBAction func sendResetPasswordInstructions(_ sender: Any) {
        showProgressHUD()
        
        Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { (error) in
            print("ErROR IF ANY \(error.debugDescription)")
            self.hideProgressHUD()
            
            self.showAlert(BSGCustomAlert(message: "Reset Password Instructions are sent to the email.", options: [(text: "Ok", handler: {
            self.dismiss(animated: true, completion: nil)})]))
        }
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        sendResetPassBtn.isEnabled = emailTF.inputIsValid
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextField) {}
}
