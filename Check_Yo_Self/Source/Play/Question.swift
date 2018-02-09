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

/// Model for a question with 6 choices.
struct Question {
    
    // MARK: - Public Members -
    
    let text: String
    let id: String
    let type: CreationPhase
    var choices: [(text: String, pointValue: Int)] = []
    
    // MARK: - Initializers -
    
    init(withText text: String, id: String, type: CreationPhase, choices: [(text: String, pointValue: Int)]) {
        self.text = text
        self.id = id
        self.type = type
        self.choices = choices
    }
    
    init(withText text: String, id: String, type: CreationPhase, _ choice3: String, _ choice2: String, _ choice1: String, _ choice0: String, _ choiceNeg1: String, _ choiceNeg2: String){
        
        let choices = [(choice3,3), (choice2,2), (choice1,1), (choice0,0), (choiceNeg1,-1), (choiceNeg2,-2)]
        self.init(withText: text, id: id, type: type, choices: choices)
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
