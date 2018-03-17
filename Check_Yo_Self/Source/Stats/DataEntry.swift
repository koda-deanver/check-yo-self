//********************************************************************
//  DataEntry.swift
//  Check Yo Self
//  Created by Phil on 12/2/16
//
//  Description: Used to store a data from a single game entry
//********************************************************************

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
    
    init?(coder aDecoder: NSCoder) {
        let phaseValue = aDecoder.decodeObject(forKey: "phase") as! String
        let phase = CreationPhase(rawValue: phaseValue)!
        let score = aDecoder.decodeInteger(forKey: "score")
        let startTime = aDecoder.decodeObject(forKey: "startTime") as! Date
        let endTime = aDecoder.decodeObject(forKey: "endTime") as! Date
        let location = aDecoder.decodeObject(forKey: "location") as! CLLocation?
        let steps = aDecoder.decodeObject(forKey: "steps") as! Int?
        let heartRate = aDecoder.decodeObject(forKey: "heartRate") as! [String: Int]?
        let gemsEarned = aDecoder.decodeInteger(forKey: "gemsEarned")
        self.init(phase: phase, score: score, startTime: startTime, endTime: endTime, location: location, steps: steps, heartDictionary: heartRate, gemsEarned: gemsEarned)
    }
    
    //********************************************************************
    // encode
    // Description: Enable DataEntry to be archived
    //********************************************************************
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.phase.rawValue, forKey:"phase")
        aCoder.encode(self.score, forKey:"score")
        aCoder.encode(self.startTime, forKey:"startTime")
        aCoder.encode(self.endTime, forKey:"endTime")
        aCoder.encode(self.location, forKey:"location")
        aCoder.encode(self.steps, forKey: "steps")
        aCoder.encode(self.heartDictionary, forKey: "heartRate")
        aCoder.encode(self.gemsEarned, forKey:"gemsEarned")
    }
    
    //********************************************************************
    // description
    // Description: Output string representation of DataEntry to the console
    //********************************************************************
    override var description: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let startTimeString = dateFormatter.string(from: self.startTime)
        let endTimeString = dateFormatter.string(from: self.endTime)
        let lat = Double((self.location?.coordinate.latitude)!)
        let long = Double((self.location?.coordinate.longitude)!)
        var descriptionString = "\n\tStarted: \(startTimeString)\n\tEnded: \(endTimeString)\n\tScore: \(self.score)\n\t"
        descriptionString += String(format: "Location: (%.4f, %.4f)\n\t", lat, long)
        if let steps = self.steps{
            descriptionString += "Step Count: \(Int(steps))\n\t"
        }else{
            descriptionString += "Step Count: No step data\n\t"
        }
        if let heartDictionary = self.heartDictionary{
            descriptionString += "Heart Rate: \(heartDictionary)\n"
        }else{
            descriptionString += "Heart Rate: No heart data\n"
        }
        descriptionString += "Gems Earned: \(self.gemsEarned)\n"
        return descriptionString
    }
}
