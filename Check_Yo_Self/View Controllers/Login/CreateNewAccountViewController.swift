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

class CreateNewAccountViewController: UIViewController {
    
    // Convenience struct for distiguishing valid character sets for textFields in the cells.
    private struct CharacterType {
        static let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        static let numeric = ["0","1","2","3","4","5","6","7","8","9"]
        static let specialCharacters = ["!", "@", "#", "$", "%", "^", "&", "*"]
    }
    
    // Detail Information for each field.
    private enum NewAccountInfoField {
        
        case username, password
        
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
        
        static var all: [NewAccountInfoField] = [username, password]
    }
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Create New Account"
    }
}

// MARK: - Extension: UITableView -

extension CreateNewAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NewAccountInfoField.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelAndTextFieldCell") as? LabelAndTextFieldCell else { return UITableViewCell() }
        let field = NewAccountInfoField.all[indexPath.section]
        cell.configure(withPlaceholder: field.placeholder, validCharacters: field.validCharacters)
        
        return cell
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

// MARK: - Extension: Actions -

extension CreateNewAccountViewController {
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
