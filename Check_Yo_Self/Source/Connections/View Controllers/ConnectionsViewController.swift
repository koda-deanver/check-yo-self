//
//  ConnectionsViewController.swift
//  check-yo-self
//
//  Created by Phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

class ConnectionsViewController: SkinnedViewController {
    
    lazy var healthStore = HKHealthStore()
    var authenticationController: AuthenticationController?
    
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //********************************************************************
    // Action: connectionPressed
    // Description: Try to connect user to the chosen connection
    //********************************************************************
    @IBAction func connectionPressed(_ sender: UIButton) {
        for index in 0..<Constants.connections.count{
            // Found correct connection
            if self.backdropArray[index] == sender{
                handleConnectionTouch(Constants.connections[index], connectionIndex: index)
            }
        }
    }
    
    //********************************************************************
    // viewDidLoad
    // Description:
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        // Authentication Controller for Fitbit
        self.authenticationController = AuthenticationController(delegate: self)
        // Set connection label color
        self.connectionsLabel.textColor = CubeColor.green.uiColor
        loadAllConnections()
    }
    
    //********************************************************************
    // resetAllconnections
    // Description: Reset all connections to false to test again
    //********************************************************************
    func resetAllConnections(){
        for connection in Constants.connections{
            connection.isConnected = nil
        }
    }
    
    //********************************************************************
    // loadConnectionStatus
    // Description: Check all connections available and show them. Display 
    // those that are active in green
    //********************************************************************
    func loadAllConnections(){
        resetAllConnections()
        self.backdropArray = [backdrop0, backdrop1, backdrop2, backdrop3, backdrop4, backdrop5, backdrop6, backdrop7, backdrop8, backdrop9, backdrop10, backdrop11]
        // Initially set all alpha to faded
        for backdrop in self.backdropArray{
            backdrop.alpha = 0.4
        }
        for connectionIndex in 0..<Constants.connections.count{
            // Show connections that are available
            self.backdropArray[connectionIndex].alpha = 1.0
            // Set up Connection Image
            let backdropDimension = self.backdropArray[connectionIndex].frame.width
            let imageDimension = backdropDimension * 0.6
            let connectionImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: imageDimension, height: imageDimension)))
            connectionImageView.center = CGPoint(x: backdropDimension/2, y: backdropDimension/2)
            // Set correct image
            let connectionImageName = Constants.connections[connectionIndex].type.rawValue
            connectionImageView.image = UIImage(named: connectionImageName)
            self.backdropArray[connectionIndex].addSubview(connectionImageView)
            // Check each for connection status
            checkConnection(connectionIndex: connectionIndex)
            Constants.connections[connectionIndex].checkConnection()
        }
    }
    
    //********************************************************************
    // countConnected
    // Description: Update label with correct number of made connections
    //********************************************************************
    func countConnected(){
        var connectionsMade: Int = 0
        for connection in Constants.connections{
            if connection.isConnected == true{
                connectionsMade += 1
            }
        }
        self.connectionsLabel.text = "Connections: \(connectionsMade)/\(Constants.connections.count)"
    }
    
    //********************************************************************
    // handleConnectionTouch
    // Description: Try to connect user to the chosen connection
    //********************************************************************
    func handleConnectionTouch(_ connection: Connection, connectionIndex: Int){
        if let isConnected = connection.isConnected{
            // Reset to recheck
            switch connection.type{
            case .cube:
                if isConnected{
                    self.showConnectionAlert(ConnectionAlert(title: "Member Account", connectionStatus: .connected, message: "Members get extra game features and exclusive access to the marketplace.", okButtonText: "OK"))
                }else{
                    // Sentry Login
                    self.showConnectionAlert(ConnectionAlert(title: "Connect Member Account?", connectionStatus: .notConnected, message: "Members get extra game features and exclusive access to the marketplace.", okButtonText: "Connect", cancelButtonText: "Cancel", okButtonCompletion: {
                        let alertController = UIAlertController(title: "Log in to member account", message: "If you don't have a member account, you can sign up on the CollabRJabbR website.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addTextField(){
                            textField in
                            textField.placeholder = "Username"
                            textField.borderStyle = .roundedRect
                        }
                        alertController.addTextField(){
                            textField in
                            textField.placeholder = "Password"
                            textField.borderStyle = .roundedRect
                        }
                        alertController.addAction(UIAlertAction(title: "Login", style: .default){
                            action in
                        })
                        alertController.addAction(UIAlertAction(title: "Cancel", style: .default){
                            action in
                        })
                        self.present(alertController, animated: true){
                            
                        }

                    }))
                }
            case .facebook:
                if isConnected{
                    self.showConnectionAlert(ConnectionAlert(title: "Facebook", connectionStatus: .connected, message: "Track your progress against friends on the leaderboard!", okButtonText: "OK"))
                }else{
                    self.showConnectionAlert(ConnectionAlert(title: "Connect Facebook?", connectionStatus: .notConnected, message: "Logging into Facebook allows you to see which friends are playing and track your progress against friends on the leaderboard.", okButtonText: "Connect", cancelButtonText: "Cancel", okButtonCompletion: {
                        connection.isConnected = nil
                        // Start pending animation
                        self.checkConnection(connectionIndex: connectionIndex)
                        // Facebook Login
                        self.loginFB(completion: {
                            print("SUCCESS: Facebook Login")
                            self.loadAllFacebookData()
                            connection.checkConnection()
                        }, failure: { errorType in
                            print("ERROR: Facebook Login")
                            connection.checkConnection()
                            self.showConnectionAlert(ConnectionAlert(title: "Facebook", message: "Login failed.", okButtonText: "OK"))
                        })
                    }))
                }
            case .health:
                if isConnected{
                    self.showConnectionAlert(ConnectionAlert(title: "Health", connectionStatus: .connected, message: "Your daily steps are earning you more gems!", okButtonText: "OK"))
                }else{
                    self.showConnectionAlert(ConnectionAlert(title: "Connect Health?", connectionStatus: .notConnected, message: "Your daily steps will earn you more gems.", okButtonText: "Connect", cancelButtonText: "Cancel", okButtonCompletion: {
                        connection.isConnected = nil
                        // Start pending animation
                        self.checkConnection(connectionIndex: connectionIndex)
                        // Attempt to enable
                        self.connectHealthKit(completion: {
                            print("SUCCESS: HealthKit Enabled")
                            connection.checkConnection()
                        }, failure: {error in
                            self.showConnectionAlert(ConnectionAlert(title: "Health", message: "Connection failed.", okButtonText: "OK"))
                            print("ERROR: \(error)")
                        })
                    }))
                }
            case .fitbit:
                if isConnected{
                    self.showConnectionAlert(ConnectionAlert(title: "Fitbit", connectionStatus: .connected, message: "Your heart rate and daily activity boost your scores and earn gems!", okButtonText: "OK"))
                }else{
                    self.showConnectionAlert(ConnectionAlert(title: "Connect Fitbit?", message: "Your heart rate and daily activity will boost your scores and earn gems!", okButtonText: "Connect", cancelButtonText: "Cancel", okButtonCompletion: {
                        connection.isConnected = nil
                        // Start pending animation
                        self.checkConnection(connectionIndex: connectionIndex)
                        // Fitbit Login
                        self.authenticationController?.login(fromParentViewController: self)
                    }))
                }
            case .maps:
                if isConnected{
                    self.showConnectionAlert(ConnectionAlert(title: "Maps", connectionStatus: .connected, message: "Keep track of your game locations on the Stats page.", okButtonText: "OK"))
                }else{
                    self.showConnectionAlert(ConnectionAlert(title: "Connect Maps?", connectionStatus: .notConnected, message: "Keep track of your game locations on the Stats page.", okButtonText: "Connect", cancelButtonText: "Cancel", okButtonCompletion: {
                        connection.isConnected = nil
                        // Start pending animation
                        self.checkConnection(connectionIndex: connectionIndex)
                        //Setup Location Manager and ask for permission
                        if (CLLocationManager.locationServicesEnabled()){
                            print("Location Enabled")
                            PlayerData.sharedInstance.locationManager = CLLocationManager()
                            PlayerData.sharedInstance.locationManager?.delegate = PlayerData.sharedInstance
                            PlayerData.sharedInstance.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                            PlayerData.sharedInstance.locationManager?.requestWhenInUseAuthorization()
                            PlayerData.sharedInstance.locationManager?.startUpdatingLocation()
                        }
                    }))
                }
            default:
                break
            }
        }
    }
    
    

    //********************************************************************
    // authorizationDidFinish
    // Description: Authorization succeeded for Fitbit
    //********************************************************************
    func authorizationDidFinish(_ success: Bool) {
        guard let authToken = authenticationController?.authenticationToken else {
            return
        }
        PlayerData.sharedInstance.fitbitToken = authToken
        for connection in Constants.connections where connection.type == .fitbit{
            connection.checkConnection()
        }
    }
    
    //********************************************************************
    // handleFBLogin
    // Description: Handle log in when FB button Pressed
    //********************************************************************
    func loginFB(completion: @escaping () -> Void, failure: @escaping (ErrorType) -> Void){
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, ReadPermission.userFriends]) { loginResult in
            switch loginResult {
            case .failed: failure(ErrorType.data("Fix"))
            case .cancelled: failure(ErrorType.data("Fix"))
            case .success(_, _, _): completion()
            }
        }
    }
    
    //********************************************************************
    // loadAllFacebookData
    // Description: Helper function to load player FB data upon first connect
    //********************************************************************
    func loadAllFacebookData(){
        // Load FB Data
        PlayerData.sharedInstance.loadPlayerFB(completion: {
            print("SUCCESS: Player FB data loaded")
            PlayerData.sharedInstance.loadFriendsFB(completion: { _ in
                print("SUCCESS: Player FB friends Loaded")
            }, failure: { errorType in
                switch errorType{
                case .connection(let error):
                    print("CONNECTION ERROR: \(error)")
                case .permissions(let errorString):
                    print("PERMISSIONS ERROR: \(errorString)")
                case .data(let errorString):
                    print("DATA ERROR: \(errorString)")
                default:
                    break
                }
            })
        }, failure: { errorType in
            print("--LOAD PLAYER FB--")
            switch errorType{
            case .connection(let error):
                print("CONNECTION ERROR: \(error)")
            case .permissions(let errorString):
                print("PERMISSIONS ERROR: \(errorString)")
            case .data(let errorString):
                print("DATA ERROR: \(errorString)")
            default:
                break
            }
        })
    }
}

// MARK: - Extension: Actions -

extension ConnectionsViewController {
    
     @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
     }
}

