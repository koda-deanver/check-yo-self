//
//  FriendListViewController.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 3/26/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//


import UIKit

/// Display list of Facebook friends. Can only be accessed if logged into Facebook.
final class FriendListViewController: GeneralViewController {
    
    override func viewDidLoad() {
        
        BSGFacebookService.getFriends(completion: { friendTupleArray in
            
            for friend in friendTupleArray {
                DataManager.shared.getUsers(matching: [(field: .facebookID, value: friend.id)], success: { users in
                    
                }, failure: { errorString in
                    
                })
            }
        }, failure: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerData.sharedInstance.friendList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let friend = PlayerData.sharedInstance.friendList[indexPath.row]
        cell.friend = friend
        return cell
    }
    
}

// MARK: - Extension: Actions -

extension FriendListTableViewController {
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
