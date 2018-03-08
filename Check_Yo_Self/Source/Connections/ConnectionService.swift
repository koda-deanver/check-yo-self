//
//  ConnectionService.swift
//  Check_Yo_Self
//
//  Created by Phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Class -

class ConnectionService {
    
    static func connect(_ connection: Connection, completion: @escaping BoolClosure) {
        switch connection.type {
        case .healthKit: connectHealthKit(completion: completion)
        default: break
        }
    }
    
    static func disconnect(_ connection: Connection, completion: @escaping BoolClosure) {
        switch connection.type {
        case .healthKit: disconnectHealthKit(completion: completion)
        default: break
        }
    }
    
    static func checkConnection(for connection: Connection, completion: @escaping BoolClosure) {
        
        switch connection.type {
        case .healthKit: checkHealthKitConnection(completion: completion)
        default: break
        }
        
    }
    
    static func buildHealthKitConnection(viewController: GeneralViewController?) -> Connection {
    
        let connection = Connection(withType: .health, connectedHandler: { _ in
            viewController?.showAlert(BSGCustomAlert(message: "Your daily steps are earning you more gems!"))
        }, unconnectedHandler: { _ in
            viewController?.showAlert(BSGCustomAlert(message: "Connect HealthKit?", options: [(text: "Connect", handler: {
                
                
                self.connectHealthKit(completion: {
                    print("SUCCESS: HealthKit Enabled")
                    connection.checkConnection()
                }, failure: {error in
                    self.showConnectionAlert(ConnectionAlert(title: "Health", message: "Connection failed.", okButtonText: "OK"))
                    print("ERROR: \(error)")
                })
            })]))
        }, checkConnectionHandler: {
            PlayerData.sharedInstance.getStepCountHK(completion: {_ in
                self.isConnected = true
            }, failure: {_ in
                self.isConnected = false
            })
        })
        
    }
}

// MARK: - Extension: HealthKit -

extension ConnectionService {
    
    ///
    /// Checks if there is currently a connection to HealthKit.
    ///
    /// This method uses *getStepCount* to determine if there is a connection. There seems to be no direct way to determine if user has enabled HealthKit.
    ///
    /// - parameter completion: Handler containing Bool indicating whether HealthKit is connected.
    ///
    private static func checkHealthKitConnection(completion: @escaping BoolClosure) {
        
        HealthKitService.getStepCountHK(success: {_ in
            completion(true)
        }, failure: { _ in
            completion(false)
        })
    }
    
    ///
    /// Ask for user permission and connect HealthKit.
    ///
    /// - parameter completion: Handler containing Bool indicated if user established connection.
    ///
    private static func connectHealthKit(viewController: GeneralViewController, completion: @escaping BoolClosure) {
        
        viewController.showAlert(BSGCustomAlert(message: "Connect HealthKit?", options: [(text: "Connect", handler: {
            
            HealthKitService.authorize(success: {
                completion(true)
            }, failure: { _ in
                completion(false)
            })
        })])
    }
    
    private static func disconnectHealthKit(viewController: GeneralViewController, completion: @escaping BoolClosure) {
        
        let alert = BSGCustomAlert(message: "Your daily steps are earning you more gems!", options: [(text: "Ok", handler: {
                completion(true)
        })])
        viewController.showAlert(alert)
    }
}
