//
//  CubeColor.swift
//  check-yo-self
//
//  Created by Phil on 3/26/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// TableViewCell displaying information about a Facebook friend.
class FriendCell: UITableViewCell {
    
    // MARK: - Private Members -
    
    private var friend: User!
    
    // MARK: - Outlets -
    
    @IBOutlet weak var backdrop: UIImageView!
    
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var gemLabel: UILabel!
    
    // MARK: - Public Methods -
    
    ///
    /// initial setup for cell.
    ///
    func configure(for friend: User){
        
        backdrop.image = friend.favoriteColor.connectionBackdrop
        
        if let friendID = friend.facebookID, let friendImage = BSGFacebookService.getImage(forID: friendID)  {
            friendImageView.image = friendImage
        }
        
        nameLabel.text = friend.username
        gemLabel.text = String(friend.gems)
    }
}
