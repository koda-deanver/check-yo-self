//********************************************************************
//  CustomTableViewCell.swift
//  Check Yo Self
//  Created by Phil on 12/2/16
//
//  Description: Set up a custom cell with DataEntry objct
//********************************************************************

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var phaseImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    var dataEntry: DataEntry!{
        didSet{
            self.setUpCell()
        }
    }
    
    //********************************************************************
    // setUpCell
    // Description: Set up cell with values from DataEntry
    //********************************************************************
    func setUpCell(){
        if dataEntry.phase == .check{
            self.phaseImage.image = #imageLiteral(resourceName: "TripleCheck")
        }else{
            self.phaseImage.image = UIImage(named: String(format: "%@.png", dataEntry.phase.rawValue))
        }
        scoreLabel.text = String(dataEntry.score)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        startTimeLabel.text = dateFormatter.string(from: dataEntry.startTime)
        endTimeLabel.text = dateFormatter.string(from: dataEntry.endTime)
    }

}
