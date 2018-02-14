//********************************************************************
//  PlayViewController.swift
//  Check Yo Self
//  Created by Phil on 12/1/16
//
//  Description: The game screen where players answer questions
//********************************************************************

import UIKit
import HealthKit
import MapKit
import CoreLocation

class PlayViewController: GeneralViewController{
    var gameQuestions: [Question]?
    var questionsAnswered: Int = 0
    var profileAvatarIndex: Int?
    var score: Int = 0
    lazy var startTime: Date = {
        return Date.init()
    }()
    var creationPhase: CreationPhase = PlayerData.sharedInstance.creationPhase
    
    // Round Data
    var roundStepCount: Int?
    var roundHeartDictionary: [String: Int]?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var phaseImage: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var backDrop: UIImageView!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var cyanButton: UIButton!
    @IBOutlet weak var magentaButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    //********************************************************************
    // Action: choicePressed
    // Description: Add points based on choice and check for end of round
    //********************************************************************
    @IBAction func choicePressed(_ sender: UIButton){
        let currentQuestion = gameQuestions![questionsAnswered]
        let choiceText = sender.currentTitle!
        for i in 0..<6{
            let matchText = currentQuestion.choices[i].text
            if(choiceText == matchText){
                let valueOfChoice = currentQuestion.choices[i].pointValue
                self.score += valueOfChoice
                
                // Check if answer to that question needs to be saved
                if(creationPhase == .none){
                    saveProfileChoice(valueOfChoice: valueOfChoice)
                }
                
                self.questionsAnswered += 1
            }
        }
        if questionsAnswered < (gameQuestions!.count){
            self.setupNewQuestion()
        }else{
            self.endTest()
        }
        
    }
    
    //********************************************************************
    // saveProfileChoice
    // Description: Check if we need to save the answer
    //********************************************************************
    func saveProfileChoice(valueOfChoice: Int){
        // Set up Avatar Male/Female
        if questionsAnswered == 0{
            // Set avatar to freeform until next question
            switch valueOfChoice{
            case -1:
                self.phaseImage.image = #imageLiteral(resourceName: "Freeform1")
                // Set to start index of female avatars
                self.profileAvatarIndex = 0
            case -2:
                // Set to start index of male avatars
                self.phaseImage.image = #imageLiteral(resourceName: "Freeform2")
                self.profileAvatarIndex = 6
            default:
                self.phaseImage.image = #imageLiteral(resourceName: "Freeform3")
            }
            // Set up unique avatar
        }else if questionsAnswered == 1{
            // Get index of array of avatars
            if let genderIndex = self.profileAvatarIndex{
                self.profileAvatarIndex = genderIndex + (valueOfChoice + 2)
                // Set new avatar
                let newAvatar = Media.avatarList[self.profileAvatarIndex!]
                self.phaseImage.image = newAvatar.image
                PlayerData.sharedInstance.avatar = newAvatar
            }
            // Set up background
        }else if questionsAnswered == 2{
            let backdropInt = valueOfChoice + 3
            self.backDrop.image = Media.alertBackdropList[backdropInt]
            //PlayerData.sharedInstance.cubeColor = CubeColor.cubeColorForInt(backdropInt)!
        }else if questionsAnswered == 3{
            switch valueOfChoice{
            case -2,-1,0:
                PlayerData.sharedInstance.isAdult = false
            case 1,2,3:
                PlayerData.sharedInstance.isAdult = true
            default:
                break
            }
        }
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Start either new game or profile questions
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Center all button text on word wrap
        for view in self.view.subviews{
            if let button = view as? UIButton{
                button.titleLabel?.textAlignment = .center
            }
        }
    }
    
    //********************************************************************
    // viewWillAppear
    // Description: Update stats and check for phase change
    //********************************************************************
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.backDrop.image = nil
        checkForPhaseChange()
    }
    
    //********************************************************************
    // checkForPhaseChange
    // Description: Called from viewDidLoad and viewWillAppear to check
    // for new phase
    //********************************************************************
    func checkForPhaseChange(){
        // Check for new phase
        
        if PlayerData.sharedInstance.creationPhase == .none{
            // User is setting up profile
            self.phaseChange()
        }else if PlayerData.sharedInstance.runCheckOnce == true{
            // Check button was pressed on Cube Screen
            self.phaseChange()
        }else if self.creationPhase != PlayerData.sharedInstance.creationPhase{
            // Phase slider was moved
            self.phaseChange()
        }else if self.questionsAnswered == Configuration.questionsPerRound{
            // Old game was finished start a new one
            startNewGame()
        }else if self.questionsAnswered == 0{
            // First game after loading (fixed error 2/8/17
            startNewGame()
        }

    }
    
    //********************************************************************
    // phaseChange
    // Description: User is one to a new phase.Show user alert and start a 
    // new game with questions from the new phase
    //********************************************************************
    func phaseChange(){
        resetButtons()
        // Player taped check on Cube screen
        if PlayerData.sharedInstance.runCheckOnce == true{
            PlayerData.sharedInstance.runCheckOnce = false
            self.creationPhase = .check
            /*self.showConnectionAlert(ConnectionAlert(title: "\(self.creationPhase.rawValue) phase!", message: "Answer these 20 questions & Score JabbRGems", okButtonText: "GO", okButtonCompletion: {
                self.startNewGame()
            }))*/
        // Regular phase change
        }else if PlayerData.sharedInstance.creationPhase == .none{
            /*self.creationPhase = .none
            self.showConnectionAlert(ConnectionAlert(title: "\(self.creationPhase.rawValue) phase!", message: "Answer these 20 questions to customize your profile", okButtonText: "GO", okButtonCompletion: {
                self.startNewGame()
            }))*/
        }else{
            /*self.creationPhase = PlayerData.sharedInstance.creationPhase
            self.showConnectionAlert(ConnectionAlert(title: "\(self.creationPhase.rawValue) phase!", message: "Answer these 20 questions & Score JabbRGgems", okButtonText: "GO", okButtonCompletion: {
                self.startNewGame()
            }))*/
        }
        updateStats()
    }
    
    //********************************************************************
    // startNewGame
    // Description: Grab new questions, reset all counters and start a new
    // game
    //********************************************************************
    func startNewGame(){
        // Catch next interstitial for game over
        if Configuration.showAds == true{
            Chartboost.cacheInterstitial(CBLocationGameOver)
        }
        
        // Store heart data for use when done
        PlayerData.sharedInstance.getStepCountHK(completion: { stepCount in
            self.roundStepCount = stepCount
        }, failure: {_ in 
            print("ERROR: Coud not get step count")
        })
        PlayerData.sharedInstance.getHeartRateFB(completion: { heartDictionary in
            self.roundHeartDictionary = heartDictionary
        }, failure: {_ in 
            print("ERROR: Coud not get heart data")
        })
        self.questionsAnswered = 0
        self.score = 0
        self.startTime = Date.init()
        QuestionStorage.sharedInstance.getQuestionsLocal(amount: Configuration.questionsPerRound, phase: self.creationPhase){newQuestions, error in
            if let error = error{
                switch error{
                case .question:
                    print("QUESTION ERROR: Not enough questions available")
                case .connection:
                    print("CONNECTION ERROR: No connection")
                default:
                    break
                }
                /*self.showConnectionAlert(ConnectionAlert(title: "Try Again", message: "Cannot load \(self.creationPhase.rawValue) phase at this time", okButtonText: "OK", okButtonCompletion: {
                    self.tabBarController?.selectedIndex = 0
                }))*/
                
            }else{
                print("Grabbed \(newQuestions?.count) \(self.creationPhase) Questions")
                self.updateStats()
                self.gameQuestions = newQuestions
                // User is setting up profile
                if self.creationPhase == .none{
                    self.phaseImage.image = #imageLiteral(resourceName: "DefaultUserPic")
                }
                self.setupNewQuestion()
                return
            }
        }
    }
    
    //********************************************************************
    // updateStats
    // Description: Set player score and name labels
    //********************************************************************
    func updateStats(){
        self.usernameLabel.text = PlayerData.sharedInstance.displayName
        self.scoreLabel.text = String(format: "%06d",PlayerData.sharedInstance.gemTotal)
       
        if(self.creationPhase == .none){
            self.phaseImage.image = #imageLiteral(resourceName: "DefaultUserPic")
        }else{
            if self.creationPhase == .check{
                self.phaseImage.image = #imageLiteral(resourceName: "TripleCheck")
            }else{
                self.phaseImage.image = UIImage.init(named: "\(self.creationPhase.rawValue).png")
            }
        }
    }
    
    //********************************************************************
    // resetButtons
    // Description: Set all button text to ???
    //********************************************************************
    func resetButtons(){
        for view in self.view.subviews{
            if let button = view as? UIButton{
                button.titleLabel?.text = "???"
            }
        }
        self.questionLabel.text = "???"
    }
    
    //********************************************************************
    // setupNewQuestion
    // Description: Check if alert is needed and then launch question
    //********************************************************************
    func setupNewQuestion(){
        // Show alerts on 0,5,10,15
        if self.questionsAnswered % 5 == 0{
            let alertIndex = self.questionsAnswered / 5
            let alertMessage = Media.progressAlertMessages[self.creationPhase]![alertIndex]
            /*self.showConnectionAlert(ConnectionAlert(title: "Section \(alertIndex+1)", message: "These 5 questions \(alertMessage)", okButtonText: "GO", okButtonCompletion: {
                self.launchNewQuestion()
            }))*/
        }else{
            launchNewQuestion()
        }
    }
    
    //********************************************************************
    // launchNewQuestion
    // Description: Display next question in the queue
    //********************************************************************
    func launchNewQuestion(){
        let currentQuestion = gameQuestions![questionsAnswered]
        questionLabel.text = "\(self.questionsAnswered + 1). \(currentQuestion.text)"
        redButton.setTitle(currentQuestion.choices[5].text, for: UIControlState.normal)
        greenButton.setTitle(currentQuestion.choices[4].text, for: UIControlState.normal)
        blueButton.setTitle(currentQuestion.choices[3].text, for: UIControlState.normal)
        cyanButton.setTitle(currentQuestion.choices[2].text, for: UIControlState.normal)
        magentaButton.setTitle(currentQuestion.choices[1].text, for: UIControlState.normal)
        yellowButton.setTitle(currentQuestion.choices[0].text, for: UIControlState.normal)
    }
    
    //********************************************************************
    // endTest
    // Description: Display alert that user finished a game and add a DataEntry
    //********************************************************************
    func endTest(){
        PlayerData.sharedInstance.addDataEntry(phase: self.creationPhase, score: self.score, startTime: self.startTime, location: PlayerData.sharedInstance.getLocation(), steps: self.roundStepCount, heartDictionary: self.roundHeartDictionary)
        // Save to firebase after every play and profile change
        PlayerData.sharedInstance.savePlayerFirebase(completion: {
            print("SUCCESS: Player Firebase data saved")
        }, failure: { errorType in
            print("--LOAD PLAYER FIREBASE--")
            switch errorType{
            case .connection(let error):
                print("CONNECTION ERROR: \(error)")
            case .permissions(let errorString):
                print("PERMISSIONS ERROR: \(errorString)")
            case .data(let errorString):
                print("DATA ERROR: \(errorString)")
            default:
                break
            }
        })
        self.score > 0 ? BSGCommon.playSound("HookUp", ofType: "mp3") : BSGCommon.playSound("HookDown", ofType: "mp3")
        var title: String
        var message: String
        var pageIndex: Int
        // User profile complete
        if(creationPhase == .none){
            title = "Profile Complete!"
            message = "Feel free to change your profile at any time"
            // Go to Cube screen
            pageIndex = 0
        }else{
            title = "You scored \(self.score)POINTs!"
            message = "Check Yo STATS & be MINDFUL in all your CollabRjabbRing..."
            // Go to Stats screen
            pageIndex = 3
        }
        /*self.showConnectionAlert(ConnectionAlert(title: title, message: message, okButtonText: "OK", okButtonCompletion: {
                        self.backDrop.image = nil
            self.resetButtons()
            self.updateStats()
            
            // Show interstitial at game over 70%
            if Configuration.showAds == true{
                let showAd = Int(arc4random_uniform(10)) + 1
                if showAd >= 7{
                    Chartboost.showInterstitial(CBLocationGameOver)
                }
            }
            self.setTabsActive(true)
            self.tabBarController?.selectedIndex = pageIndex
        }))*/
    }
    
    //********************************************************************
    // setTabsActive
    // Description: Turn off or on touch on all tabs
    //********************************************************************
    func setTabsActive(_ flag: Bool){
        for i in 0...4{
            let tabBarItem = tabBarController?.tabBar.items?[i]
            tabBarItem?.isEnabled = flag
        }
    }

}
