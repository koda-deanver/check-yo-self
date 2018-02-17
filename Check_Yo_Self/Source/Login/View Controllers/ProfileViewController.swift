//
//  ProfileViewController.swift
//  check-yo-self
//
//  Created by Phil on 2/9/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Present user with a series of questions that personalize thier account. These questions are taken from the database.
final class ProfileViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    /// Questions grabbed from database asking user personal info.
    private var profileQuestions: [Question] = []
    
    /// Determines if all fields have been filled.
    private var inputIsValid: Bool {
        
        for cell in tableView.visibleCells where (cell as? DropdownMenuCell)?.inputIsValid == false  {
            return false
        }
        return true
    }
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileQuestions()
    }
    
    override func style() {
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        finishButton.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
        finishButton.isEnabled = false
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Load profile questions from database and reload table.
    ///
    private func loadProfileQuestions() {
        
        showProgressHUD()
        
        DataManager.shared.getQuestions(ofType: .profile, success: { questions in
            
            self.hideProgressHUD()
            
            self.profileQuestions = questions
            self.tableView.reloadData()
            
        }, failure: { errorString in
            self.handle(errorString)
        })
    }
    
    ///
    /// Ensure that required information has been entered before creating account.
    ///
    private func createAccount() {
        
        showProgressHUD()
        
        LoginFlowManager.shared.createAccount(for: User.current, success: {
            self.hideProgressHUD()
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
        }, failure: { errorString in
            self.handle(errorString)
        })
    }
    
}

// MARK: - Extension: UITableViewDataSource, UITableViewDelegate -

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownMenuCell") as? DropdownMenuCell else { return UITableViewCell() }
        cell.configure(withQuestion: profileQuestions[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeightNormal * 2
    }
}

// MARK: - Extension: DropdownMenuCellDelegate -

extension ProfileViewController: DropdownMenuCellDelegate {
    
    func dropdownMenuCell(_ cell: DropdownMenuCell, didSelectChoice choice: Choice, forQuestion question: Question) {
        
        guard let currentUser = User.current else { return }
        
        switch question.id {
        case "PQ-000000": currentUser.favoriteColor = CubeColor.color(fromString: choice.profileValue)
        case "PQ-000001": currentUser.ageGroup = AgeGroup.ageGroup(fromString: choice.profileValue)
        case "PQ-000002": currentUser.favoriteGenre = CollabrationGenre.genre(fromString: choice.profileValue)
        case "PQ-000003": currentUser.identity = Identity.identity(fromString: choice.profileValue)
        default: break
        }
        
        finishButton.isEnabled = inputIsValid
    }
}

// MARK: - Extension: Actions -

extension ProfileViewController {
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        createAccount()
    }
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
}
