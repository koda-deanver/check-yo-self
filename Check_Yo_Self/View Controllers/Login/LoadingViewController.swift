//********************************************************************
//  LoginViewController.swift
//  Check Yo Self
//  Created by Phil on 1/19/17
//
//  Description: Serve as placeholder while loading questions
//********************************************************************

import UIKit
import Firebase

class LoadingViewController: GeneralViewController {
    @IBOutlet weak var loadingGif: UIImageView!
    //********************************************************************
    // viewDidLoad
    // Description: Set up gif and get questions from CloudKit
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animation and sound
        self.loadingGif.image = UIImage.gifImageWithName(name: "Noodle")
        BSGCommon.playSound("CheckVocals", ofType: "mp3")
        
        // Authorize firebase
        Auth.auth().signInAnonymously(){
            user, error in
            if let error = error{
                print("FIREBASE ERROR: \(error)")
            }else{
                print(user!.uid)
            }
        }
        
        // Load FB Data
        PlayerData.sharedInstance.loadPlayerFB(completion: {
            print("SUCCESS: Player FB data loaded")
            PlayerData.sharedInstance.loadFriendsFB(completion: {
                print("SUCCESS: Player FB friends Loaded")
            }, failure: { errorType in
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
        }, failure: { errorType in
            print("--LOAD PLAYER FB--")
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

        // Check for new user
        if(PlayerData.sharedInstance.creationPhase == .none){
            // Must succeed to play
            setupQuestions()
        }else{
            // Not new. Load data from firebase
            PlayerData.sharedInstance.loadPlayerFirebase(completion: {
                print("SUCCESS: Player Firebase data loaded")
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
            // Can succeed or fail
            updateQuestions()
        }
    }
    
    //********************************************************************
    // setupQuestions
    // Description: Get questions from Cloudkit if new user
    //********************************************************************
    func setupQuestions(){
        QuestionStorage.sharedInstance.loadAllPhasesFirebase(completion : {
            // Success Handler
            QuestionStorage.sharedInstance.questionBank = QuestionStorage.sharedInstance.tempQuestionBank
            print("SUCCESS: Questions loaded from Firebase")
            if self.enoughQuestions(){
                BSGCommon.stopSound()
                QuestionStorage.sharedInstance.archiveQuestions()
                DispatchQueue.main.async {
                    let newView: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginScene")
                    self.present(newView, animated: true, completion: nil)
                }
            }else{
                self.showConnectionAlert(ConnectionAlert(title: "Not Enough Questions", message: "The developers are in the process of creating new content", okButtonText: "OK"){
                    // Terminate App
                    exit(0)
                })
            }
        }){
            // Failure Handler
            self.showConnectionAlert(ConnectionAlert(title: "Failed to download content", message: "Check your internet connection and try again", okButtonText: "OK"){
                exit(0)
            })
        }
    }
    
    //********************************************************************
    // updateQuestions
    // Description: Attempt to update with new questions on each launch
    //********************************************************************
    func updateQuestions(){
        QuestionStorage.sharedInstance.loadAllPhasesFirebase(completion : {
            // Success Handler
            QuestionStorage.sharedInstance.questionBank = QuestionStorage.sharedInstance.tempQuestionBank
            print("SUCCESS: Questions loaded from Firebase")
            if self.enoughQuestions(){
                QuestionStorage.sharedInstance.archiveQuestions()
                self.launchGame(onTab: 0)
            }else{
                self.showConnectionAlert(ConnectionAlert(title: "Not Enough Questions", message: "The developers are in the process of creating new content", okButtonText: "OK"){
                    // Terminate App
                    exit(0)
                })
            }
        }){
            // Failure Handler
            self.showConnectionAlert(ConnectionAlert(title: "Could not sync new questions", message: "Using saved questions", okButtonText: "OK"){
                self.launchGame(onTab: 0)
            })
        }
    }
    
    //********************************************************************
    // enoughQuestions
    // Description: Check if each phase has enough questions to play
    //********************************************************************
    func enoughQuestions() -> Bool{
        for (_,questionArray) in QuestionStorage.sharedInstance.questionBank{
            if questionArray.count < Configuration.questionsPerRound {
                return false
            }
        }
        return true
    }
    
    //********************************************************************
    // launchGame
    // Description: Start game on specified tab
    //********************************************************************
    func launchGame(onTab tab: Int){
        BSGCommon.stopSound()
        // Go to Menu
        DispatchQueue.main.async {
            let newView: UITabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarScene") as! UITabBarController
            newView.selectedIndex = tab
            self.present(newView, animated: true, completion: nil)
        }
    }
}
