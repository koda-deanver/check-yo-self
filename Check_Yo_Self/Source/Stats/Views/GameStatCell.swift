//
//  GameStatCell.swift
//  check-yo-self
//
//  Created by phil on 3/20/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Hold information about a single game stat.
struct GameStat {
    let image: UIImage
    let name: String
    let value: String
}

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
    /// - parameter connectionGameStat: Single stat obtained from a connection.
    ///
    func configure(withStat stat: GameStat) {
        
        statImageView.image = stat.image
        
        titleLabel.text = stat.name
        titleLabel.font = UIFont(name: Font.main, size: Font.smallSize)
        titleLabel.textColor = User.current.ageGroup.textColor
        
        valueLabel.text = stat.value
        valueLabel.font = UIFont(name: Font.pure, size: Font.smallSize)
        valueLabel.textColor = User.current.ageGroup.textColor
    }
}
