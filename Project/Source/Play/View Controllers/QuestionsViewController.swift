//
//  QuestionsViewController.swift
//  check-yo-self
//
//  Created by phil on 12/1/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Screen where player is asked a questions and presented with 6 colored choices.
final class QuestionsViewController: SkinnedViewController {
    
    // MARK: - Public Members -
    
    /// If true, a check game will be played instead of current question type set in *mapViewController*.
    var isCheckYoSelfGame = false
    var isProfileGame = false
    
    // MARK: - Private Members -
    
    private var questions: [Question] = []
    private var questionsAnswered: Int = 0
    private var score: Int = 0
    private var startTime: Date?
    
    /// The type of questions being displayed.
    private var questionType: QuestionType {
        
        if isCheckYoSelfGame { return .check }
        if isProfileGame { return .profile }
        
        guard let typeKey = DataManager.shared.getLocalValue(for: .questionType), let type = QuestionType(rawValue: typeKey) else { return .brainstorm }
        return type
    }
    
    /// The currently displaying question.
    private var currentQuestion: Question! { didSet {
        
        questionLabel.text = "\(questionsAnswered + 1). \(currentQuestion.text)"
        
        for (index, choice) in currentQuestion.choices.enumerated() {
            allButtons[index].setTitle(choice.text, for: .normal)
        }
        
        SpeechManager.shared.speak(currentQuestion.text)
    }}
    
    /// Array of all choice buttons.
//    private var allButtons: [UIButton] { return [redButton, greenButton, blueButton, cyanButton, magentaButton, yellowButton] }
    private var allButtons: [UIButton] { return [blueButton, cyanButton, magentaButton, yellowButton, greenButton, redButton] }
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var gemsLabel: UILabel!
    @IBOutlet private weak var centerImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var redButton: UIButton!
    @IBOutlet private weak var greenButton: UIButton!
    @IBOutlet private weak var blueButton: UIButton!
    @IBOutlet private weak var cyanButton: UIButton!
    @IBOutlet private weak var magentaButton: UIButton!
    @IBOutlet private weak var yellowButton: UIButton!
    
    private var selectedColor: CubeColor!
    private var selectedAgeGroup: AgeGroup!
    private var selectedGenre: CollabrationGenre!
    private var selectedIdentity: Identity!
    
    // MARK: - Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        print(isProfileGame)
        if isProfileGame{
            getProfileQuestions()
        } else {
            startQuestions()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.isCheckYoSelfGame = false
        self.isProfileGame = false
    }
    
    override func style() {
        
        super.style()
        
        nameLabel.text = User.current.displayName
        nameLabel.font = UIFont(name: Font.main, size: Font.mediumSize)
        nameLabel.textColor = User.current.ageGroup.textColor
        
        gemsLabel.font = UIFont(name: Font.heavy, size: Font.largeSize)
        gemsLabel.textColor = User.current.favoriteColor.uiColor
        
        questionLabel.font = UIFont(name: Font.main, size: Font.mediumSize)
        questionLabel.textColor = User.current.ageGroup.textColor
        
        for button in allButtons {
            button.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.numberOfLines = 2
            button.titleEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        }
    }
    
    ///
    /// Begin presenting questions to user.
    ///
    private func startQuestions() {
        
        reset()
        showProgressHUD()
        
        QuestionService.get(GameConfiguration.questionsPerRound, questionsOfType: questionType, success: { questions in
            
            self.hideProgressHUD()
            
            self.update()
            self.questions = questions
            
            self.showAlert(BSGCustomAlert(message: "Answer these 20 questions and score JabbRGems.", options: [(text: "Go", handler: {
                
                if !User.current.hasProfileInfo {
                    self.tabBarController?.selectedIndex = 0
                } else {
                    /// Ask user before leaving mid-game.
                    (self.tabBarController as? CustomTabBar)?.shouldPromptForTabSwitch = true
                    
                    // Catch next interstitial for game over.
                    if GameConfiguration.adFrequency > 0 {
//                        Chartboost.cacheInterstitial(CBLocationGameOver)
//                        let ccache = CHBInterstitial.init(location: CBLocationGameOver, delegate: nil)
//                        ccache.cache()
                        ChartBoostManager.sharedInstance.cacheInterstitial(location: CBLocationGameOver)
                    }
                    
                    self.questionsAnswered = 0
                    self.score = 0
                    self.startTime = Date.init()
                    
                    self.presentQuestion()
                }
            }), (text: "Not Now", handler: {
                self.tabBarController?.selectedIndex = 0
            })]))
            
        }, failure: { error in
            self.handle(error)
        })
    }
    
    private func getProfileQuestions(){
        reset()
        showProgressHUD()
        
        QuestionService.getQuestions(ofType: .profile, success: { questions in
            
            self.hideProgressHUD()
            
            self.update()
            self.questions = questions
            
            self.showAlert(BSGCustomAlert(message: "Answer these 20 questions to customize your profile.", options: [(text: "Go", handler: {
                
                /// Ask user before leaving mid-game.
                (self.tabBarController as? CustomTabBar)?.shouldPromptForTabSwitch = true
                
                // Catch next interstitial for game over.
                if GameConfiguration.adFrequency > 0 {
//                    Chartboost.cacheInterstitial(CBLocationGameOver)
//                    let ccache = CHBInterstitial.init(location: CBLocationGameOver, delegate: nil)
//                    ccache.cache()
                    ChartBoostManager.sharedInstance.cacheInterstitial(location: CBLocationGameOver)
                }
                
                self.questionsAnswered = 0
                self.score = 0
                self.startTime = Date.init()
                
                self.presentQuestion()
            }), (text: "Not Now", handler: {
                self.tabBarController?.selectedIndex = 0
            })]))
            
        }, failure: { errorString in
            self.handle(errorString)
        })
    }
    
    ///
    /// Resets things when beginning new question round.
    ///
    private func reset(){
        
        gemsLabel.text = "---"
        centerImage.image = nil
        questionLabel.text = "---"
        
        for button in allButtons {
            button.titleLabel?.text = "---"
        }
    }
    
    ///
    /// Updates that need to happen each time game is started.
    ///
    private func update() {
        
        gemsLabel.text = String(User.current.gems)
        centerImage.image = questionType.image
    }
    
    ///
    /// Display next question.
    ///
    /// This method shows an intermediary alert if needed (on questions 0,5,10,15).
    ///
    private func presentQuestion() {
        
        let nextQuestion = questions[questionsAnswered]
        
        if self.questionsAnswered % 5 == 0
        {
            
            let index = self.questionsAnswered / 5
            let purpose = questionType.progressAlertMessages[index]
            self.showAlert(BSGCustomAlert(message: "These questions \(purpose)", options: [(text: "Go", handler: {
                self.currentQuestion = nextQuestion
            })]))
        }else{
            currentQuestion = nextQuestion
        }
    }
    
    ///
    /// Handler for user selecting a choice.
    ///
    /// - parameter selectedChoiceText: Text of the choice selected.
    ///
    private func handleChoice(withText selectedChoiceText: String) {
        
        for choice in currentQuestion.choices {
            if choice.text == selectedChoiceText {
                if !isProfileGame {
                    if let pointValue = choice.pointValue { score += pointValue }
                } else {
                    //handles choice for Profile Questions
                    switch currentQuestion.id {
                    case "PQ-000003": selectedColor = CubeColor.color(fromString: choice.text.lowercased())
                    case "PQ-000004": selectedAgeGroup = AgeGroup.ageGroup(fromString: choice.text.lowercased())
                    case "PQ-000002": selectedGenre = CollabrationGenre.genre(fromString: choice.text.lowercased())
                    case "PQ-000001": selectedIdentity = Identity.identity(fromString: choice.text.lowercased())
                    default: break
                    }
                }
                questionsAnswered += 1
                
                print("Questions \(questions.count) ANS: \(questionsAnswered)")
            }
        }
        
        guard questionsAnswered < (questions.count) else {
            finish()
            return
        }
        
        presentQuestion()
    }
    
    ///
    /// Cleanup for game including adding a record to database, and possibly showing ad.
    ///
    private func finish(){
        
        if !isProfileGame {
            score > 0 ? BSGCommon.playSound("hook-up", ofType: "mp3") : BSGCommon.playSound("hook-down", ofType: "mp3")
            
            guard let startTime = startTime else { return }
            showProgressHUD()
            
            DataManager.shared.addGameRecord(ofType: questionType, score: score, startTime: startTime) {
                
                (self.tabBarController as? CustomTabBar)?.shouldPromptForTabSwitch = false
                self.hideProgressHUD()
                
                self.isCheckYoSelfGame = false
                
                let alert = BSGCustomAlert(message: "You scored \(self.score)POINTs!", options: [(text: "Word", handler: {
                    self.showStats()
                })])
                self.showAlert(alert)
            }
        } else {
            //finish Profile Questions
            showProgressHUD()
            
            User.current.favoriteColor = selectedColor
            User.current.ageGroup = selectedAgeGroup
            User.current.favoriteGenre = selectedGenre
            User.current.identity = selectedIdentity
            
            print(User.current.toSnapshot())
            
            LoginFlowManager.shared.updateAccount(for: User.current, success: {
                self.hideProgressHUD()
                NotificationManager.shared.postNotification(ofType: .profileUpdated)
                User.current.hasProfileInfo = true
                
                self.isProfileGame = false
                
                let alert = BSGCustomAlert(message: "Profile Updated", options: [(text: "Okay", handler: {
                    self.tabBarController?.selectedIndex = 0
                })])
                self.showAlert(alert)
                
            }, failure: { errorString in
                self.handle(errorString)
            })
        }
    }
    
    ///
    /// Brings user to stats screen with optional ad.
    ///
    /// An ad is shown with a frequency specified in the configuration in the database.
    ///
    private func showStats() {
        
        var shouldShowAd: Bool!
        if GameConfiguration.adFrequency > 0 && GameConfiguration.adFrequency <= 100 {
            
            let index = Int(arc4random_uniform(100))
            shouldShowAd = index > GameConfiguration.adFrequency
        }
        
        guard let statsNav = tabBarController?.viewControllers?[2] as? UINavigationController, let statsViewController = statsNav.viewControllers[0] as? GameRecordsViewController else { return }
        statsViewController.shouldShowAd = shouldShowAd
        tabBarController?.selectedIndex = 2
    }
}

// MARK: - Extension: Actions -

extension QuestionsViewController {
    
    @IBAction func choicePressed(_ sender: UIButton){
        guard let selectedChoiceText = sender.currentTitle else { return }
        handleChoice(withText: selectedChoiceText)
    }
}
