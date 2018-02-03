//********************************************************************
//  QuestionObject.swift
//  Check Yo Self
//  Created by Phil on 12/1/16
//
//  Description: Used to create a new question from provided choices
//********************************************************************

import UIKit

class QuestionObject: NSObject, NSCoding {
    let questionType: CreationPhase
    let questionID: String
    let questionText: String
    var choiceArray: [(choiceText: String, choiceValue: Int)] = []
    
    //********************************************************************
    // Designated Initializer
    // Description: Create a QuestionObject from passed in data and randomize
    // choices
    //********************************************************************
    init(_ questionType: CreationPhase, _ questionID: String, _ questionText: String, _ choice3: String, _ choice2: String, _ choice1: String, _ choice0: String, _ choiceNeg1: String, _ choiceNeg2: String){
        self.questionType = questionType
        self.questionID = questionID
        self.questionText = questionText
        self.choiceArray = [(choice3,3), (choice2,2), (choice1,1), (choice0,0), (choiceNeg1,-1), (choiceNeg2,-2)]
    }
    
    //********************************************************************
    // Required Convenience Initializer
    // Description: Required to initialize from archived object
    //********************************************************************
    convenience required init?(coder aDecoder: NSCoder) {
        let questionTypeString = aDecoder.decodeObject(forKey: "questionType") as! String
        let questionType = CreationPhase(rawValue: questionTypeString)!
        let questionID = aDecoder.decodeObject(forKey: "questionID") as! String
        let questionText = aDecoder.decodeObject(forKey: "questionText") as! String
        let choice3 = aDecoder.decodeObject(forKey: "choice3") as! String
        let choice2 = aDecoder.decodeObject(forKey: "choice2") as! String
        let choice1 = aDecoder.decodeObject(forKey: "choice1") as! String
        let choice0 = aDecoder.decodeObject(forKey: "choice0") as! String
        let choiceNeg1 = aDecoder.decodeObject(forKey: "choiceNeg1") as! String
        let choiceNeg2 = aDecoder.decodeObject(forKey: "choiceNeg2") as! String
        self.init(questionType, questionID, questionText, choice3, choice2, choice1, choice0, choiceNeg1, choiceNeg2)
    }
    
    //********************************************************************
    // randomize
    // Description: Mix up placement of choices (not used for profile phase)
    //********************************************************************
    func randomize(){
        // Randomize Choices
        var randomArray: [(choiceText: String, choiceValue: Int)] = []
        while self.choiceArray.count != 0{
            let randomIndex = Int(arc4random_uniform(UInt32(self.choiceArray.count)))
            randomArray.append(self.choiceArray[randomIndex])
            self.choiceArray.remove(at: randomIndex)
        }
        self.choiceArray = randomArray
    }
    
    //********************************************************************
    // encode
    // Description: Required to archive object
    //********************************************************************
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.questionType.rawValue, forKey:"questionType")
        aCoder.encode(self.questionID, forKey:"questionID")
        aCoder.encode(self.questionText, forKey:"questionText")
        aCoder.encode(self.choiceArray[0].0, forKey:"choice3")
        aCoder.encode(self.choiceArray[1].0, forKey:"choice2")
        aCoder.encode(self.choiceArray[2].0, forKey:"choice1")
        aCoder.encode(self.choiceArray[3].0, forKey:"choice0")
        aCoder.encode(self.choiceArray[4].0, forKey:"choiceNeg1")
        aCoder.encode(self.choiceArray[5].0, forKey:"choiceNeg2")
    }
    
    //********************************************************************
    // description
    // Description: Output string representation of QuestionObject to 
    // the console
    //********************************************************************
    override var description: String{
        get{
            return "\(self.questionType.rawValue) \(self.questionID): \(self.questionText)\n"
        }
    }
}
