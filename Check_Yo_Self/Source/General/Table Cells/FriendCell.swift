//********************************************************************
//  FriendCell.swift
//  Check Yo Self
//  Created by Phil on 3/26/17
//
//  Description: Single cell displaying a friend
//********************************************************************

import UIKit

class FriendCell: UITableViewCell {
    
    var friend: Friend!{
        didSet{
            self.setUpCell()
        }
    }
    
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //********************************************************************
    // setUpCell
    // Description: Set up cell with values from Friend
    //********************************************************************
    func setUpCell(){
        self.picView.image = UIImage(data: friend.facebookImageData as! Data)
        self.nameLabel.text = friend.facebookName
    }
    
}
