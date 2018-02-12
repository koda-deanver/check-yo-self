//
//  ProfileViewController.swift
//  check-yo-self
//
//  Created by Phil on 2/9/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Present user with a series of questions that personalize thier account. These questions are taken from the database.
class ProfileViewController: UIViewController {
    
    // MARK: - Private Members -
    
    private var profileQuestions: [Question] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        loadProfileQuestions()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Load profile questions from database and reload table.
    ///
    private func loadProfileQuestions() {
        DataManager.shared.getQuestions(ofType: .profile, success: { questions in
            self.profileQuestions = questions
            self.tableView.reloadData()
        }, failure: { errorString in
            // TODO: Show alert
        })
    }
    
    ///
    /// Ensure that required information has been entered before creating account.
    ///
    private func createAccount() {
        
        LoginFlowManager.shared.createAccount(for: User.current, success: {
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
        }, failure: { errorString in
            // TODO: Handle error
        })
    }
}

// MARK: - Extension: UITableViewDataSource, UITableViewDelegate -

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileQuestions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == profileQuestions.count {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "submitButtonCell") as? SubmitButtonCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownMenuCell") as? DropdownMenuCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(withQuestion: profileQuestions[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == profileQuestions.count ? 40.0 : 120.0
    }
}

// MARK: - Extension: DropdownMenuCellDelegate -

extension ProfileViewController: DropdownMenuCellDelegate {
    
    func dropdownMenuCell(_ cell: DropdownMenuCell, didSelectChoice choice: String, forQuestion question: Question) {
        
        switch question.id {
        case "PQ-000000": User.current?.favoriteColor = JabbrColor.colorFromString(choice.lowercased())
        case "PQ-000001": User.current?.ageGroup = choice
        case "PQ-000002": User.current?.favoriteGenre = choice
        case "PQ-000003": User.current?.identity = choice
        default: break
        }
    }
}

// MARK: - Extension: SubmitButtonCellDelegate -

extension ProfileViewController: SubmitButtonCellDelegate {
    
    func submitButtonCell(_ cell: SubmitButtonCell, didPressSubmitButton: UIButton) {
        createAccount()
    }
}
