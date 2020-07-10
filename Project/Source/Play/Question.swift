//
//  Question.swift
//  check-yo-self
//
//  Created by phil on 12/1/16.
//  Copyright © 2016 ThematicsLLC. All rights reserved.
//
//  Update 2/9/18 by phil.
//  Changed to struct and removed NSCoding features.
//

import UIKit

// MARK: - Typealias -

typealias Choice = (text: String, pointValue: Int?, profileValue: String?)

// MARK: - Enumeration -

/// Represents types of questions.
enum QuestionType: String {
    
    case profile, check, brainstorm, develop, align, improve, make
    
    /// Title of the QuestionType beginning with capital letter.
    var displayString: String {
        switch self {
        case .profile: return "Profile"
        case .check: return "Check"
        case .brainstorm: return "Brainstorm"
        case .develop: return "Develop"
        case .align: return "Align"
        case .improve: return "Improve"
        case .make: return "Make"
        }
    }
    /// Description of the purpose of this type of question.
    var description: String {
        switch self {
        case .check: return "Answer these 20Questions when you CHECKIn & Out of every MEETUp in order to Check Yo Self & Score JabbrGems!"
        case .brainstorm: return "PLAY this Phase of 20Questions when you are in the spitballin’, throwin’ it all against the wall, thinkin’ outside the box kind of CollabRation & Score more JabbrGems!"
        case .develop: return "PLAY this Phase of 20Questions when your Team is looking to expand the scope of your Project, enhance your CollabRation & Score more JabbrGems!"
        case .align: return "PLAY this Phase of 20Questions after you define the parameters of your Team’s Project, and put all 6 Players’ Elements into the CUBE & Score more JabbrGems!"
        case .improve: return "PLAY this Phase of 20Questions when you are individually ready to take your CUBE Project to another level and maybe you aren’t sure what steps to take towards Effective CollabRation & Score more JabbrGems!"
        case .make: return "PLAY this Phase of 20Questions when your Team Project is feelin’ good about the data built in your CUBE and looking to EXPORT the Elements of your Project, share your CollabRation with the world & exchange GEMs for ColLAB GEAR!"
        case .profile: return "Answer these questions to deck out your profile yo."
        }
    }
    /// Message displays as intermediary alerts in *QuestionViewController*.
    var progressAlertMessages: [String] {
        
        switch self {
        // Unused. Profile is now on separate screen.
        case .profile: return ["let us know about your personal physical rhythms.", "let us know about your personal physical rhythms.", "let us know about your personal relationship to the sun.", "let us know about your personal physical practices."]
        case .check: return ["explore your condition walking in to the meeting.", "explore your feelings about your creative contribution.", "help you examine your surroundings.", "help you examine your fellow CollabRaters."]
        case .brainstorm: return ["push the boundries of your surroundings.", "push the boundries of your team.", "push the boundries of yourself.", "explore ways to place your BRAINSTORMS into DEVELOPMENT."]
        case .develop: return ["expand the teams' ideas.", "expand your ideas.", "stretch the definition and boundries of the project.", "explore ways to develop your product and to get you ready to ALLIGN."]
        case .align: return ["group the teams' ideas into buckets.", "prioritize the buckets using your stated reasoning.", "stretch the definition and boundries of the project.", "explore ways to allign your game and get you closer to IMPROVING."]
        case .improve: return ["explore ways to improve your ultimate product.", "explore ways to improve your progress towards the MAKING.", "explore ways to improve your self worth.", "explore ways to improve your team's confidence too."]
        case .make: return [ "help you assess your product.", "help CollabRjabbR assess your product.", "relate your product to your personal stated goal.", "relate your goal to your team's stated goal."]
        }
    }
    
    /// Image representing question type.
    var image: UIImage? {
        switch self {
        case .profile: return nil
        case .check: return #imageLiteral(resourceName: "check-icon")
        case .brainstorm: return #imageLiteral(resourceName: "brainstorm-icon")
        case .develop: return #imageLiteral(resourceName: "develop-icon")
        case .align: return #imageLiteral(resourceName: "align-icon")
        case .improve: return #imageLiteral(resourceName: "improve-icon")
        case .make: return #imageLiteral(resourceName: "make-icon")
        }
    }
    
    /// Value of parent path on database.
    var databaseNode: String { return rawValue.lowercased() }
    
    /// Array of all question types.
    static var all: [QuestionType] = [profile, check, brainstorm, develop, align, improve, make]
}

// MARK: - Struct -

/// Model for a question with 6 choices.
struct Question {
    
    // MARK: - Public Members -
    
    let text: String
    let id: String
    let type: QuestionType
    /// Affects user experience based on answer.
    var choices: [Choice] = []
    
    // MARK: - Initializers -
    
    init(withText text: String, id: String, type: QuestionType, choices: [Choice]) {
        self.text = text
        self.id = id
        self.type = type
        self.choices = choices
    }
    
    init(withText text: String, id: String, type: QuestionType, _ choice3: String, _ choice2: String, _ choice1: String, _ choice0: String, _ choiceNeg1: String, _ choiceNeg2: String){
        
        let choices: [Choice] = [(choice3,3, nil), (choice2,2, nil), (choice1,1, nil), (choice0,0, nil), (choiceNeg1,-1, nil), (choiceNeg2,-2, nil)]
        self.init(withText: text, id: id, type: type, choices: choices)
    }
    
    init?(withSnapshot snapshot: [String: Any], type questionType: QuestionType) {
        
        guard let questionText = snapshot["title"] as? String, let questionID = snapshot["id"] as? String, let choiceSnapshot = snapshot["choices"] as? [[String: Any]] else { return nil }
        
        var choices: [Choice] = []
        for choice in choiceSnapshot {
            print("THIS CHOCE \(questionText)\(choice)")
            guard let text = choice["choiceText"] as? String else { return nil }
            let pointValueString = choice["choiceValue"] as? NSNumber
//            let pointValue = pointValueString != nil ? Int(pointValueString!) : 0
            let pointValue = pointValueString
            let profileValue = choice["profile-value"] as? String
            
            choices.append((text: text, pointValue: pointValue?.intValue, profileValue: profileValue))
        }
        
        self.text = questionText
        self.id = questionID
        self.type = questionType
        self.choices = choices
        
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Randomizes position of choices in array.
    ///
    mutating func randomize(){
        
        var randomChoices: [Choice] = []
        
        while choices.count != 0{
            let randomIndex = Int(arc4random_uniform(UInt32(choices.count)))
            randomChoices.append(choices[randomIndex])
            choices.remove(at: randomIndex)
        }
        
        choices = randomChoices
    }
    
    ///
    /// Turns question into snapshot to be saved to database.
    ///
    /// - returns: Dictionary representation of question.
    ///
    func toSnapshot() -> [String: Any] {
        
        var allChoicesSnapshot: [[String: String]] = []
        
        for choice in choices {
            
            var choiceSnapshot: [String: String] = ["choiceText": choice.text]

            if let pointValue = choice.pointValue {
                choiceSnapshot["choiceValue"] = String(pointValue)
            }
            
            if let profileValue = choice.profileValue {
                choiceSnapshot["profile-value"] = profileValue
            }
            
            allChoicesSnapshot.append(choiceSnapshot)
        }
        
        return ["text": text, "id": id, "choices": allChoicesSnapshot]
    }
}
