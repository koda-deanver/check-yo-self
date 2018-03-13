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
    
    static let all = alphabet + numeric + specialCharacters
}

// MARK: - Protocol -

/// Delegate to forward methods from UITextFieldDelegate.
protocol TextFieldDelegate: class {
    
    func textFieldSelected(_ textField: TextField)
}

// MARK: - Struct -

/// Model to build text fields from.
struct TextFieldBlueprint {
    
    /// Text to display as placeholder in field.
    let placeholder: String
    /// Deterines is cursor can be placed in field.
    let isEditable: Bool
    /// Determines if characters are hidden
    let isSecure: Bool
    /// Maximum number of characters that can be typed in field.
    let maxCharacters: Int
    /// Minimum number of characters to return valid input. Does **NOT** stop field from containing less.
    let minCharacters: Int
    /// Determines what type of characters can be typed in field.
    let validCharacters: [String]
    
    // MARK: - Initializers -
    
    init(withPlaceholder placeholder: String, isEditable: Bool = true, isSecure: Bool = false, maxCharacters: Int = 99, minCharacters: Int = 0, limitCharactersTo validCharacters: [String] = CharacterType.all) {
        self.placeholder = placeholder
        self.isEditable = isEditable
        self.isSecure = isSecure
        self.maxCharacters = maxCharacters
        self.minCharacters = minCharacters
        self.validCharacters = validCharacters
    }
}

// MARK: - Class -

/// Common class for dealing with text fields.
class TextField: UITextField {
    
    // MARK: - Private Members -
    
    /// Contains various information about a text field.
    private var blueprint: TextFieldBlueprint!
    
    /// Delegate to forward UITextField events to.
    private var parentDelegate: TextFieldDelegate?
    
    // MARK: - Public Members -
    
    /// Determines if there is text in the textField.
    var isEmpty: Bool {
        guard let text = text else { return true }
        return text.isEmpty
    }
    
    /// Determines if text in field falls between min and max characters.
    var inputIsValid: Bool {
        guard let text = text else { return false }
        return text.count >= (blueprint.minCharacters) && text.count <= (blueprint.maxCharacters)
    }
    
    // MARK: - Public Methods -
    
    func configure(withBlueprint blueprint: TextFieldBlueprint, delegate: TextFieldDelegate?) {
        
        self.blueprint = blueprint
        self.parentDelegate = delegate
        
        placeholder = blueprint.placeholder
        isSecureTextEntry = blueprint.isSecure
        font = UIFont(name: Font.main, size: Font.mediumSize)
        
        autocorrectionType = .no
        self.delegate = self
    }
}

// MARK: - Extension: UITextFieldDelegate -

extension TextField: UITextFieldDelegate {
    
    ///
    /// Start editing if enabled in blueprint. Parent delegate method is called either way.
    ///
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        parentDelegate?.textFieldSelected(self)
        return blueprint.isEditable
    }
    
    ///
    /// Allow changing characters if below the max character limit in blueprint.
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = text else { return false }
        
        guard blueprint.validCharacters.contains(string.lowercased()) || string == "" else { return false }
        
        return text.count < blueprint.maxCharacters || string == ""
    }
}
