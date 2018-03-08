//
//  HealthKitService.swift
//  check-yo-self
//
//  Created by Phil on 3/7/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import HealthKit

/// Interface for connected to and retreiving data from *HealthKit*.
class HealthKitService {
    
    static var healthStore = HKHealthStore()
    
    ///
    /// Attempt to authorize *HealthKit*.
    ///
    /// - parameter success: Handler for successful connection to HealthKit.
    /// - parameter failure: Handler for failing to connect to HealthKit.
    ///
    static func authorize(success: @escaping Closure, failure: @escaping ErrorClosure){
        
        var readTypes = Set<HKObjectType>()
        readTypes.insert(HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (wasSuccessful, error) -> Void in
            if let error = error {
                failure(error.localizedDescription)
            }else{
                if wasSuccessful {
                    success()
                } else {
                    failure("Failed to connect to HealthKit.")
                }
            }
        }
    }
    
    ///
    /// Gets cumulative sum of steps for the day from HealthKit.
    ///
    /// - parameter success: Handler for successful step grab containing step count.
    /// - parameter failure: Handler for failure to get steps.
    ///
    static func getStepCountHK(success: @escaping IntClosure, failure: @escaping ErrorClosure){
        
        // Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        // Get the start of the day
        let date = NSDate()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date as Date)
        
        // Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate as Date, end: NSDate() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        var stepCount: Double?
        // Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval as DateComponents)
        
        query.initialResultsHandler = { query, results, error in
            
            guard error == nil, let results = results else {
                failure(error?.localizedDescription ?? "Failed to get HealthKit data.")
                return
            }
           
            results.enumerateStatistics(from: date as Date, to: newDate as Date) {
                statistics, stop in
                
                guard let quantity = statistics.sumQuantity() else {
                    failure("Failed to get HealthKit data.")
                    return
                }
                
                stepCount = quantity.doubleValue(for: HKUnit.count())
                if let stepsDouble = stepCount{
                    success(Int(stepsDouble))
                }else{
                   failure("Failed to get step count.")
                }
            }
        }
        HKHealthStore().execute(query)
    }
}
