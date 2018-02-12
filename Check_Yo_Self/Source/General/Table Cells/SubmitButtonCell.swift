//
//  SubmitButtonCell.swift
//  Check_Yo_Self
//
//  Created by Phil Rattazzi on 1/22/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

// MARK: - Protocol: SubmitButtonCellDelegate -

protocol SubmitButtonCellDelegate: class {
    func submitButtonCell(_ cell: SubmitButtonCell, didPressSubmitButton: UIButton)
}

// MARK: - Class: SubmitButtonCell -

class SubmitButtonCell: UITableViewCell {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var submitButton: UIButton!
    weak var delegate: SubmitButtonCellDelegate!
}

// MARK: - Extension: Actions -

extension SubmitButtonCell {
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        delegate.submitButtonCell(self, didPressSubmitButton: submitButton)
    }
}
