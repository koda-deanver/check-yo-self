//********************************************************************
//  HeartStats.swift
//  Check Yo Self
//  Added by Phil on 12/2016
//
//  Description: Get Fitbit Heart stats
//********************************************************************

import UIKit

struct HeartStats {
    
    //********************************************************************
    // getTodaysHeartStats
    // Description: Call getHeartStats with todays date
    //********************************************************************
    static func getTodaysHeartStats(completion: @escaping ([String: Int]?) -> Void, failure:@escaping (ErrorType) -> Void){
		let datePath = "/today/1d.json"
        HeartStats.getHeartStats(for: datePath, completion: completion, failure: failure)
	}

    //********************************************************************
    // getHeartStats
    // Description: Return dictionary with heart data
    //********************************************************************
    static func getHeartStats(for datePath: String, completion: @escaping ([String: Int]?) ->Void, failure: @escaping (ErrorType) -> Void){
		guard let session = FitbitAPI.sharedInstance.session,
            let heartURL = URL(string: "https://api.fitbit.com/1/user/-/activities/heart/date\(datePath)") else {
                // URL Doesn't exist
				failure(.data("Can't find URL"))
                return
		}
		session.dataTask(with: heartURL) { (data, response, error) in
            if let error = error{
                failure(.connection(error))
            }else{
                guard let data = data,
                    let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                        DispatchQueue.main.async {
                            failure(.data(""))
                        }
                        return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        failure(.data("error code"))
                    }
                    return
                }
                // Build heart rate dictionary from raw dictionary
                guard let heartActivitiesArray = (dictionary["activities-heart"]) as? [Any] else{return}
                if let insideHeartDict = heartActivitiesArray[0] as? [String: Any]{
                    if let heartValuesDict = insideHeartDict["value"]! as? [String: Any]{
                        var gameHeartDictionary: [String: Int] = [:]
                        if let restingHeartRate = heartValuesDict["restingHeartRate"] as? Int{
                            gameHeartDictionary[HeartCategory.restingHeartRate.rawValue] = restingHeartRate
                        }
                        if let heartZones = heartValuesDict["heartRateZones"] as? [Any]{
                            let fatBurnZone = heartZones[1] as? [String: Any]
                            gameHeartDictionary[HeartCategory.fatBurnMinutes.rawValue] = fatBurnZone?["minutes"] as? Int
                            let cardioZone = heartZones[2] as? [String: Any]
                            gameHeartDictionary[HeartCategory.cardioMinutes.rawValue] = cardioZone?["minutes"] as? Int
                            let peakZone = heartZones[3] as? [String: Any]
                            gameHeartDictionary[HeartCategory.peakMinutes.rawValue] = peakZone?["minutes"] as? Int
                        }
                        
                        
                        DispatchQueue.main.async {
                            // Ensure there is at least some data for success
                            guard gameHeartDictionary.isEmpty == false else{
                                failure(.data("No user data for today"))
                                return
                            }
                            completion(gameHeartDictionary)
                        }
                            
                            
                        } // heartValuesDict
                } // insideHeartDict
            } // error == nil
		}.resume() // dataTask
	}
}
