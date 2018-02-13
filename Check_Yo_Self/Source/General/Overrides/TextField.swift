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
    
    /// Text to display as placeholder in field.
    let placeholder: String
    /// Determines what type of characters can be typed in field.
    let validCharacters: [String]
    /// Maximum number of characters that can be typed in field.
    let maxCharacters: Int
    /// Minimum number of characters to return valid input. Does **NOT** stop field from containing less.
    let minCharacters: Int
    /// Determines if characters are hidden
    let isSecure: Bool
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
        
        placeholder = blueprint.placeholder
        isSecureTextEntry = blueprint.isSecure
        font = UIFont(name: Font.main, size: Font.mediumSize)
        
        autocorrectionType = .no
        delegate = self
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
