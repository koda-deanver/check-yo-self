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
    
    // MARK: - Private Members -
    
    private var friends: [User] = []
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadFriendTable()
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Get database information for all facebook friends and load into table.
    ///
    private func loadFriendTable() {
        
        showProgressHUD()
        
        BSGFacebookService.getFriends(completion: { friendTupleArray in
            
            for friend in friendTupleArray {
                
                DataManager.shared.getUsers(matching: [(field: .facebookID, value: friend.id)], success: { users in
                    self.hideProgressHUD()
                    self.friends = users
                    self.tableView.reloadData()
                }, failure: { errorString in
                    self.handle(errorString)
                })
            }
        }, failure: { facebookError in
            self.hideProgressHUD()
            
            switch facebookError {
            case .accessToken: self.promptFacebookLogin()
            default: break
            }
        })
    }
    
    ///
    /// Display alert asking user to login to Facebook
    ///
    private func promptFacebookLogin() {
        let alert = BSGCustomAlert(message: "You need to be logged in to Facebook to see friends.", options: [(text: "Login", handler: {
            BSGFacebookService.login()
        }), (text: "Cancel", handler: {})])
        showAlert(alert)
    }
}

// MARK: - Extension: UITableViewDataSource -

extension FriendListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? FriendCell else { return UITableViewCell() }
        cell.configure(for: friends[indexPath.row])
        return cell
    }
}

// MARK: - Extension: Actions -

extension FriendListViewController {
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
