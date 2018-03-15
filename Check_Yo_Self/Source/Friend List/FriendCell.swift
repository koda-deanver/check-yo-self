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
    
    @IBOutlet weak var friendImageBackdrop: UIImageView!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var gemLabel: UILabel!
    
    // MARK: - Public Methods -
    
    ///
    /// initial setup for cell.
    ///
    /// - parameter friend: Friend to style cell for.
    ///
    func configure(for friend: User){
        
        if let friendID = friend.facebookID, let friendImage = BSGFacebookService.getImage(forID: friendID)  {
            friendImageBackdrop.image = friend.favoriteColor.alertBackdrop
            friendImageView.image = friendImage
        }
        
        nameLabel.text = friend.username
        nameLabel.font = UIFont(name: Font.main, size: Font.mediumSize)
        
        gemLabel.text = String(friend.gems)
        gemLabel.font = UIFont(name: Font.pure, size: Font.largeSize)
    }
}
