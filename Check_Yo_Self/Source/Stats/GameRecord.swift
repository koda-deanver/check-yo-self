//
//  GameRecord.swift
//  check-yo-self
//
//  Created by Phil on 12/2/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  Updated from local object DataEntry 3/16/18
//

import Foundation
import CoreLocation

/// Represents a single previously played game.
struct GameRecord {
    
    // MARK: - Public Members -
    
    let questionType: QuestionType
    let score: Int
    let startTime: Date
    let endTime: Date
    var location: CLLocation?
    var steps: Int?
    var heartData: HeartData?
    var gemsEarned: Int
    
    // MARK: - Initializers -
    
    init(type: QuestionType, score: Int, startTime: Date, endTime: Date, location: CLLocation?, steps: Int?, heartData: HeartData?, gemsEarned: Int) {
        self.questionType = type
        self.score = score
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.steps = steps
        self.heartData = heartData
        self.gemsEarned = gemsEarned
    }
    
    init?(withSnapshot snapshot: [String: Any]) {
        
        guard let questionTypeValue = snapshot["type"] as? String, let questionType = QuestionType(rawValue: questionTypeValue) else { return nil }
        guard let score = snapshot["score"] as? Int, let gemsEarned = snapshot["gems-earned"] as? Int else { return nil }
        guard let startTimeString = snapshot["start-time"] as? String, let endTimeString = snapshot["end-time"] as? String else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd_HH:mm:ss"
        
        guard let startTime = dateFormatter.date(from: startTimeString), let endTime = dateFormatter.date(from: endTimeString) else { return nil }
        
        self.questionType = questionType
        self.score = score
        self.gemsEarned = gemsEarned
        self.startTime = startTime
        self.endTime = endTime
        
        self.location = snapshot["location"] as? CLLocation
        self.steps = snapshot["step-count"] as? Int
        self.heartData = snapshot["heart-data"] as? HeartData
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Turns game record into snapshot to be saved to database.
    ///
    /// - returns: Dictionary representation of game record.
    ///
    func toSnapshot() -> [String: Any] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd_HH:mm:ss"
        
        let startTimeString = dateFormatter.string(from: startTime)
        let endTimeString = dateFormatter.string(from: endTime)
        
        var snapshot: [String: Any] = ["type": questionType.rawValue, "score": score, "gems-earned": gemsEarned, "start-time": startTimeString, "end-time": endTimeString]
        
        if let heartData = heartData {
            snapshot["heart-data"] = heartData.toSnapshot()
        }
        
        return snapshot
    }
}
