//
//  GameRecordsViewController.swift
//  check-yo-self
//
//  Created by phil on 12/2/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Display previous game data for current user.
final class GameRecordsViewController: SkinnedViewController {
    
    // MARK: - Public Members -
    
    var shouldShowAd: Bool = false
    
    // MARK: - Private Members -
    
    //Use profile to represent no filter.
    /// The question type that list is filtered for.
    private var currentType: QuestionType = .profile
    private var allRecords: [GameRecord] = []
    private var filteredRecords: [GameRecord] = []
    
    /// Used to pass game record through segue on selection.
    private var selectedGame: GameRecord?
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var filterButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        showProgressHUD()
        
        DataManager.shared.getGameRecords(forUser: User.current, success: { gameRecords in
            
            self.hideProgressHUD()
            self.allRecords = gameRecords
            
            self.filterButton.title = "All Types"
            self.filteredRecords = self.filter(self.allRecords, forType: self.currentType)
            self.tableView.reloadData()
            
        }, failure: { error in
            self.handle(error)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if shouldShowAd {
            Chartboost.showInterstitial(CBLocationGameOver)
            shouldShowAd = false
        }
    }
    
    // MARK: - Private methods -
    
    ///
    /// Filter given array for specific game type.
    ///
    /// If the type is set to *profile*, this method does **NOT** apply a filter and shows all records.
    /// - records: The original game records to filter.
    /// - type: The type of record to filter for.
    ///
    private func filter(_ records: [GameRecord], forType type: QuestionType) -> [GameRecord] {
        
        if type == .profile { return allRecords }
        
        var filteredRecords: [GameRecord] = []
        var filteredRecordCount = 0
        
        for record in allRecords where record.questionType == type {
            filteredRecords.append(record)
            filteredRecordCount += 1
            
            if filteredRecordCount >= Configuration.gameRecordMax { break }
        }
        
        return filteredRecords
    }
    
    ///
    /// Send selected game to *GameRecordDetailsViewController*.
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameRecordDetailsViewController = segue.destination as? GameRecordDetailsViewController else { return }
        gameRecordDetailsViewController.gameRecord = selectedGame
    }
}

// MARK: - Extension: UITableViewDataSource, UITableViewDelegate -

extension GameRecordsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameRecordCell", for: indexPath) as? GameRecordCell else { return UITableViewCell() }
        cell.configure(forGameRecord: filteredRecords[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeightNormal
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGame = filteredRecords[indexPath.row]
        performSegue(withIdentifier: "showGameRecordDetails", sender: self)
    }
    
}

// MARK: - Extension: Actions -

extension GameRecordsViewController {
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
      
        for index in 0 ..< QuestionType.all.count where QuestionType.all[index] == currentType {
            
            var newIndex = index + 1
            if newIndex >= QuestionType.all.count { newIndex = 0 }
            
            currentType = QuestionType.all[newIndex]
            filterButton.title = currentType == .profile ? "All Types" : currentType.displayString
            filteredRecords = filter(allRecords, forType: currentType)
            tableView.reloadData()
            
            break
        }
    }
}
