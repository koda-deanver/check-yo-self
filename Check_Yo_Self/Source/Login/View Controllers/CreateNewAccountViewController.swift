//
//  CreateNewAccountViewController.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 1/19/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

// MARK: Class: - CreateNewAccountViewController -

///  Prompt user to enter necessary information to create a new account.
class CreateNewAccountViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    private let newAccountFields: [TextFieldBlueprint] = [
        TextFieldBlueprint(placeholder: "Username", validCharacters: CharacterType.alphabet + CharacterType.numeric + CharacterType.specialCharacters, maxCharacters: Configuration.usernameMaxLength, minCharacters: Configuration.usernameMinLength),
        TextFieldBlueprint(placeholder: "Passcode", validCharacters: CharacterType.numeric, maxCharacters: Configuration.passcodeLength, minCharacters: Configuration.passcodeLength)
    ]
    private let successAlertTitle = "New account created!"
    private let errorAlertTitle = "Failed to create account."
    
    private var username: String? { return (tableView.visibleCells[0] as? LabelAndTextFieldCell)?.currentText }
    private var password: String? { return (tableView.visibleCells[1] as? LabelAndTextFieldCell)?.currentText }
    
    // MARK: - Outlets -
    
    @IBOutlet weak var tableView: UITableView!
    private weak var submitButtonCell: SubmitButtonCell!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        style()
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
    
    // MARK: - Private Methods -
    
    ///
    /// Initial styling.
    ///
    private func style() {
        
        title = "Create New Account"
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
    }
    
    ///
    /// Submit current fields to create new user acccount.
    ///
    func submitFields() {
        
        guard let username = username, let password = password else { return }
        
        User.current = User(withUsername: username, password: password)
        LoginFlowManager.shared.validateCredentials(for: User.current, success: {
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }, failure: { errorString in
            
            let alert = BSGCustomAlert(message: errorString, options: [(text: "Close", handler: {})])
            self.showAlert(alert)
        })
    }
}

// MARK: - Extension: UITableView -

extension CreateNewAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newAccountFields.count + 1 /* extra section for submit button */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == newAccountFields.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "submitButtonCell") as? SubmitButtonCell else { return UITableViewCell() }
            cell.delegate = self
            cell.submitButton.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
            cell.setButtonEnabled(false)
            submitButtonCell = cell
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndTextFieldCell") as? LabelAndTextFieldCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(withTextFieldBlueprint: newAccountFields[indexPath.section])

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = tableView.backgroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == newAccountFields.count ? 30.0 : 60.0
    }
    
    /// Spacing between cells
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
}

// MARK: - Extension: LabelAndTextFieldDelegate -

extension CreateNewAccountViewController: LabelAndTextFieldCellDelegate {
    
    func labelAndTextFieldCell(_ cell: LabelAndTextFieldCell, didChangeTextInField textField: TextField) {
        
        var inputIsValid = true
        for cell in tableView.visibleCells where (cell as? LabelAndTextFieldCell)?.inputIsValid == false  {
            inputIsValid = false
        }
        
        submitButtonCell.setButtonEnabled(inputIsValid)
    }
}
// MARK: - Extension: SubmitButtonCellDelegate -

extension CreateNewAccountViewController: SubmitButtonCellDelegate {
    
    func submitButtonCell(_ cell: SubmitButtonCell, didPressSubmitButton: UIButton) {
        submitFields()
    }
}

// MARK: - Extension: Actions -

extension CreateNewAccountViewController {
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
