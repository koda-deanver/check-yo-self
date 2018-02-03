//
//  FriendListTableViewController.swift
//  Check_Yo_Self
//
//  Created by Phil Rattazzi on 3/26/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//


import UIKit

/// Display list of Facebook friends. Can only be accessed if logged into Facebook.
final class FriendListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        
        PlayerData.sharedInstance.loadFriendsFB(completion: { friendIDArray in
            
            for id in friendIDArray {
                
                DataManager.shared.getUsers(matching: [(field: .facebookID, value: id)], success: { users in
                    print(users)
                }, failure: { errorString in
                    
                })
            }
        })
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
