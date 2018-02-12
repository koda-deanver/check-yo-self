//
//  CreateNewAccountViewController.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 1/19/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

// MARK: - Struct: CharacterType -

/// Convenience struct for distiguishing valid character sets for textFields in the cells.
struct CharacterType {
    static let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    static let numeric = ["0","1","2","3","4","5","6","7","8","9"]
    static let specialCharacters = ["!", "@", "#", "$", "%", "^", "&", "*"]
}

// MARK: Class: - CreateNewAccountViewController -

///  Prompt user to enter necessary information to create a new account.
class CreateNewAccountViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    private let successAlertTitle = "New account created!"
    private let errorAlertTitle = "Failed to create account."
    
    // MARK: - Outlets -
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Create New Account"
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Submit current fields to create new user acccount.
    ///
    func submitFields() {
        
        guard let usernameRow = NewAccountInfoFieldType.username.tableRow, let usernameCell = tableView.visibleCells[usernameRow] as? LabelAndTextFieldCell else { return }
        let username = usernameCell.currentText
        
        guard let passwordRow = NewAccountInfoFieldType.password.tableRow, let passwordCell = tableView.visibleCells[passwordRow] as? LabelAndTextFieldCell else { return }
        let password = passwordCell.currentText
        
        User.current = User(withUsername: username, password: password)
        performSegue(withIdentifier: "showProfile", sender: self)
    }
    
}

// MARK: - Extension: UITableView -

extension CreateNewAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NewAccountInfoFieldType.all.count + 1 /* extra section for submit button */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == NewAccountInfoFieldType.all.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "submitButtonCell") as? SubmitButtonCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndTextFieldCell") as? LabelAndTextFieldCell else { return UITableViewCell() }
            let field = NewAccountInfoFieldType.all[indexPath.section]
            cell.configure(withPlaceholder: field.placeholder, validCharacters: field.validCharacters, maxCharacters: field.maxCharacters)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = tableView.backgroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
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
