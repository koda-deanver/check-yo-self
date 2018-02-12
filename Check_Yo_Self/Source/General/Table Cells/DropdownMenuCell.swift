//
//  DropdownMenuCell.swift
//  check-yo-self
//
//  Created by Phil on 2/9/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

// MARK: - Protocol -

/// Delegate protocol for handling selections in cell.
protocol DropdownMenuCellDelegate: class {
    func dropdownMenuCell(_ cell: DropdownMenuCell, didSelectChoice choice: String, forQuestion question: Question)
}

// MARK: - Class -

/// Display label with question text, and dropdown menu with choices of question.
class DropdownMenuCell: UITableViewCell {
    
    // MARK: - Public Members -
    
    weak var delegate: DropdownMenuCellDelegate?
    
    // MARK: - Private Members -
    
    private var question: Question!
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    // MARK: - Public Methods -
    
    ///
    /// Set up cell with question.
    ///
    func configure(withQuestion question: Question) {
        
        self.question = question
        label.textColor = .white
        label.text = question.text
        pickerView.alpha = 0.0
    }
    
}

// MARK: - Extension: UITextFieldDelegate -

extension DropdownMenuCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerView.alpha = 1.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        pickerView.alpha = 0.0
    }
}

// MARK: - Extension: UIPickerViewDataSource, UIPickerViewDelegate -

extension DropdownMenuCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return question.choices.count
    }
    
   func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        label.font = UIFont(name: Font.main, size: 16.0)
        label.textColor = .white
        label.textAlignment = .center
        label.text = question.choices[row].text
    
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 18.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let choice = question.choices[row].text
        textField.text = choice
        
        delegate?.dropdownMenuCell(self, didSelectChoice: choice, forQuestion: question)
    }
    
}
