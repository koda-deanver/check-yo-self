//********************************************************************
//  StatsViewController.swift
//  Check Yo Self
//  Created by Phil on 12/2/16
//
//  Description: Table displaying results of previous games
//********************************************************************

import UIKit

class StatsViewController: UITableViewController {
    let MAX_ENTRIES = 180
    var filterPhase: CreationPhase = .none
    var filteredData: [GameRecord] = []
    var shouldShowAd: Bool!
    
    @IBOutlet weak var phaseFilterButton: UIBarButtonItem!
    
    //********************************************************************
    // Action: phaseFilterButtonPressed
    // Description: Change to next filterPhase and update table
    //********************************************************************
    @IBAction func phaseFilterButtonPressed(_ sender: UIButton) {
        switch(self.filterPhase){
        case .none:
            self.filterPhase = .check
        case .check:
            self.filterPhase = .brainstorm
        case .brainstorm:
            self.filterPhase = .develop
        case .develop:
            self.filterPhase = .align
        case .align:
            self.filterPhase = .improve
        case .improve:
            self.filterPhase = .make
        case .make:
            self.filterPhase = .none
        }
        self.phaseFilterButton.title = self.filterPhase.rawValue
        if self.filterPhase == .none{
           self.phaseFilterButton.title = "All Phases"
        }
        
        tableView.reloadData()
    }
    
    //********************************************************************
    // Action: deleteUserData
    // Description: Completely delete user data and force back to login screen
    // to recreate
    //********************************************************************
    @IBAction func deleteUserData(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        //PlayerData.sharedInstance.deletePlayer()
        let newView: LoginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginScene") as! LoginViewController
        self.present(newView, animated: true, completion: nil)
    }
    
    //********************************************************************
    // filterData
    // Description: Sort array to only contain the filtered data to show on
    // table
    //********************************************************************
    func filterData() -> Int{
        self.filteredData.removeAll()
        //let totalDataCount = PlayerData.sharedInstance.dataArray.count
        var count = 0
        /*for index in 1 ..< totalDataCount{
            if count >= MAX_ENTRIES{
                return count
            }
            let possibleEntry = PlayerData.sharedInstance.dataArray[totalDataCount - index]
            // No Filter Needed
            if(self.filterPhase == .none){
                self.filteredData.append(possibleEntry)
                count += 1
                // Filter for correct Phase
            }else{
                if(possibleEntry.phase == self.filterPhase){
                    self.filteredData.append(possibleEntry)
                    count += 1
                }
            }
        }*/
        return count
    }
    
    //********************************************************************
    // viewWillAppear
    // Description: Reload table each time tab is pressed
    //********************************************************************
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*if PlayerData.sharedInstance.playsToday >= PlayerData.sharedInstance.playsPerDay{
            /*self.showConnectionAlert(ConnectionAlert(title: "CONGRATS! You've reached your daily limit of redeemable JabbRGems!", message: "Feel free to play indefinitely to run up the points on on your TEAM & earn more gems when you CHECKIn tomorrow", okButtonText: "Alright"))*/
        }*/
        self.filterPhase = .none
        self.phaseFilterButton.title = "All Phases"
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if shouldShowAd { Chartboost.showInterstitial(CBLocationGameOver) }
    }
    
    //********************************************************************
    // numberOfSections
    // Description: Always return 1 section
    //********************************************************************
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //********************************************************************
    // numberOfRowsInSection
    // Description: Return the count from filtered data as number of rows
    //********************************************************************
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData()
    }

    //********************************************************************
    // cellForRowAt
    // Description: Setup individual cell
    //********************************************************************
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! CustomTableViewCell
        let dataEntry = self.filteredData[indexPath.row]
        //cell.dataEntry = dataEntry
        return cell
    }
    
    //********************************************************************
    // tableView
    // Description: Temporarily store data from cell to display on detailed
    // page
    //********************************************************************
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //PlayerData.sharedInstance.tableIndex = filteredData[indexPath.row]
    }
}
