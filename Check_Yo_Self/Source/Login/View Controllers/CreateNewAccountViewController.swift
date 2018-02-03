//
//  CreateNewAccountViewController.swift
//  Check_Yo_Self
//
//  Created by Phil Rattazzi on 1/19/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  Prompt user to enter necessary information to create a new account.
//

import UIKit

// MARK: - Struct: CharacterType -

// Convenience struct for distiguishing valid character sets for textFields in the cells.
struct CharacterType {
    static let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    static let numeric = ["0","1","2","3","4","5","6","7","8","9"]
    static let specialCharacters = ["!", "@", "#", "$", "%", "^", "&", "*"]
}

// MARK: - Enum: NewAccountInfoFieldType -

enum NewAccountInfoFieldType {
    
    case username, password
    
    var tableRow: Int? {
        
        for (index, type) in NewAccountInfoFieldType.all.enumerated() where type == self {
            return index
        }
        return nil /* This type is not in table */
    }
    
    var placeholder: String {
        switch self {
        case .username: return "Username"
        case .password: return "Password"
        }
    }
    
    var validCharacters: [String] {
        switch self {
        case .username: return CharacterType.alphabet + CharacterType.numeric
        case .password: return CharacterType.alphabet + CharacterType.numeric + CharacterType.specialCharacters
        }
    }
    
    var minCharacters: Int {
        switch self {
        case .username: return Configuration.usernameMinLength
        case .password: return Configuration.passwordMinLength
        }
    }
    
    var maxCharacters: Int {
        switch self {
        case .username: return Configuration.usernameMaxLength
        case .password: return Configuration.passwordMaxLength
        }
    }
    
    static var all: [NewAccountInfoFieldType] = [username, password]
}

// MARK: Class: - CreateNewAccountViewController -

class CreateNewAccountViewController: GeneralViewController {
    
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
        
        LoginFlowManager.shared.validateCredentials(credentials: (username, password), viewController: self)
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
        return 30.0
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
