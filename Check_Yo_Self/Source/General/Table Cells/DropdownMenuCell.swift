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
    
    /// Determines if current field has taken input.
    var inputIsValid: Bool {
        guard let text = textField.text else { return false }
        return text.count >= 1
    }
    
    // MARK: - Private Members -
    
    private var question: Question!
    private weak var delegate: DropdownMenuCellDelegate?
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    // MARK: - Public Methods -
    
    ///
    /// Set up cell with question.
    ///
    func configure(withQuestion question: Question, delegate: DropdownMenuCellDelegate? = nil) {
        
        self.question = question
        self.delegate = delegate
        
        label.textColor = .white
        label.text = question.text
        
        textField.delegate = self
        
        pickerView.alpha = 0.0
    }
}

// MARK: - Extension: UITextFieldDelegate -

extension DropdownMenuCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        guard let choice = (pickerView.view(forRow: selectedRow, forComponent: 0) as? UILabel)?.text else { return }
        
        textField.text = choice
        pickerView.alpha = 1.0
        
        delegate?.dropdownMenuCell(self, didSelectChoice: choice, forQuestion: question)
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
        return 16.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let choice = question.choices[row].text
        textField.text = choice
        
        delegate?.dropdownMenuCell(self, didSelectChoice: choice, forQuestion: question)
    }
    
}
