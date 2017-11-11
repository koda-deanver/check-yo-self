//********************************************************************
//  FriendListTableViewController.swift
//  Check Yo Self
//  Created by Phil on 3/26/17
//
//  Description: Display table of friends
//********************************************************************

import UIKit


class FriendListTableViewController: UITableViewController {
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //********************************************************************
    // numberOfSections
    // Description: Always return 1 section
    //********************************************************************
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //********************************************************************
    // numberOfRowsInSection
    // Description: Return number of friends that play WhoDat
    //********************************************************************
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(PlayerData.sharedInstance.friendList)
        return PlayerData.sharedInstance.friendList.count
    }
    
    //********************************************************************
    // cellForRowAt
    // Description: Setup individual cell
    //********************************************************************
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let friend = PlayerData.sharedInstance.friendList[indexPath.row]
        cell.friend = friend
        return cell
    }
    
}
