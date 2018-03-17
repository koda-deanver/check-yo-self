//
//  FitbitManager.swift
//  check-yo-self
//
//  Created by Phil on 3/9/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Struct -

/// Contains data about user heart rate over.
struct HeartData {
    /// The average resting heart rate over the course of the day.
    let restingHeartRate: Int
    /// Number of minutes spent in the *fatBurn* zone throughout the day.
    let fatBurnMinutes: Int
    /// Number of minutes spent in the *cardio* zone throughout the day.
    let cardioMinutes: Int
    /// Number of minutes spent in the *peak* zone throughout the day.
    let peakMinutes: Int
}

/// Provide interface to get information from *Fitbit*.
final class FitbitManager {
    
    // MARK: - Public Members -
    
    /// Singleton instance.
    static let shared = FitbitManager()
    
    // MARK: - Private Members -
    
    /// Used to login and authenticate usage of Fitbit.
    private lazy var authenticationController = AuthenticationController(delegate: self)
    // FIX: Probly not good to save this here.
    /// Saved authorization token used when retreiving data.
    private var currentToken: String?
    
    // MARK: - Public Methods -
    
    ///
    /// Login to Fitbit.
    ///
    /// - parameter viewController: View controller to display login screen from.
    ///
    func login(from viewController: GeneralViewController) {
        authenticationController.login(fromParentViewController: viewController)
    }
    
    ///
    /// Gets information about the user's heart rate for the current day.
    ///
    /// - parameter success: Success handler containing HeartData object.
    /// - parameter failure: Failure handler containing error string.
    ///
    func getTodaysHeartData(success: @escaping (HeartData) -> Void, failure: @escaping ErrorClosure){
        
        guard let token = currentToken else {
            failure("Login to Fitbit to get heart data")
            return
        }
        
        FitbitAPI.sharedInstance.authorize(with: token)
        let datePath = "/today/1d.json"
        getHeartData(for: datePath, success: success, failure: failure)
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Gets information about the user's heart rate for given datepath.
    ///
    /// - parameter datePath: The range of dates to get heart data for.
    /// - parameter success: Success handler containing HeartData object.
    /// - parameter failure: Failure handler containing error string.
    ///
    private func getHeartData(for datePath: String, success: @escaping (HeartData) ->Void, failure: @escaping ErrorClosure){
        
        guard let session = FitbitAPI.sharedInstance.session,
            let heartURL = URL(string: "https://api.fitbit.com/1/user/-/activities/heart/date\(datePath)") else {
                failure("Failed to connect.")
                return
        }
        
        session.dataTask(with: heartURL) { (data, response, error) in
            
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data else {
                failure(error?.localizedDescription ?? "Failed to retreive data.")
                return
            }

            guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                failure("Failed to read data.")
                return
            }
            
            // Dig down to dictionary containing heart rate info.
            guard let heartActivitiesArray = (dictionary["activities-heart"]) as? [Any], let heartDictionary = heartActivitiesArray[0] as? [String: Any], let heartValues = heartDictionary["value"]! as? [String: Any] else {
                failure("Failed to read data.")
                return
            }
            
            let restingHeartRate = heartValues["restingHeartRate"] as? Int ?? 0
            
            guard let heartZones = heartValues["heartRateZones"] as? [Any] else {
                success(HeartData(restingHeartRate: restingHeartRate, fatBurnMinutes: 0, cardioMinutes: 0, peakMinutes: 0))
                return
            }
            
            let fatBurnMinutes = (heartZones[1] as? [String: Any])?["minutes"] as? Int ?? 0
            let cardioMinutes = (heartZones[2] as? [String: Any])?["minutes"] as? Int ?? 0
            let peakMinutes = (heartZones[3] as? [String: Any])?["minutes"] as? Int ?? 0
                        
            success(HeartData(restingHeartRate: restingHeartRate, fatBurnMinutes: fatBurnMinutes, cardioMinutes: cardioMinutes, peakMinutes: peakMinutes))
            
        }.resume()
    }
}

// MARK: - Extension: AuthenticationProtocol -

extension FitbitManager: AuthenticationProtocol {
    
    func authorizationDidFinish(_ success: Bool) {
        guard let authToken = authenticationController.authenticationToken else {
            return
        }
        currentToken = authToken
    }
}
