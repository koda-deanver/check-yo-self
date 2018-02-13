//
//  LabelAndTextFieldCell.swift
//  Check_Yo_Self
//
//  Created by Phil on 1/19/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

// MARK: - Protocol -

protocol LabelAndTextFieldCellDelegate: class {
    func labelAndTextFieldCell(_ cell: LabelAndTextFieldCell, didChangeTextInField textField: TextField)
}

// MARK: - Class -

class LabelAndTextFieldCell: UITableViewCell {
    
    // MARK: - Public Members -
    
    var currentText: String { return textField.text ?? "" }
    var inputIsValid: Bool { return textField.inputIsValid }
    
    // MARK: - Private Members -
    
    private weak var delegate: LabelAndTextFieldCellDelegate?
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: TextField!
    
    // MARK: - Public Methods -
    
    ///
    /// Configure cell text and behavior.
    ///
    /// - parameter placeholder: Text to be displayed both as label for field, and as placeholder text inside field.
    /// - parameter validCharacters: Defines which characters are allowed to be typed in field.
    /// - parameter maxCharacters: Maximum characters allowed.
    /// - parameter minCharacters: Minimum characters allowed.
    ///
    func configure(withTextFieldBlueprint blueprint: TextFieldBlueprint, delegate: LabelAndTextFieldCellDelegate? = nil) {
        
        self.delegate = delegate
        
        label.text = blueprint.placeholder
        label.font = UIFont(name: Font.main, size: Font.mediumSize)
        
        textField.configure(withBlueprint: blueprint)
        textField.font = UIFont(name: Font.main, size: Font.mediumSize)
        textField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        style()
    }
    
    ///
    /// Style visual aspects of cell.
    ///
    private func style() {
        
        backgroundColor = .clear
        textField.backgroundColor = .white
    }
}

// MARK: - Extension: Actions -

extension LabelAndTextFieldCell {
    
    @objc func textFieldDidChange() {
        delegate?.labelAndTextFieldCell(self, didChangeTextInField: textField)
    }
}
