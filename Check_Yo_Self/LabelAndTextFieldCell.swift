//
//  LabelAndTextFieldCell.swift
//  Check_Yo_Self
//
//  Created by Phil on 1/19/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

class LabelAndTextFieldCell: UITableViewCell {
    
    var validCharacters: [String]!
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - Public Methods -
    
    ///
    /// Configure cell text and behavior.
    ///
    /// - parameter placeholder: Text to be displayed both as label for field, and as placeholder text inside field.
    /// - parameter validCharacters: Defines which characters are allowed to be typed in field.
    ///
    func configure(withPlaceholder placeholder: String, validCharacters: [String]) {
        
        label.text = placeholder
        
        textField.placeholder = placeholder
        textField.delegate = self
        
        self.validCharacters = validCharacters
        
        style()
    }
    
    ///
    /// Style visual aspects of cell.
    ///
    private func style() {
        
        backgroundColor = .clear
        textField.borderStyle = .none
        textField.backgroundColor = .white
    }
}

// MARK: - Extension: UITextFieldDelegate -

extension LabelAndTextFieldCell: UITextFieldDelegate {
    
    ///
    /// Limit characters in field to only valid ones or a backspace.
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard validCharacters.contains(string.lowercased()) || string == "" else { return false }
        return true
    }
}
