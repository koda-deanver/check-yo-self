//
//  GameRecordCell.swift
//  check-yo-self
//
//  Created by phil on 12/2/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Display information about a single *GameRecord*.
final class GameRecordCell: UITableViewCell {

    // MARK: - Private Members -
    
    private var gameRecord: GameRecord!
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    
    // MARK: - Public Methods -
    
    ///
    /// Initial setup for cell.
    ///
    /// - parameter record: Game record to set up cell for.
    ///
    func configure(forGameRecord record: GameRecord) {
        
        self.gameRecord = record
        
        typeImageView.image = gameRecord.questionType.image
        scoreLabel.text = String(gameRecord.score)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        startTimeLabel.text = dateFormatter.string(from: gameRecord.startTime)
        endTimeLabel.text = dateFormatter.string(from: gameRecord.endTime)
    }

}
