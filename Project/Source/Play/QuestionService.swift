//
//  QuestionsService.swift
//  check-yo-self
//
//  Created by phil on 12/1/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  Update: Changed from QuestionStorage 3/15/18. Questions now come directly from Firebase with no local saving.
//

import UIKit
import Firebase

final class QuestionService {
    
    ///
    /// Get specified amount of randomly generated questions.
    ///
    /// - parameter: amount: Number of questions to choose from all questions.
    /// - parameter type: The type of question to get.
    /// - parameter success: Handler for successful load of questions.
    /// - parameter failure: Handler for failure to get questions.
    ///
    static func get(_ amount: Int, questionsOfType type: QuestionType, success: @escaping ([Question]) -> Void, failure: ErrorClosure?){
        
        getQuestions(ofType: type, success: { questions in
            
            guard questions.count >= amount else {
                failure?("Not Enough Questions! The developers are lazy :(.")
                return
            }
            
            // Eliminate questions as they are used.
            var allQuestions = questions
            var chosenQuestions: [Question] = []
            var count = 0
//            for _ in 0 ..< amount{
//                let index = Int(arc4random_uniform(UInt32(allQuestions.count)))
//                var newQuestion: Question = allQuestions[index]
//                newQuestion.randomize()
//                chosenQuestions.append(newQuestion)
//                allQuestions.remove(at: index)
//            }
            for question in allQuestions {
                guard count < amount else { return }
                chosenQuestions.append(question)
                count = count + 1
            }
            success(chosenQuestions)
            
        }, failure: failure)
    }
    
    ///
    /// Adds new questions to database.
    ///
    /// - parameter questionType: Type of questions to add.
    /// - parameter questions: Questions objects to add.
    /// - parameter success: Handler for successful update of questions.
    /// - parameter failure: Handler for failure to update questions.
    ///
    static func updateQuestions(ofType questionType: QuestionType, questions: [Question], success: Closure?, failure: ErrorClosure?) {
        
        let questionPath = Constants.firebaseRootPath.child("questions")
        
        var questionSnapshots: [Any] = []
        for question in questions {
            questionSnapshots.append(question.toSnapshot())
        }
        
        BSGFirebaseService.updateData(atPath: questionPath, values: [questionType.databaseNode: questionSnapshots], success: {
            success?()
        }, failure: {
            failure?("Failed to update questions.")
        })
    }
    
    ///
    /// Get questions of specified type from database.
    ///
    /// - parameter type: The type of question to get.
    /// - parameter success: Handler for successful load of questions.
    /// - parameter failure: Handler for failure to get questions.
    ///
    static func getQuestions(ofType type: QuestionType, success: @escaping ([Question]) -> Void, failure: ErrorClosure?) {
        
        let questionPath = Constants.firebaseRootPath.child("Questions/\(type.databaseNode.capitalized)Question")
        
        print("dB PATH: \(questionPath)")
        BSGFirebaseService.fetchData(atPath: questionPath, success: { snapshot in
            
            guard let questionSnapshots = snapshot.value as? [[String: Any]] else {
                failure?("Connection Error")
                return
            }
            
            print("YOLO >> \(questionSnapshots)")
            var questions: [Question] = []
            
            for snapshot in questionSnapshots {
                guard let question = Question(withSnapshot: snapshot, type: type) else { continue }
                if questions.count < 20 {
                    questions.append(question)
                }
            }
            
            success(questions)
            
        }, failure: nil)
    }
}
