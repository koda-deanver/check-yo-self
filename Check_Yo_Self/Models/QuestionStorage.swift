//********************************************************************
//  QuestionStorage.swift
//  Check Yo Self
//  Created by Phil on 12/1/16
//
//  Description: Used to temporarily store questions until CloudKit is used
//  Update 1/18/17: Deleted hard coded question array and added methods to
//  grab questions from Cloudkit
//********************************************************************

import UIKit
import CloudKit
import Firebase

class QuestionStorage: NSObject, NSCoding {
    static var sharedInstance = QuestionStorage()
    var questionBank: [String: [QuestionObject]] = [:]
    var tempQuestionBank: [String: [QuestionObject]] = [:]
    let container = CKContainer.default()
    // Keep track of successful cloudKit grabs
    var banksFilled = 0
    var loadingFailed = false
    
    //********************************************************************
    // Designated Initializer
    // Description: Always called
    //********************************************************************
    private init(questionBank: [String: [QuestionObject]]){
        self.questionBank = questionBank
    }
    
    //********************************************************************
    // Convenience Initializer
    // Description: Called to decide whether to get new questions
    //********************************************************************
    private override convenience init(){
        
        // Load questions
        if let savedQuestionData = UserDefaults.standard.object(forKey: "questionArchive") as! Data?{
            let savedQuestions = NSKeyedUnarchiver.unarchiveObject(with: savedQuestionData) as! QuestionStorage
            self.init(questionBank: savedQuestions.questionBank)
            print("QUESTIONS LOADED FROM DISK")
        }else{
        // Get from cloudkit
            self.init(questionBank: [:])
            print("NO SAVED QUESTIONS")
        }
    }
    
    //********************************************************************
    // Required Convenience Initializer
    // Description: Required to initialize from archived object
    //********************************************************************
    convenience required init?(coder aDecoder: NSCoder) {
        let questionBank = aDecoder.decodeObject(forKey: "questionBank") as! [String: [QuestionObject]]
        self.init(questionBank: questionBank)
    }
    
    //********************************************************************
    // encode
    // Description: Required to archive object
    //********************************************************************
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.questionBank, forKey:"questionBank")
    }
    
    //********************************************************************
    // getQuestionsLocal
    // Description: Retrieve a specified number of questions from any phase
    // for use in the game
    //********************************************************************
    func getQuestionsLocal(amount: Int, phase: CreationPhase, completion: @escaping ([QuestionObject]?, ErrorType?) -> Void){
        // Questions exist
        if var questionsForPhase = self.questionBank[phase.rawValue]{
            // Not enough questions
            guard questionsForPhase.count >= amount else{
                completion(nil, ErrorType.question(""))
                return
            }
            // Done if getting profile questions
            if phase == .none{
                var chosenQuestions: [QuestionObject] = []
                for i in 0 ..< amount{
                    let newQuestion: QuestionObject = questionsForPhase[i]
                    chosenQuestions.append(newQuestion)
                }
                // Display questions in set order
                chosenQuestions.sort{
                    $0.questionID < $1.questionID
                }
                print(chosenQuestions)
                completion(chosenQuestions, nil)
            // Randomize order for all other phases
            }else{
                var chosenQuestions: [QuestionObject] = []
                for _ in 0 ..< amount{
                    let choice = Int(arc4random_uniform(UInt32(questionsForPhase.count)))
                    let newQuestion: QuestionObject = questionsForPhase[choice]
                    newQuestion.randomize()
                    chosenQuestions.append(newQuestion)
                    questionsForPhase.remove(at: choice)
                }
                completion(chosenQuestions, nil)
            }
        }else{
            // Something went wrong
            completion(nil, ErrorType.question(""))
        }
        
    }
    
    
    //********************************************************************
    // loadPhaseFirebase
    // Description: Load single phase with questions from Firebase. Replaces
    // loadPhaseCK 3/8/17
    //********************************************************************
    func loadPhaseFirebase(phase: CreationPhase, completion: @escaping () -> Void, failure: @escaping () -> Void){
        
        let rootNode = Database.database().reference(fromURL: "https://check-yo-self-18682434.firebaseio.com/")
        let questionCategoryNode = rootNode.child("Questions/\(phase.rawValue)Question")
        
        questionCategoryNode.observeSingleEvent(of: .value, with: {
            snapshot in
            if let firebaseQuestions = snapshot.value as? [AnyObject]{
                var phaseQuestions: [QuestionObject] = []
                for questionRecord in firebaseQuestions{
                    let questionID = questionRecord["id"] as? String
                    let questionTitle = questionRecord["title"] as? String
                    let choices = questionRecord["choices"] as? [AnyObject]
                    if let questionID = questionID, let questionTitle = questionTitle, let choices = choices{
                        if  let choice0 = choices[0]["choiceText"] as? String,
                            let choice1 = choices[1]["choiceText"] as? String,
                            let choice2 = choices[2]["choiceText"] as? String,
                            let choice3 = choices[3]["choiceText"] as? String,
                            let choiceNeg1 = choices[4]["choiceText"] as? String,
                            let choiceNeg2 = choices[5]["choiceText"] as? String{
                            // Following same init order 3,2,1,0,-1,-2
                            let newQuestion = (QuestionObject(phase, questionID, questionTitle, choice3, choice2, choice1, choice0, choiceNeg1, choiceNeg2))
                            phaseQuestions.append(newQuestion)
                        }else{
                            print("ERROR: \(questionID)")
                        }
                    }
                }// Question Loop
                
                self.tempQuestionBank[phase.rawValue] = phaseQuestions
                print("\(phaseQuestions.count) \(phase.rawValue) Loaded")
                self.banksFilled += 1
                // Check if all phases were loaded successfully
                if self.banksFilled == VALID_PHASES + 1{
                    self.banksFilled = 0
                    completion()
                }
            }else{
                // Error
                if self.loadingFailed == false{
                    self.loadingFailed = true
                    self.banksFilled = 0
                    print("ERROR: \(phase.rawValue)")
                    failure()
                }

            }
        })
    }
    
    //********************************************************************
    // loadAllPhasesFirebase
    // Description: Load each phase individually checking for error.
    //********************************************************************
    func loadAllPhasesFirebase(completion: @escaping () -> Void, failure: @escaping () -> Void){
        loadPhaseFirebase(phase: .none, completion: completion, failure: failure)
        loadPhaseFirebase(phase: .check, completion: completion, failure: failure)
        loadPhaseFirebase(phase: .brainstorm, completion: completion, failure: failure)
        loadPhaseFirebase(phase: .align, completion: completion, failure: failure)
        loadPhaseFirebase(phase: .develop, completion: completion, failure: failure)
        loadPhaseFirebase(phase: .improve, completion: completion, failure: failure)
        loadPhaseFirebase(phase: .make, completion: completion, failure: failure)
    }
    
    //********************************************************************
    // archiveQuestions
    // Description: Save player to user defaults
    //********************************************************************
    func archiveQuestions(){
        let questionArchive = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(questionArchive, forKey: "questionArchive")
        print("QUESTIONS ARCHIVED")
    }
    
    //********************************************************************
    // description
    // Description: Output string representation of QuestionObject to
    // the console
    //********************************************************************
    override var description: String{
        var descriptionString = "QUESTION BANK\n"
        for (key, questions) in self.questionBank{
            descriptionString += ("\(key): \(questions.count)\n")
        }
        return descriptionString
    }
    
    //********************************************************************
    // loadPhaseCK
    // Description: Load single phase with questions from CK
    //********************************************************************
    /*func loadPhaseCK(phase: CreationPhase, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let recordType = "\(phase.rawValue)Question"
        let phaseQuery = CKQuery(recordType: recordType, predicate: predicate)
        
        publicDatabase.perform(phaseQuery, inZoneWith: nil){
            records, error in
            if error != nil{
                if self.loadingFailed == false{
                    self.loadingFailed = true
                    self.banksFilled = 0
                    print("\(recordType) Failed")
                    failure()
                }
            }else{
                var phaseQuestions: [QuestionObject] = []
                for questionRecord in records!{
                    let questionID = questionRecord.recordID.recordName
                    print(questionID)
                    let questionTitle = questionRecord.object(forKey: "Title") as? String
                    let choice3 = questionRecord.object(forKey: "Choice3") as? String
                    let choice2 = questionRecord.object(forKey: "Choice2") as? String
                    let choice1 = questionRecord.object(forKey: "Choice1") as? String
                    let choice0 = questionRecord.object(forKey: "Choice0") as? String
                    let choiceNeg1 = questionRecord.object(forKey: "ChoiceNeg1") as? String
                    let choiceNeg2 = questionRecord.object(forKey: "ChoiceNeg2") as? String
                    if let questionTitle = questionTitle, let choice3 = choice3, let choice2 = choice2, let choice1 = choice1, let choice0 = choice0, let choiceNeg1 = choiceNeg1, let choiceNeg2 = choiceNeg2{
                        let newQuestion = (QuestionObject(phase, questionID, questionTitle, choice3, choice2, choice1, choice0, choiceNeg1, choiceNeg2))
                        phaseQuestions.append(newQuestion)
                    }else{
                        // Qustion fields were missing
                        print("Problem with question \(questionID)")
                    }
                    
                }
                self.tempQuestionBank[phase.rawValue] = phaseQuestions
                
                print("\(phaseQuestions.count) \(recordType) Loaded")
                self.banksFilled += 1
                // Check if all phases were loaded successfully
                if self.banksFilled == VALID_PHASES + 1{
                    self.banksFilled = 0
                    completion()
                }
            }
        }
    }*/
}
