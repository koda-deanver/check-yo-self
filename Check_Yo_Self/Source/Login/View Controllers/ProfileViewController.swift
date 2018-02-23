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
    
    // MARK: - Public Members -
    
    /// Determines if choices should be populated with previously selected values.
    var shouldPreloadChoices: Bool = false
    
    // MARK: - Private Members -
    
    /// Questions grabbed from database asking user personal info.
    private var profileQuestions: [Question] = []
    
    private var selectedColor: CubeColor!
    private var selectedAgeGroup: AgeGroup!
    private var selectedGenre: CollabrationGenre!
    private var selectedIdentity: Identity!
    
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
        
        selectedColor = User.current.favoriteColor
        selectedAgeGroup = User.current.ageGroup
        selectedGenre = User.current.favoriteGenre
        selectedIdentity = User.current.identity
    }
    
    override func style() {
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        finishButton.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
        finishButton.isEnabled = inputIsValid
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
    /// Get the last choice that user picked.
    ///
    /// If *shouldPreloadChoices* is false, it means this is the users' first time through and all fields should display placeholder text.
    ///
    /// - returns: The last choice that was displayed or nil.
    ///
    private func getPreviouslySelectedChoice(forQuestion question: Question) -> Choice? {
        
        guard shouldPreloadChoices, let currentUser = User.current else { return nil }
        
        var previousChoiceProfileValue: String = ""
        
        switch question.id {
        case "PQ-000000": previousChoiceProfileValue = currentUser.favoriteColor.rawValue
        case "PQ-000001": previousChoiceProfileValue = currentUser.ageGroup.rawValue
        case "PQ-000002": previousChoiceProfileValue = currentUser.favoriteGenre.rawValue
        case "PQ-000003": previousChoiceProfileValue = currentUser.identity.rawValue
        default: break
        }
        
        for choice in question.choices where choice.profileValue == previousChoiceProfileValue {
            return choice
        }
        return nil
    }
    
    ///
    /// Ensure that required information has been entered before creating account.
    ///
    private func createAccount() {
        
        showProgressHUD()
        updateUserWithSelections()
        
        LoginFlowManager.shared.updateAccount(for: User.current, success: {
            NotificationManager.shared.postNotification(ofType: .profileUpdated)
            self.navigateToCubeScreen()
        }, failure: { errorString in
            self.handle(errorString)
        })
    }
    
    ///
    /// Updates current user with profile values selected in dropdowns.
    ///
    private func updateUserWithSelections() {
    
        User.current.favoriteColor = selectedColor
        User.current.ageGroup = selectedAgeGroup
        User.current.favoriteGenre = selectedGenre
        User.current.identity = selectedIdentity
    }
    
    ///
    /// Performs correct sequence to reach *cubeViewController* based on if User is creating or editing profile.
    ///
    private func navigateToCubeScreen() {
        
        /// If this fails means user is updating profile and is not initial creation. Just dismiss this viewController.
        guard let loginViewController = self.presentingViewController as? LoginViewController else {
            self.hideProgressHUD()
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        /// For first time creation launch *cubeViewController* from *loginViewController*
        dismiss(animated: true) {
            
            self.hideProgressHUD()
            loginViewController.presentCubeScreenWithVideo()
        }
    }
}

// MARK: - Extension: UITableViewDataSource, UITableViewDelegate -

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownMenuCell") as? DropdownMenuCell else { return UITableViewCell() }
        
        let question = profileQuestions[indexPath.row]
        let previousChoice = getPreviouslySelectedChoice(forQuestion: question)
        
        cell.configure(withQuestion: question, selectedChoice: previousChoice, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeightNormal * 2
    }
}

// MARK: - Extension: DropdownMenuCellDelegate -

extension ProfileViewController: DropdownMenuCellDelegate {
    
    func dropdownMenuCell(_ cell: DropdownMenuCell, willActivatePicker pickerView: UIPickerView) {
        
        for cell in tableView.visibleCells {
            (cell as? DropdownMenuCell)?.togglePickerView(on: false)
        }
    }
    
    func dropdownMenuCell(_ cell: DropdownMenuCell, didSelectChoice choice: Choice, forQuestion question: Question) {
        
        switch question.id {
        case "PQ-000000": selectedColor = CubeColor.color(fromString: choice.profileValue)
        case "PQ-000001": selectedAgeGroup = AgeGroup.ageGroup(fromString: choice.profileValue)
        case "PQ-000002": selectedGenre = CollabrationGenre.genre(fromString: choice.profileValue)
        case "PQ-000003": selectedIdentity = Identity.identity(fromString: choice.profileValue)
        default: break
        }
        
        finishButton.isEnabled = inputIsValid
    }
}

// MARK: - Extension: Actions -

extension ProfileViewController {
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        createAccount()
    }
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
}
