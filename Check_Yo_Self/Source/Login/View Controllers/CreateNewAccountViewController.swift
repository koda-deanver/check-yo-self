//
//  CreateNewAccountViewController.swift
//  check-yo-self
//
//  Created by phil on 1/19/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

///  Prompt user to enter necessary information to create a new account.
final class CreateNewAccountViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    private let newAccountFields: [TextFieldBlueprint] = [
        TextFieldBlueprint(withPlaceholder: "Username", maxCharacters: Configuration.usernameMaxLength, minCharacters: Configuration.usernameMinLength),
        TextFieldBlueprint(withPlaceholder: "Passcode", isSecure: true, maxCharacters: Configuration.passcodeLength, minCharacters: Configuration.passcodeLength, limitCharactersTo: CharacterType.numeric)
    ]
    
    private var username: String? { return (tableView.visibleCells[0] as? LabelAndTextFieldCell)?.currentText }
    private var password: String? { return (tableView.visibleCells[1] as? LabelAndTextFieldCell)?.currentText }
    
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
    func submitFields() {
        
        guard let username = username, let password = password else { return }
        User.current = User(withUsername: username, password: password)
        
        showProgressHUD()
        
        LoginFlowManager.shared.validateCredentials(for: User.current, success: {
            self.hideProgressHUD()
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }, failure: { errorString in
            self.handle(errorString)
        })
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
