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
                if Configuration.adFrequency > 0 {
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
                if let pointValue = choice.pointValue { score += pointValue }
                questionsAnswered += 1
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
        
        score > 0 ? BSGCommon.playSound("HookUp", ofType: "mp3") : BSGCommon.playSound("HookDown", ofType: "mp3")
        
        guard let startTime = startTime else { return }
        
        DataManager.shared.addGameRecord(ofType: questionType, score: score, startTime: startTime) {
            
            let alert = BSGCustomAlert(message: "You scored \(self.score)POINTs!", options: [(text: "Word", handler: {
                self.showStats()
            })])
            self.showAlert(alert)
        }
    }
    
    ///
    /// Brings user to stats screen with optional ad.
    ///
    /// An ad is shown with a frequency specified in the configuration in the database.
    ///
    private func showStats() {
        
        var shouldShowAd: Bool!
        if Configuration.adFrequency > 0 && Configuration.adFrequency <= 100 {
            
            let index = Int(arc4random_uniform(100))
            shouldShowAd = index > Configuration.adFrequency
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
