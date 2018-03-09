//
//  ConnectionManager.swift
//  check-yo-self
//
//  Created by Phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Class -

/// Consists methods for connecting, disconnecting, and checking connection for all devices. Some connections do not allow disconnecting (such as HealthKit which must be turned off from the settings menu). In these cases the *disconnect* handler does something else but keeps the same name.
final class ConnectionManager {
    
    // MARK: - Public Members -
    
    /// Singleton instance.
    static let shared = ConnectionManager()
    /// Array of all currently implemented connections.
    var existingConnections: [Connection] {
        let connections = ConnectionType.existing.map({
            return Connection(withType: $0)
        })
        return connections
    }
    
    ///
    /// Attempt to connect the specified connection.
    ///
    /// - parameter connection: The desired connection to connect to.
    /// - parameter viewController: View controller on which to display alerts.
    /// - parameter completion: Handler containing Bool indicating if connection was established.
    ///
    func connect(_ connection: Connection, viewController: GeneralViewController, completion: @escaping BoolClosure) {
        switch connection.type {
        case .facebook: connectFacebook(viewController: viewController, completion: completion)
        case .healthKit: connectHealthKit(viewController: viewController, completion: completion)
        case .fitbit: connectFitbit(viewController: viewController, completion: completion)
        default: break
        }
    }
    
    ///
    /// Attempt to disconnect the specified connection.
    ///
    /// - parameter connection: The desired connection to connect to.
    /// - parameter viewController: View controller on which to display alerts.
    /// - parameter completion: Handler containing Bool indicating if connection was established.
    ///
    func disconnect(_ connection: Connection, viewController: GeneralViewController, completion: @escaping BoolClosure) {
        switch connection.type {
        case .facebook: explainFacebook(viewController: viewController, completion: completion)
        case .healthKit: explainHealthKit(viewController: viewController, completion: completion)
        case .fitbit: explainFitbit(viewController: viewController, completion: completion)
        default: break
        }
    }
    
    ///
    /// Checks whether the specified connection is connected.
    ///
    /// - parameter connection: The desired connection to connect to.
    /// - parameter completion: Handler containing Bool indicating if connection was established.
    ///
    func checkConnection(for connection: Connection, completion: @escaping BoolClosure) {
        
        switch connection.type {
        case .facebook: checkFacebookConnection(completion: completion)
        case .healthKit: checkHealthKitConnection(completion: completion)
        case .fitbit: checkFitbitConnection(completion: completion)
        default: break
        }
    }
}

// MARK: - Extension: Facebook -

extension ConnectionManager {
    
    ///
    /// Prompt user to login to *Facebook*.
    ///
    /// - parameter viewController: View controller on which to display alerts.
    /// - parameter completion: Handler containing Bool indicating if connection was established.
    ///
    private func connectFacebook(viewController: GeneralViewController, completion: @escaping BoolClosure) {
        
        let alert = BSGCustomAlert(message: "Login to Facebook?", options: [(text: "Login", handler: {
            BSGFacebookService.login(completion: {
                completion(true)
            }, failure: { _ in
                completion(false)
            })
        }), (text: "Cancel", handler: { completion(false) })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Displays alert explaining the purpose of *Facebook* in the app.
    ///
    /// - note: This method also offers the option to logout.
    ///
    /// - parameter viewController: View controller on which to display alerts.
    /// - parameter completion: Handler containing Bool indicating if connection is still present.
    ///
    private func explainFacebook(viewController: GeneralViewController, completion: @escaping BoolClosure) {
        
        let alert = BSGCustomAlert(message: "Facebook tracks your progress against friends on the leaderboard!", options: [(text: "Sweet", handler: {
            completion(true)
        }), (text: "Logout", handler: {
            BSGFacebookService.logout()
            completion(false)
        })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Checks if user is currently logged in to *Facebook*.
    ///
    /// - parameter completion: Handler containing Bool indicating whether user is logged in.
    ///
    private func checkFacebookConnection(completion: @escaping BoolClosure) {
        completion(BSGFacebookService.isLoggedIn)
    }
}

// MARK: - Extension: HealthKit -

extension ConnectionManager {
    
    ///
    /// Ask for user permission and connect HealthKit.
    ///
    /// - parameter viewController: View controller on which to display alerts.
    /// - parameter completion: Handler containing Bool indicating if connection was established.
    ///
    private func connectHealthKit(viewController: GeneralViewController, completion: @escaping BoolClosure) {
        
        let alert = BSGCustomAlert(message: "Connect HealthKit?", options: [(text: "Connect", handler: {
            
            HealthKitService.authorize(success: {
                completion(true)
            }, failure: { _ in
                completion(false)
            })
        })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Displays alert explaining the purpose of *HealthKit* in the app.
    ///
    /// - parameter viewController: View controller on which to display alerts.
    /// - parameter completion: Handler containing Bool indicating if connection is still present.
    ///
    private func explainHealthKit(viewController: GeneralViewController, completion: @escaping BoolClosure) {
        
        let alert = BSGCustomAlert(message: "Your daily steps are earning you more gems!", options: [(text: "Ok", handler: {
            completion(true)
        })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Checks if there is currently a connection to HealthKit.
    ///
    /// This method uses *getStepCount* to determine if there is a connection. There seems to be no direct way to determine if user has enabled HealthKit.
    ///
    /// - parameter completion: Handler containing Bool indicating whether HealthKit is connected.
    ///
    private func checkHealthKitConnection(completion: @escaping BoolClosure) {
        
        HealthKitService.getStepCountHK(success: {_ in
            completion(true)
        }, failure: { _ in
            completion(false)
        })
    }
}

// MARK: - Extension: Fitbit -

extension ConnectionManager {
    
    ///
    /// Ask user to login to Fitbit account.
    ///
    /// - parameter viewController: View controller on which to display alerts.
    /// - parameter completion: Handler containing Bool indicating if connection was established.
    ///
    private func connectFitbit(viewController: GeneralViewController, completion: @escaping BoolClosure) {
        
        let alert = BSGCustomAlert(message: "Connect Fitbit?", options: [(text: "Connect", handler: {
            FitbitManager.shared.login(from: viewController)
        }), (text: "Cancel", handler: { completion(false) })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Displays alert explaining the purpose of *Fitbit* in the app.
    ///
    /// - parameter viewController: View controller on which to display alerts.
    /// - parameter completion: Handler containing Bool indicating if connection is still present.
    ///
    private func explainFitbit(viewController: GeneralViewController, completion: @escaping BoolClosure) {
        
        let alert = BSGCustomAlert(message: "Your heart rate and daily activity boost your scores and earn gems!")
        viewController.showAlert(alert)
    }
    
    ///
    /// Checks if there is currently a connection to Fitbit.
    ///
    /// FIX: Check this connection more directly.
    /// This method uses *getTodaysHeartData* to determine if there is a connection.
    ///
    /// - parameter completion: Handler containing Bool indicating whether Fitbit is connected.
    ///
    private func checkFitbitConnection(completion: @escaping BoolClosure) {
        
        FitbitManager.shared.getTodaysHeartData(success: { _ in
            completion(true)
        }, failure: { _ in
            completion(false)
        })
    }
}
