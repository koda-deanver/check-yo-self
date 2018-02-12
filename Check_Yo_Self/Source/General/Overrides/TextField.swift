//
//  TextField.swift
//  Check_Yo_Self
//
//  Created by Phil on 2/12/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

// MARK: - Struct -

/// Convenience struct for distiguishing valid character sets for textFields in the cells.
struct CharacterType {
    static let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    static let numeric = ["0","1","2","3","4","5","6","7","8","9"]
    static let specialCharacters = ["!", "@", "#", "$", "%", "^", "&", "*"]
}

// MARK: - Struct -

/// Model to build text fields from.
struct TextFieldBlueprint {
    
    let placeholder: String
    let validCharacters: [String]
    let maxCharacters: Int
    let minCharacters: Int
}

// MARK: - Class -

/// Common class for dealing with text fields.
class TextField: UITextField {
    
    // MARK: - Public Members -
    
    /// Contains various information about a text field.
    var blueprint: TextFieldBlueprint!
    
    /// Determines if text in field falls between min and max characters.
    var inputIsValid: Bool {
        guard let text = text else { return false }
        return text.count >= blueprint.minCharacters && text.count <= blueprint.maxCharacters
    }
    
    // MARK: - Public Methods -
    
    func configure(withBlueprint blueprint: TextFieldBlueprint) {
        
        self.blueprint = blueprint
        
        self.placeholder = blueprint.placeholder
        delegate = self
        font = UIFont(name: Font.main, size: Font.mediumSize)
    }
}

// MARK: - Extension: UITextFieldDelegate -

extension TextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = text else { return false }
        
        guard blueprint.validCharacters.contains(string.lowercased()) || string == "" else { return false }
        
        return text.count < blueprint.maxCharacters || string == ""
    }
}
