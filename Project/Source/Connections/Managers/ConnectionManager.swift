//
//  ConnectionManager.swift
//  check-yo-self
//
//  Created by phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

// MARK: - Class -

typealias ConnectionCompleteClosure = (Connection, Bool) -> Void

/// Consists methods for connecting, disconnecting, and checking connection for all devices. Some connections do not allow disconnecting (such as HealthKit which must be turned off from the settings menu). In these cases the *disconnect* handler does something else but keeps the same name.
final class ConnectionManager {
    
    // MARK: - Public Members -
    
    /// Singleton instance.
    static let shared = ConnectionManager()
    
    /// Array of all currently implemented connections.
    lazy var existingConnections: [Connection] = {
        let connections = ConnectionType.existing.map({
            return Connection(withType: $0)
        })
        return connections
    }()
    
    /// Number of connections with state set to .connected
    var connectedConnections: Int {
        
        var connectedCount = 0
        
        for connection in existingConnections where connection.state == .connected {
            connectedCount += 1
        }
        return connectedCount
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Attempt to connect the specified connection.
    ///
    /// - parameter connection: The desired connection to connect to.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    func connect(_ connection: Connection, viewController: GeneralViewController) {
        
        connection.state = .pending
        
        switch connection.type {
        case .facebook: connectFacebook(connection: connection, viewController: viewController)
        case .healthKit: connectHealthKit(connection: connection, viewController: viewController)
        case .fitbit: connectFitbit(connection: connection, viewController: viewController)
        case .maps: connectMaps(connection: connection, viewController: viewController)
        case .camera: connectCamera(connection: connection, viewController: viewController)
        default: break
        }
    }
    
    ///
    /// Attempt to disconnect the specified connection.
    ///
    /// - parameter connection: The desired connection to connect to.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    func disconnect(_ connection: Connection, viewController: GeneralViewController) {
        
        connection.state = .pending
        
        switch connection.type {
        case .facebook: explainFacebook(connection: connection, viewController: viewController)
        case .healthKit: explainHealthKit(connection: connection, viewController: viewController)
        case .fitbit: explainFitbit(connection: connection, viewController: viewController)
        case .maps: explainMaps(connection: connection, viewController: viewController)
        case .camera: explainCamera(connection: connection, viewController: viewController)
        default: break
        }
    }
    
    ///
    /// Checks whether the specified connection is connected.
    ///
    /// - parameter connection: The desired connection to check connection for.
    ///
    func checkConnection(for connection: Connection) {
        
        connection.state = .pending
        
        switch connection.type {
        case .facebook: checkFacebookConnection(connection: connection)
        case .healthKit: checkHealthKitConnection(connection: connection)
        case .fitbit: checkFitbitConnection(connection: connection)
        case .maps: checkMapsConnection(connection: connection)
        case .camera: checkCameraConnection(connection: connection)
        default: break
        }
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Handler after check connection, connect or disconnect is complete.
    ///
    /// - parameter connection: The desired connection to connect to.
    /// - parameter isConnected: Bool indicating if connection has been established.
    ///
    private func actionComplete(_ connection: Connection, _ isConnected: Bool) {
        
        DispatchQueue.main.async {
            let newState: ConnectionState = isConnected ? .connected : .unconnected
            connection.state = newState
            NotificationManager.shared.postNotification(ofType: .connectionUpdated)
        }
    }
}

// MARK: - Extension: Facebook -

extension ConnectionManager {
    
    ///
    /// Prompt user to login to *Facebook*.
    ///
    /// - parameter connection: The facebook connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func connectFacebook(connection: Connection, viewController: GeneralViewController) {
        
        let alert = BSGCustomAlert(message: "Login to Facebook?", options: [(text: "Login", handler: {
            
            DataManager.shared.loginFacebook(success: {
                self.actionComplete(connection, true)
            }, failure: { _ in
                self.actionComplete(connection, false)
            })

        }), (text: "Cancel", handler: { self.actionComplete(connection, false) })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Displays alert explaining the purpose of *Facebook* in the app.
    ///
    /// - note: This method also offers the option to logout.
    ///
    /// - parameter connection: The facebook connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func explainFacebook(connection: Connection, viewController: GeneralViewController) {
    
        let alert = BSGCustomAlert(message: "Facebook tracks your progress against friends on the leaderboard!", options: [(text: "Sweet", handler: {
            self.actionComplete(connection, true)
        }), (text: "Logout", handler: {
            BSGFacebookService.logout()
            self.actionComplete(connection, false)
        })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Checks if user is currently logged in to *Facebook*.
    ///
    /// - parameter connection: The facebook connection.
    ///
    private func checkFacebookConnection(connection: Connection) {
        actionComplete(connection, BSGFacebookService.isLoggedIn)
    }
}

// MARK: - Extension: HealthKit -

extension ConnectionManager {
    
    ///
    /// Ask for user permission and connect HealthKit.
    ///
    /// - parameter connection: The *HealthKit* connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func connectHealthKit(connection: Connection, viewController: GeneralViewController) {
        
        let alert = BSGCustomAlert(message: "Connect HealthKit?", options: [(text: "Connect", handler: {
            
            HealthKitManager.shared.authorize(success: {
                self.checkHealthKitConnection(connection: connection)
            }, failure: { _ in
                self.actionComplete(connection, false)
            })
        }), (text: "Cancel", handler: { self.actionComplete(connection, false) })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Displays alert explaining the purpose of *HealthKit* in the app.
    ///
    /// - parameter connection: The *HealthKit* connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func explainHealthKit(connection: Connection, viewController: GeneralViewController) {
        
        let alert = BSGCustomAlert(message: "Your daily steps are earning you more gems!", options: [(text: "Ok", handler: {
            self.actionComplete(connection, true)
        })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Checks if there is currently a connection to HealthKit.
    ///
    /// This method uses *getStepCount* to determine if there is a connection. There seems to be no direct way to determine if user has enabled HealthKit.
    ///
    /// - parameter connection: The *HealthKit* connection.
    ///
    private func checkHealthKitConnection(connection: Connection) {
        
        HealthKitManager.shared.getStepCountHK(success: {_ in
            self.actionComplete(connection, true)
        }, failure: { _ in
            self.actionComplete(connection, false)
        })
    }
}

// MARK: - Extension: Fitbit -

extension ConnectionManager {
    
    ///
    /// Ask user to login to Fitbit account.
    ///
    /// - parameter connection: The *Fitbit* connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func connectFitbit(connection: Connection, viewController: GeneralViewController) {
        
        let alert = BSGCustomAlert(message: "Connect Fitbit?", options: [(text: "Connect", handler: {
            
            FitbitManager.shared.login(from: viewController) { isConnected in
                self.actionComplete(connection, isConnected)
            }
        }), (text: "Cancel", handler: { self.actionComplete(connection, false) })])
        
        viewController.showAlert(alert)
    }
    
    ///
    /// Displays alert explaining the purpose of *Fitbit* in the app.
    ///
    /// - parameter connection: The *Fitbit* connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func explainFitbit(connection: Connection, viewController: GeneralViewController) {
        
        let alert = BSGCustomAlert(message: "Your heart rate and daily activity boost your scores and earn gems!", options: [(text: "Cool", handler: {
            self.actionComplete(connection, true)
        })])
        viewController.showAlert(alert)
    }
    
    ///
    /// Checks if there is currently a connection to Fitbit.
    ///
    /// FIX: Check this connection more directly.
    /// This method uses *getTodaysHeartData* to determine if there is a connection.
    ///
    /// - parameter connection: The *Fitbit* connection.
    ///
    private func checkFitbitConnection(connection: Connection) {
        
        FitbitManager.shared.getTodaysHeartData(success: { _ in
            self.actionComplete(connection, true)
        }, failure: { _ in
            self.actionComplete(connection, false)
        })
    }
}

// MARK: - Extension: Maps -

extension ConnectionManager {
    
    ///
    /// Ask user for permission to use location.
    ///
    /// - parameter connection: The *Maps* connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func connectMaps(connection: Connection, viewController: GeneralViewController) {
        LocationManager.shared.configure()
        checkMapsConnection(connection: connection)
    }
    
    
    ///
    /// Displays alert explaining the purpose of *Maps* in the app.
    ///
    /// - parameter connection: The *Maps* connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func explainMaps(connection: Connection, viewController: GeneralViewController) {
        
        let alert = BSGCustomAlert(message: "Tracking your location!", options: [(text: "Cool", handler: {
            self.actionComplete(connection, true)
        })])
        viewController.showAlert(alert)
    }
    
    ///
    /// Checks if there is currently a connection to maps.
    ///
    /// If a location can be obtained, there is a connection.
    ///
    /// - parameter connection: The *Maps* connection.
    ///
    private func checkMapsConnection(connection: Connection) {
        let isConnected = LocationManager.shared.location != nil
        actionComplete(connection, isConnected)
    }
}

// MARK: - Extension: Camera -

extension ConnectionManager {
    
    ///
    /// Display camera controller and allow user to take picture.
    ///
    /// If a picture is chosen, the connection is set to true.
    ///
    /// - parameter connection: The *Camera* connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func connectCamera(connection: Connection, viewController: GeneralViewController) {
        
        CameraManager.shared.showCamera(inViewController: viewController, completion: { isConnected in
            self.actionComplete(connection, isConnected)
        })
    }
    
    ///
    /// Displays alert explaining the purpose of *Camera* in the app.
    ///
    /// - parameter connection: The *Camera* connection.
    /// - parameter viewController: View controller on which to display alerts.
    ///
    private func explainCamera(connection: Connection, viewController: GeneralViewController) {
        
        let alert = BSGCustomAlert(message: "Your chosen picture is being used as your avatar!", options: [(text: "Cool", handler: {
            self.actionComplete(connection, true)
        }), (text: "Remove", handler: {
            CameraManager.shared.removeSavedImage()
            self.actionComplete(connection, false)
        })])
        viewController.showAlert(alert)
    }
    
    ///
    /// Checks if there is currently a connection to *Camera*.
    ///
    /// If a saved image is found, there is a connection.
    ///
    /// - parameter connection: The *Camera* connection.
    ///
    private func checkCameraConnection(connection: Connection) {
        let isConnected = CameraManager.shared.savedImage != nil
        actionComplete(connection, isConnected)
    }
}
