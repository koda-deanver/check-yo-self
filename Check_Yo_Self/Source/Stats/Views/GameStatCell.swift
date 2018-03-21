//
//  GameStatCell.swift
//  check-yo-self
//
//  Created by phil on 3/20/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Holds single stat from connection in *GameRecordDetails*.
final class GameStatCell: UITableViewCell {
    
    // MARK: - Outlets -
    
    @IBOutlet private var statImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    
    // MARK: - Public Methods -
    
    ///
    /// Setup for cell.
    ///
    /// - parameter image: Image to display on left of cell.
    /// - parameter title: Text to display in middle label.
    /// - parameter value: Text to display in right hand label.
    ///
    func configure(withImage image: UIImage, title: String, value: String) {
        
        statImageView.image = image
        
        titleLabel.text = title
        titleLabel.font = UIFont(name: Font.main, size: Font.mediumSize)
        
        valueLabel.text = value
        valueLabel.font = UIFont(name: Font.main, size: Font.mediumSize)
        valueLabel.textColor = User.current.favoriteColor.uiColor
    }
}
