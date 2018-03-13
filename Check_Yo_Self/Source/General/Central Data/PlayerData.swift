//********************************************************************
//  PlayerData.swift
//  Check Yo Self
//  Created by Phil on 12/2/16
//
//  Description: Used to store details about the current player and an 
//  array of DataEntry objects
//********************************************************************

import UIKit
import CoreLocation
import FacebookLogin
import FacebookCore
import Firebase

class PlayerData: NSObject, NSCoding, CLLocationManagerDelegate {
    static var sharedInstance = PlayerData()
    
    // Used to get Player Location from anywhere in the app
    var locationManager: CLLocationManager?
    
    var gemTotal: Int{
        didSet{
            // gemTotal can't drop below 0
            if gemTotal < 0{
                gemTotal = 0
            }
        }
    }
    // Number of times player has played today
    var playsToday: Int{
        var plays = 0
        let calender = Calendar(identifier: .gregorian)
        // Add one for each time game is played today
        for entry in dataArray where calender.isDateInToday(entry.endTime){
            // Profile phase doesn't count toward plays
            if entry.phase != .none{
                plays += 1
            }
        }
        return plays
    }
    // Number of times per today player can earn gems for playing
    var playsPerDay: Int{
        let profileScore = dataArray[0].score
        switch(profileScore){
        case -40 ... -1:
            return 5
        case 0 ... 19:
            return 6
        case 20 ... 59:
            return 7
        case 60:
            return 10
        default:
            return 0
        }
    }
    
    var runCheckOnce: Bool = false
    var dataArray: [DataEntry]
    var tableIndex: DataEntry? = nil
    var creationPhase: CreationPhase
    var fitbitToken: String?
    
    // Saved to Firebase
    var displayName: String = "???"
    var cubeColor: CubeColor = .none
    var avatar: Avatar?
    var isAdult: Bool = true
    // gemTotal saved as well
    
    // Facebook
    var facebookID: String?
    var facebookImageData: NSData?
    //var friendList: [Friend] = []
    
    //********************************************************************
    // Designated Initializer
    // Description: Initialize all variables of class
    //********************************************************************
    private init(gemTotal: Int, creationPhase: CreationPhase, dataArray: [DataEntry], fitbitToken: String?){
        self.gemTotal = gemTotal
        self.creationPhase = creationPhase
        self.dataArray = dataArray
        self.fitbitToken = fitbitToken
    }
    
    //********************************************************************
    // Convenience Initializer
    // Description: Check if PlayerData has been saved, and call default
    // initializer with either new object orsaved one
    //********************************************************************
    private override convenience init(){
        //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        // Saved player exists. Load it
        if let savedPlayerData = UserDefaults.standard.object(forKey: "playerDataArchive") as! Data?{
            let savedPlayer = NSKeyedUnarchiver.unarchiveObject(with: savedPlayerData) as! PlayerData
            self.init(gemTotal: savedPlayer.gemTotal, creationPhase: savedPlayer.creationPhase, dataArray: savedPlayer.dataArray, fitbitToken: savedPlayer.fitbitToken)
            print("PLAYER LOADED\n\(self)")
        // No saved player. Create a new one
        }else{
            let emptyDataArray: [DataEntry] = []
            self.init(gemTotal: 0, creationPhase: .none, dataArray: emptyDataArray, fitbitToken: nil)
            print("NEW PLAYER CREATED\n\(self)")
        }
    }
    
    //********************************************************************
    // Required Convenience Initializer
    // Description: Required to initialize from archived object
    //********************************************************************
    convenience required init?(coder aDecoder: NSCoder) {
        let gemTotal = aDecoder.decodeInteger(forKey: "gemTotal")
        let phaseValue = aDecoder.decodeObject(forKey: "phase") as! String
        let creationPhase = CreationPhase(rawValue: phaseValue)!
        let dataArray = aDecoder.decodeObject(forKey: "dataArray") as! [DataEntry]
        var savedFitbitToken: String?
        if let fitbitToken = aDecoder.decodeObject(forKey: "fitbitToken") as? String{
            savedFitbitToken = fitbitToken
        }
        
        self.init(gemTotal: gemTotal, creationPhase: creationPhase, dataArray: dataArray, fitbitToken: savedFitbitToken)
    }
    
    //********************************************************************
    // encode
    // Description: Enable PlayerData to be archived
    //********************************************************************
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.gemTotal, forKey:"gemTotal")
        aCoder.encode(self.creationPhase.rawValue, forKey:"phase")
        aCoder.encode(self.dataArray, forKey:"dataArray")
        // Save Token is there is one
        if let authToken = self.fitbitToken{
            aCoder.encode(authToken, forKey:"authToken")
        }
    }
    
    //********************************************************************
    // addDataEntry
    // Description: Create new DataEntry object and add to dataArray
    //********************************************************************
    func addDataEntry(phase: CreationPhase, score: Int, startTime: Date, location: CLLocation?, steps: Int?, heartDictionary: [String: Int]?){
        let dataEntry = DataEntry(phase: phase, score: score, startTime: startTime, location: location, steps: steps, heartDictionary: heartDictionary)
        if phase == .none{
            // Initial profile setup
            if dataArray.isEmpty{
                self.dataArray.append(dataEntry)
                // Award gems based on profile pick first time only
                self.gemTotal += (self.playsPerDay * 10)
            }else{
                // User is changing profile
                self.dataArray[0] = dataEntry
            }
            self.creationPhase = .check
        }else{
            self.dataArray.append(dataEntry)
            dataEntry.gemsEarned = calculateGems(score: score, steps: steps, heartDictionary: heartDictionary)
            self.gemTotal += dataEntry.gemsEarned
        }
        self.archivePlayer()
    }
    
    //********************************************************************
    // calculateGems
    // Description: Return gems earned if not at play limit for the day
    // otherwise return 0
    //********************************************************************
    func calculateGems(score: Int, steps: Int?, heartDictionary: [String: Int]?) -> Int{
        if PlayerData.sharedInstance.playsToday < PlayerData.sharedInstance.playsPerDay{
            // Calculate gems earned
            let scorePortion = (score/2)
            var stepPortion: Int
            if let stepCount = steps{
                // 0 - 10000 steps
                if stepCount <= 10000{
                    stepPortion = (stepCount / 1000)
                    // > 10000 steps
                }else{
                    stepPortion = 10 + ((stepCount - 10000) / 2000)
                }
                // No Steps
            }else{
                stepPortion = 0
            }
            
            var FBMult: Double = 1.0
            if let heartDictionary = heartDictionary{
                FBMult += 0.1
                // Resting heart rate retrieved and is less than 60
                if let restingHeartRate = heartDictionary[HeartCategory.restingHeartRate.rawValue], restingHeartRate < 60{
                    FBMult += 0.1
                }
                if let peakMinutes = heartDictionary[HeartCategory.peakMinutes.rawValue], peakMinutes > 2{
                    FBMult += 0.1
                }
                if let cardioMinutes = heartDictionary[HeartCategory.cardioMinutes.rawValue], cardioMinutes > 10{
                    FBMult += 0.1
                }
                if let fatBurnMinutes = heartDictionary[HeartCategory.fatBurnMinutes.rawValue], fatBurnMinutes > 60{
                    FBMult += 0.1
                }
            }
            var phaseMult = 1.0
            if(creationPhase != .check){
                phaseMult *= 2
            }
            let unRoundedGems = Double(scorePortion + stepPortion) * FBMult * phaseMult
            let finalGems = Int((unRoundedGems) + 1)
            return finalGems
        }else{
            // Player maxed out on gems for the day
            return 0
        }
    }
    
    //********************************************************************
    // roundToTen
    // Description: Used to easilt round numbers for gem algorithm
    //********************************************************************
    func roundToTen(_ number: Int) -> Int{
        if number > 0{
            return (number - (number % 10))
        }else{
            let positiveInt = abs(number)
            let roundedDown = positiveInt - (positiveInt % 10)
            return (-roundedDown)
        }
    }
    
    //********************************************************************
    // archivePlayer
    // Description: Save player to user defaults
    //********************************************************************
    func archivePlayer(){
        let playerDataArchive = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(playerDataArchive, forKey: "playerDataArchive")
        print("PLAYER ARCHIVED\n\(self)")
    }
    
    //********************************************************************
    // deletePlayer
    // Description: Delete player from user defaults and create new instance
    //********************************************************************
    func deletePlayer(){
        //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        print("PLAYER DELETED\n\(self)")
        PlayerData.sharedInstance = PlayerData()
    }
    
    //********************************************************************
    // getLocation
    // Description: Return player location is maps are authorized
    //********************************************************************
    func getLocation() -> CLLocation?{
        return self.locationManager?.location
    }
    
    //********************************************************************
    // locationManager(didChangeAuthorization
    // Description: Delegate method called when auth is changed
    //********************************************************************
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        /*if status == .authorizedWhenInUse{
            for connection in Constants.connections where connection.type == .maps{
                connection.checkConnection()
            }
        }*/
    }
    
    

    
    //********************************************************************
    // loadPlayerFB
    // Description: Grab updated name and pic from facebook and save locally
    // Erros: Connection, Facebook, Data
    //********************************************************************
    func loadPlayerFB(completion: @escaping () -> Void = {}, failure: @escaping (ErrorType) -> Void = {_ in }){
        if AccessToken.current != nil {
            let connection = GraphRequestConnection()
            connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, name"])) { httpResponse, result in
                switch result {
                case .success(let response):
                    if let facebookDictionary = response.dictionaryValue{
                        // Player needs to have name and ID
                        if let userID = facebookDictionary ["id"] as? String{
                            self.facebookID = userID
                            let picURL = URL(string: "https://graph.facebook.com/\(userID)/picture?type=large")!
                            let picData = NSData(contentsOf: picURL)
                            // Save image data to player
                            self.facebookImageData = picData
                            // Reload labels and pic
                            completion()
                        }else{
                            failure(.data("Name/ID"))
                        }
                    }
                case .failed(let error):
                    failure(.connection(error))
                }
            }
            connection.start()
        }else{
            failure(.permissions("Access Token"))
        }
    }

    //********************************************************************
    // savePlayerFirebase
    // Description: Save import data to Firebase
    //********************************************************************
    func savePlayerFirebase(completion: () -> (), failure: (ErrorType) -> ()){
        if let user = Auth.auth().currentUser{
            let rootNode = Database.database().reference(fromURL: "https://check-yo-self-18682434.firebaseio.com/")
            let playerNode = rootNode.child("Users/\(user.uid)")
           
            let playerStats: [String: Any] = [
                "DisplayName": self.displayName,
                "CubeColor": self.cubeColor.rawValue,
                "Gems": self.gemTotal,
                "AgeGroup": self.isAdult ? "Adult" : "Child",
                "AvatarName": self.avatar != nil ? self.avatar!.name : "",
                "FacebookID": self.facebookID != nil ? self.facebookID! : ""
            ]
            playerNode.updateChildValues(playerStats)
            completion()
        }else{
            failure(.permissions("No current Firebase User"))
        }
    }
    
    //********************************************************************
    // loadPlayerFirebase
    // Description: Get stored player data from firebase
    //********************************************************************
    func loadPlayerFirebase(completion: @escaping () -> (), failure: @escaping (ErrorType) -> ()){
        if let user = Auth.auth().currentUser{
            let rootNode = Database.database().reference(fromURL: "https://check-yo-self-18682434.firebaseio.com/")
            let playerNode = rootNode.child("Users/\(user.uid)")
            playerNode.observeSingleEvent(of: .value, with: {
                snapshot in
                if let playerDictionary = snapshot.value as? [String: Any]{
                    self.displayName = playerDictionary["DisplayName"] as! String
                    let cubeColorString = playerDictionary["CubeColor"] as! String
                    self.cubeColor = CubeColor(rawValue: cubeColorString)!
                    // Get gem total from local for now
                    //self.gemTotal = playerDictionary["Gems"] as! Int
                    let ageGroup = playerDictionary["AgeGroup"] as! String
                    self.isAdult = ageGroup == "Adult" ? true : false
                    if let avatarName = playerDictionary["AvatarName"] as? String{
                        /*for avatar in Media.avatarList where avatarName == avatar.name{
                            self.avatar = avatar
                        }*/
                    }
                    completion()
                }else{
                    failure(.data("Empty Dictionary"))
                }
                
            })
        }else{
            failure(.permissions("No current Firebase User"))
        }
    }
    
    //********************************************************************
    // description
    // Description: Output string representation of PlayerData to the console
    //********************************************************************
    override var description: String{
        let nameString = self.displayName
        var descriptionString = "Player Name: \(nameString)\n"
        var gamesPlayed = self.dataArray.count - 1
        if(gamesPlayed < 0){
            gamesPlayed = 0
        }
        descriptionString += "Games Played: \(gamesPlayed)\n"
        return descriptionString
    }
    
    //********************************************************************
    // printAllGames
    // Description: Print all games after of regular print
    //********************************************************************
    func printAllGames(){
        print(self)
        var gameString: String = ""
        if self.dataArray.isEmpty == false{
            gameString += "Profile: \(dataArray[0])\n"
            for i in 1 ..< dataArray.count{
                gameString += "Game #\(i): \(dataArray[i])\n"
            }
            print(gameString)
        }
    }
}
