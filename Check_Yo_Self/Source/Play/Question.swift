//
//  Question.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 12/1/16.
//  Copyright © 2016 ThematicsLLC. All rights reserved.
//
//  Update 2/9/18 by Phil Rattazzi.
//  Changed to struct and removed NSCoding features.
//

import UIKit
import FirebaseDatabase

typealias Choice = (text: String, pointValue: Int)

/// Represents types of questions.
enum QuestionType: String {
    case check = "Check"
    case brainstorm = "Brainstorm"
    case develop = "Develop"
    case align = "Align"
    case improve = "Improve"
    case make = "Make"
    case profile = "Profile"
    
    var databaseNode: String { return rawValue.lowercased() }
}

/// Model for a question with 6 choices.
struct Question {
    
    // MARK: - Public Members -
    
    let text: String
    let id: String
    let type: QuestionType
    var choices: [Choice] = []
    
    // MARK: - Initializers -
    
    init(withText text: String, id: String, type: QuestionType, choices: [Choice]) {
        self.text = text
        self.id = id
        self.type = type
        self.choices = choices
    }
    
    init(withText text: String, id: String, type: QuestionType, _ choice3: String, _ choice2: String, _ choice1: String, _ choice0: String, _ choiceNeg1: String, _ choiceNeg2: String){
        
        let choices = [(choice3,3), (choice2,2), (choice1,1), (choice0,0), (choiceNeg1,-1), (choiceNeg2,-2)]
        self.init(withText: text, id: id, type: type, choices: choices)
    }
    
    init?(withSnapshot snapshot: [String: Any], type questionType: QuestionType) {
        
        guard let questionText = snapshot["text"] as? String, let questionID = snapshot["id"] as? String, let choiceSnapshot = snapshot["choices"] as? [[String: Any]] else { return nil }
        
        var choices: [Choice] = []
        for choice in choiceSnapshot {
            guard let text = choice["text"] as? String else { return nil }
            let pointValue = choice["point-value"] as? Int ?? 0
            
            choices.append((text: text, pointValue: pointValue))
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
        
        var randomChoices: [(text: String, pointValue: Int)] = []
        
        while choices.count != 0{
            let randomIndex = Int(arc4random_uniform(UInt32(choices.count)))
            randomChoices.append(choices[randomIndex])
            choices.remove(at: randomIndex)
        }
        
        choices = randomChoices
    }
}
