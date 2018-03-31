//
//  CreateNewAccountViewController.swift
//  check-yo-self
//
//  Created by phil on 1/19/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit
import Firebase

///  Prompt user to enter necessary information to create a new account.
final class CreateNewAccountViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    private let newAccountFields: [TextFieldBlueprint] = [
        // Firebase will handle making sure email is valid format. I hope.
        TextFieldBlueprint(withPlaceholder: "Email"),
        TextFieldBlueprint(withPlaceholder: "Password", minCharacters: Configuration.passwordMinLength),
        TextFieldBlueprint(withPlaceholder: "First Name", limitCharactersTo: CharacterType.alphabet),
        TextFieldBlueprint(withPlaceholder: "Last Name", limitCharactersTo: CharacterType.alphabet),
        TextFieldBlueprint(withPlaceholder: "Gamertag (Optional)", isRequired: false, maxCharacters: Configuration.gamertagMaxLength)
    ]
    
    private var email: String { return (tableView.visibleCells[0] as? LabelAndTextFieldCell)?.currentText ?? "" }
    private var password: String { return (tableView.visibleCells[1] as? LabelAndTextFieldCell)?.currentText ?? "" }
    private var firstName: String { return (tableView.visibleCells[2] as? LabelAndTextFieldCell)?.currentText ?? "" }
    private var lastName: String { return (tableView.visibleCells[3] as? LabelAndTextFieldCell)?.currentText ?? "" }
    private var gamertag: String { return (tableView.visibleCells[4] as? LabelAndTextFieldCell)?.currentText ?? "" }
    
    // MARK: - Outlets -
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Lifecycle -
    
    ///
    /// Initial styling.
    ///
    override func style() {
        
        title = "Create New Account"
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        continueButton.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
        continueButton.isEnabled = false
    }
    
    /// To prevent temporarily showing this view behind the next.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        tableView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = .clear
        tableView.isHidden = true
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Submit current fields to create new user acccount.
    ///
    /// - note: Gamertag is only validated if there is input in the gamertag field. Otherwise, an account is created without one.
    ///
    private func submitFields() {
        
        let passwordValidationTuple = LoginFlowManager.shared.validateNewPassword(password)
        
        guard passwordValidationTuple.0 == true else {
            showAlert(BSGCustomAlert(message: passwordValidationTuple.1))
            return
        }
        
        showProgressHUD()
        
        /// If gamertag was entered, validate it.
        if !gamertag.isEmpty {
            
            LoginFlowManager.shared.validateNewGamertag(gamertag, success: {
                
                self.hideProgressHUD()
                self.createAccount(withEmail: self.email, password: self.password, firstName: self.firstName, lastName: self.lastName, gamertag: self.gamertag)
            }, failure: { error in
                self.handle(error)
            })
        } else {
            
            hideProgressHUD()
            createAccount(withEmail: email, password: password, firstName: firstName, lastName: lastName, gamertag: nil)
        }
    }
    
    ///
    /// Create user account on Firebase if credentials are valid.
    ///
    /// This is where email is checked for uniqueness and validness. (Password and gamertag have been validated by this point). Email is validated last which is weird but no way around this without creating user before password and gamertag are validated.
    ///
    /// - parameter email: Unvalidated email entered by user.
    /// - parameter password: Password of correct length and characters enforced by TextField.
    /// - parameter gamertag: Validated gamertag or nil.
    ///
    private func createAccount(withEmail email: String, password: String, firstName: String, lastName: String, gamertag: String?) {
        
        self.showAlert(BSGCustomAlert(message: "Create account? You can't go back after proceeding.", options: [(text: "Create", handler: {
            
            self.showProgressHUD()
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                
                self.hideProgressHUD()
                
                guard error == nil, let user = user else {
                    self.handle(error?.localizedDescription ?? "Failed to create account.")
                    return
                }
                
                User.current = User(withID: user.uid, email: email, firstName: firstName, lastName: lastName)
                User.current.gamertag = gamertag
                
                self.performSegue(withIdentifier: "showProfile", sender: self)
            })
        }), (text: "Wait", handler: {})]))
        
    }
    
    ///
    /// Adjust background of *profileViewController* to be transparent to match login flow.
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let profileViewController = segue.destination as? ProfileViewController else { return }
        profileViewController.displaysWithTransparentBackground = true
    }
}

// MARK: - Extension: UITableView -

extension CreateNewAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newAccountFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndTextFieldCell") as? LabelAndTextFieldCell else { return UITableViewCell() }
        cell.configure(withTextFieldBlueprint: newAccountFields[indexPath.row], delegate: self)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeightNormal
    }
}

// MARK: - Extension: LabelAndTextFieldDelegate -

extension CreateNewAccountViewController: LabelAndTextFieldCellDelegate {
    
    func labelAndTextFieldCell(_ cell: LabelAndTextFieldCell, didChangeTextInField textField: TextField) {
        
        var inputIsValid = true
        for cell in tableView.visibleCells where (cell as? LabelAndTextFieldCell)?.inputIsValid == false  {
            inputIsValid = false
        }
        
        continueButton.isEnabled = inputIsValid
    }
}

// MARK: - Extension: Actions -

extension CreateNewAccountViewController {
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        submitFields()
    }
}
