//
//  FriendListViewController.swift
//  check-yo-self
//
//  Created by phil on 3/26/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Display list of Facebook friends. Can only be accessed if logged into Facebook.
final class FriendListViewController: SkinnedViewController {
    
    // MARK: - Private Members -
    
    private var friends: [User] = []
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createDummyFriends()
        loadFriendTable()
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Get database information for all facebook friends and load into table.
    ///
    private func loadFriendTable() {
        
//        showProgressHUD()
        self.tableView.reloadData()
        
//        BSGFacebookService.getFriends(completion: { friendTupleArray in
//
//            for friend in friendTupleArray {
//                print(friend)
//                DataManager.shared.getUsers(matching: [(field: .facebookID, value: friend.id)], success: { users in
//                    self.hideProgressHUD()
//                    self.friends = users
//                    self.tableView.reloadData()
//                }, failure: { errorString in
//                    self.handle(errorString)
//                })
//            }
//        }, failure: { facebookError in
//            self.hideProgressHUD()
//
//            switch facebookError {
//            case .missingAccessToken: self.promptFacebookLogin(); break
//            case .missingData: self.handle("No data"); break
//            default: break
//            }
//        })
    }
    
    private func createDummyFriends(){
        let firstnames = ["Jackie", "Mario", "Lily", "Mica", "Bomin"]
        let lastnames = ["Chan", "Berdan", "Co", "San", "Lee"]
        let gamertags = ["jchan", "mberdan", "lilyco", "micamica", "bomin88"]
        let userids = ["ABC00001", "ABC00002", "ABC00003", "ABC00004", "ABC00005"]
        let fbids = ["FB0001", "FB0002", "FB0003", "FB0004", "FB0005"]
        let gems = [10,4,2,15,20]
        
        for x in (0..<firstnames.count)  {
            let fullname = "\(firstnames[x]) \(lastnames[x])"
            friends.append(User.init(withSnapshot: ["email": "\(firstnames[x])@gmail.com",
                "firstname": "\(firstnames[x])",
                "lastname": "\(lastnames[x])",
                "gamer-tag": "\(gamertags[x])",
                "userId": "\(userids[x])",
                "gems": gems[x],
                "facebook-id": "\(fbids[x])",
                "facebook-name": "\(fullname)",
                "profile": ["favorite-color": "none",
                            "age-group": "adult",
                            "favorite-genre": "live",
                            "identity": "unknown"
                ]])!)
        }
    }
    
    ///
    /// Display alert asking user to login to Facebook
    ///
    private func promptFacebookLogin() {
        let alert = BSGCustomAlert(message: "You need to be logged in to Facebook to see friends.", options: [(text: "Login", handler: {
            DataManager.shared.loginFacebook(success: {
                self.showAlert(BSGCustomAlert(message: "Login Succeeded!"))
            }, failure: { _ in
                self.showAlert(BSGCustomAlert(message: "Login Failed."))
            })
        }), (text: "Cancel", handler: {})])
        showAlert(alert)
    }
}

// MARK: - Extension: UITableViewDataSource -

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? FriendCell else { return UITableViewCell() }
        cell.configure(for: friends[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeightNormal
    }
    
}

// MARK: - Extension: Actions -

extension FriendListViewController {
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
