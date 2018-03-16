//
//  QuestionsViewController.swift
//  check-yo-self
//
//  Created by Phil on 12/1/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Screen where player is asked a questions and presented with 6 colored choices.
final class QuestionsViewController: SkinnedViewController {
    
    // MARK: - Private Members -
    
    private var questions: [Question] = []
    private var questionsAnswered: Int = 0
    private var score: Int = 0
    private var startTime: Date?
    
    /// The type of questions being displayed.
    private var questionType: QuestionType {
        guard let typeKey = DataManager.shared.getLocalValue(for: .questionType), let type = QuestionType(rawValue: typeKey) else { return .brainstorm }
        return type
    }
    
    /// The currently displaying question.
    private var currentQuestion: Question! { didSet {
        
        questionLabel.text = "\(questionsAnswered + 1). \(currentQuestion.text)"
        
        for (index, choice) in currentQuestion.choices.enumerated() {
            allButtons[index].setTitle(choice.text, for: .normal)
        }
        
        SpeechController.speak(currentQuestion.text)
    }}
    
    /// Array of all choice buttons.
    private var allButtons: [UIButton] { return [redButton, greenButton, blueButton, cyanButton, magentaButton, yellowButton] }
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var phaseImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var backDrop: UIImageView!
    
    @IBOutlet private weak var redButton: UIButton!
    @IBOutlet private weak var greenButton: UIButton!
    @IBOutlet private weak var blueButton: UIButton!
    @IBOutlet private weak var cyanButton: UIButton!
    @IBOutlet private weak var magentaButton: UIButton!
    @IBOutlet private weak var yellowButton: UIButton!
    
    // MARK: - Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        startQuestions()
    }
    
    override func style() {
        
        super.style()
        
        usernameLabel.text = User.current.username
        usernameLabel.font = UIFont(name: Font.main, size: Font.largeSize)
        
        scoreLabel.text = String(User.current.gems)
        scoreLabel.font = UIFont(name: Font.pure, size: Font.largeSize)
        
        phaseImage.image = questionType.image
        
        for button in allButtons {
            button.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
        }
    }
    
    ///
    /// Begin presenting questions to user.
    ///
    private func startQuestions() {
        
        reset()
        showProgressHUD()
        
        QuestionService.get(Configuration.questionsPerRound, questionsOfType: questionType, success: { questions in
            
            self.hideProgressHUD()
            
            self.questions = questions
            
            self.showAlert(BSGCustomAlert(message: "Answer these 20 questions and score JabbRGems.", options: [(text: "Go", handler: {
                
                // Catch next interstitial for game over.
                if Configuration.showAds == true{
                    Chartboost.cacheInterstitial(CBLocationGameOver)
                }
                
                self.questionsAnswered = 0
                self.score = 0
                self.startTime = Date.init()
                
                self.presentQuestion()
            })]))
            
        }, failure: { error in
            self.handle(error)
        })
    }
    
    ///
    /// Resets things when beginning new question round.
    ///
    private func reset(){
        
        self.questionLabel.text = "???"
        
        for button in allButtons {
            button.titleLabel?.text = "???"
        }
    }
    
    ///
    /// Display next question.
    ///
    /// This method shows an intermediary alert if needed (on questions 0,5,10,15).
    ///
    private func presentQuestion() {
        
        let nextQuestion = questions[questionsAnswered]
        
        if self.questionsAnswered % 5 == 0{
            let index = self.questionsAnswered / 5
            let message = questionType.progressAlertMessages[index]
            self.showAlert(BSGCustomAlert(message: message, options: [(text: "Go", handler: {
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
                score += choice.pointValue
                questionsAnswered += 1
            }
        }
        
        guard questionsAnswered < (questions.count) else {
            endTest()
            return
        }
        
        presentQuestion()
    }
    
    ///
    ///
    ///
    private func endTest(){
        print("FUCK YO")
        /*PlayerData.sharedInstance.addDataEntry(phase: self.creationPhase, score: self.score, startTime: self.startTime, location: PlayerData.sharedInstance.getLocation(), steps: self.roundStepCount, heartDictionary: self.roundHeartDictionary)
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
        }))*/*/
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

// MARK: - Extension: Actions -

extension QuestionsViewController {
    
    @IBAction func choicePressed(_ sender: UIButton){
        guard let selectedChoiceText = sender.currentTitle else { return }
        handleChoice(withText: selectedChoiceText)
    }
}
