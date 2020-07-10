//
//  DataManager.swift
//  check-yo-self
//
//  Created by phil on 1/18/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FacebookCore
import GoogleSignIn

// MARK: - Enumeration -

/// All types of data that are saved to UserDefaults.
enum LocalData: String {
    case questionType
    case fitbitToken
}

// MARK: - Class -

/// Class used for saving and retreiving data.
class DataManager {
    
    // MARK: - Public Members -
    
    static let shared = DataManager()
    
    // MARK: - Public Methods -
    
    ///
    /// Searches the *client* database for users matching query.
    ///
    /// This method looks for **all** users with matching *userDatabaseField* value in database. Each user found is appended to an array and returned. This method fails if there is a connection error.
    ///
    /// - warning: This method will not retreive a user that does not have all data required to create *User* object.
    ///
    /// - parameter userDatabaseField: Field to search for match in.
    /// - parameter desiredValue: The value that should be present in specified *userDatabaseField*.
    /// - parameter success: Called when there is no error and users are found/not found. Returns array.
    /// - parameter failure: Called when there is connection error.
    ///
    func getUsers(matching query: [(field: UserDatabaseField, value: String)], success: @escaping ([User]) -> Void, failure: ErrorClosure?) {
        
        fetchAllClients(success: { clients in
            
            var users: [User] = []
           
            searchingUsers: for userRecord in clients {
                print("RECORD  : \(userRecord.value)")
                guard let userInfo = userRecord.value as? [String: Any], let user = User(withSnapshot: userInfo) else { continue }
                
                // Filter users that do not meet conditions
                for condition in query {
                    let actualValue = userInfo[condition.field.rawValue] as? String
                    let expectedValue = condition.value
                    
                    guard actualValue == expectedValue else { continue searchingUsers }
                }
                
                users.append(user)
            }
            
            success(users)
            
        }, failure: failure)
    }
    
    ///
    /// Create a new user with specified credentials.
    ///
    /// - parameter user: The user to update.
    /// - parameter success: Returns user on successful create.
    /// - parameter failure: Failure handler containing error string.
    ///
    func updateAccount(for user: User, success: ((User) -> Void)?, failure: ErrorClosure?) {
        
//        let userPath = Constants.firebaseRootPath.child("clients/\(user.uid)")
        let userPath = Constants.firebaseRootPath.child("Users/\(user.uid)")
        
        BSGFirebaseService.updateData(atPath: userPath, values: user.toSnapshot(), success: {
                success?(user)
        }, failure: {
            failure?("Failed to create user.")
        })
    }
    
    ///
    /// Log user into Facebook and save id and name.
    ///
    /// - parameter success: Handler for successfu login to Facebook.
    /// - parameter failure: Handler for failed login to Facebook.
    ///
    func loginFacebook(success: Closure?, failure: ErrorClosure?) {
        
        BSGFacebookService.login(completion: {
            BSGFacebookService.getUser(completion: { userInfo in
                
                User.current.facebookID = userInfo.id
                User.current.facebookName = userInfo.name
                
                self.updateAccount(for: User.current, success: { _ in
                    success?()
                }, failure: failure)
                
            }, failure: { error in
                failure?("Failed to login to Facebook")
            })
        }, failure: { _ in
            failure?("Failed to login to Facebook")
        })
    }
    
    func loginOrSignupWithFacebook(success: @escaping ([String: Any]) -> Void, failure: ErrorClosure?) {
        
        BSGFacebookService.login(completion: {
            BSGFacebookService.getUserforLoginOrSignup(completion: { userInfo in
//                User.current.facebookID = userInfo.id
//                User.current.facebookName = userInfo.name
//
//                self.updateAccount(for: User.current, success: { _ in
//                    success?()
//                }, failure: failure)
                success(userInfo)
                
            }, failure: { error in
                failure?("Failed to login to Facebook")
            })
        }, failure: { _ in
            failure?("Failed to login to Facebook")
        })
    }
    
    func registerFBOnFirebase(result: [String:Any], completion: @escaping ([String: Any]) -> Void, failure: ErrorClosure?){
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (authResult, err) in
            if let err = err {
                failure?(err.localizedDescription)
            }
            if let userId = authResult?.user.uid {
                let dict:[String:Any] = ["email":"\(result["email"] as! String)",
                "firstname":"\(result["first_name"] as? String ?? "")",
                "lastname":"\(result["last_name"] as? String ?? "")",
                "facebookId":"\(result["id"] as? String ?? "")",
                "image":"\(authResult?.user.photoURL ?? NSURL() as URL)",
                "phone":"\(authResult?.user.phoneNumber ?? "")",
                "userId":"\(userId)"]
                self.createUser(dict: dict, userId: userId)
                completion(dict)
            }
        }
    }
    
    func registerGoogleOnFirebase(user: GIDGoogleUser!, completion: @escaping ([String: Any]) -> Void, failure: ErrorClosure?){
        var firstName:String = ""
        var lastName:String = ""
        let fullName = user.profile.name as String
        var components = fullName.components(separatedBy: " ")
        if(components.count > 0)
        {
             firstName = components.removeFirst()
             lastName = components.joined(separator: " ")
        }
        
        guard let authentication = user.authentication else {
            failure?("Failed to authenticate.")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                failure?(error.localizedDescription)
                return
            }
            
            if let priUserId = authResult?.user.uid {
                let dict:[String:Any] = ["email":"\(user?.profile.email ?? "")",
                    "firstname":"\(firstName)",
                    "lastname":"\(lastName)",
                    "googleId":"\(user?.userID ?? "")",
                    "image":"\(authResult?.user.photoURL ?? NSURL() as URL)",
                    "phone":"\(authResult?.user.phoneNumber ?? "")",
                    "userId":"\(priUserId)"]
                self.createUser(dict: dict, userId: priUserId)
                completion(dict)
            }
        }
    }
    
    private func createUser(dict:Dictionary<String, Any>, userId:String){
        DispatchQueue.main.async {
            let ref:DatabaseReference! = Database.database().reference().child("Users").child(userId)
            
            if let userRef = ref{
                userRef.updateChildValues(dict)
            }
        }
    }
    
    ///
    /// Adds record of game to database.
    ///
    /// - parameter questionType: The type of question answered in game.
    /// - parameter score: The number of points scored in game.
    /// - parameter startTime: The date when game was started.
    /// - parameter completion: Completion handler for either successful or failed creation of game record.
    ///
    func addGameRecord(ofType questionType: QuestionType, score: Int, startTime: Date, completion: Closure?) {
        
        var steps: Int?
        var heartData: HeartData?
        
        HealthKitManager.shared.getStepCountHK(success: { dailySteps in
            steps = dailySteps
            getHeart()
        }, failure: { error in
            getHeart()
        })
        
        func getHeart() {
            FitbitManager.shared.getTodaysHeartData(success: { data in
                heartData = data
                createRecord()
            }, failure: { error in
                createRecord()
            })
        }
        
        func createRecord() {
            
            determineIfShouldAwardGems(completion: { shouldAwardGems in
                
                let endTime = Date.init()
                let location = LocationManager.shared.location
                
                let gameRecord = GameRecord(type: questionType, score: score, startTime: startTime, endTime: endTime, location: location, steps: steps, heartData: heartData, shouldAwardGems: shouldAwardGems)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yy-MM-dd_HH:mm:ss"
                let startTimeString = dateFormatter.string(from: gameRecord.startTime)
                
                let gameSnapshot = gameRecord.toSnapshot()
                
                let gameDataPath = Constants.firebaseRootPath.child("check-yo-self/game-records/\(User.current.uid)/\(startTimeString)")
                
                // Need to update user gems here.
                self.updateAccount(for: User.current, success: nil, failure: nil)
                
                BSGFirebaseService.updateData(atPath: gameDataPath, values: gameSnapshot, success: {
                    completion?()
                }, failure: {
                    completion?()
                })
            })
        }
    }
    
    ///
    /// Gets array of game records from database.
    ///
    /// - parameter user: The user to get records for.
    /// - parameter success: Success handler containing gameRecords.
    /// - parameter failure: Failure handler containing error string.
    ///
    func getGameRecords(forUser user: User, success: (([GameRecord]) -> Void)?, failure: ErrorClosure?) {
        
        BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("check-yo-self/game-records/\(User.current.uid)"), success: { snapshot in
           
            guard let gameRecordSnapshots = snapshot.value as? [String: Any] else {
                success?([])
                return
            }
            
            var gameRecords: [GameRecord] = []
            
            for snapshot in gameRecordSnapshots {
                
                guard let snapshot = snapshot.value as? [String: Any], let gameRecord = GameRecord(withSnapshot: snapshot) else { continue }
                
                gameRecords.append(gameRecord)
            }
            
            success?(gameRecords)
    
        }, failure: {
            failure?("Connection Error.")
        })
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Fetches dictionary of all clients in *clients* database section.
    ///
    /// - parameter success: Returns client dictionary.
    /// - parameter failure: Connection error blocked attempt at reading clients.
    ///
    private func fetchAllClients(success: @escaping ([String: Any]) -> Void, failure: ErrorClosure?) {
        
        /// change 'clients' to 'Users'
        /// All users are now saved to Users database table so fetching users from Users table instead of clients
        
//        BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("clients"), success: { snapshot in
        BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("Users"), success: { snapshot in
            print("all users \(String(describing: snapshot.value))")
            guard let clients = snapshot.value as? [String: Any] else {
                failure?("Connection Error")
                return
            }
            
            success(clients)
            
        }, failure: {
            failure?("Connection Error.")
        })
    }
    
    ///
    /// Determines if gems should be awarded.
    ///
    /// Gems are awarded if the number of plays today are less than the max number of plays per day specified in configuration. The the plays today cannot be detrmines, default to **NOT** awarding gems.
    ///
    /// - parameter completion: Completion handler containing bool indicating if gems should be awarded.
    ///
    private func determineIfShouldAwardGems(completion: BoolClosure?) {
        
        DataManager.shared.getGameRecords(forUser: User.current, success: { gameRecords in
            
            let calendar = Calendar(identifier: .gregorian)
            var dailyPlays = 0
            
            for game in gameRecords where calendar.isDateInToday(game.endTime) {
                dailyPlays += 1
            }
            
            let shouldAwardGems = dailyPlays < GameConfiguration.playsPerDay
            completion?(shouldAwardGems)
            
        }, failure: { _ in
            completion?(false)
        })
    }

}

// MARK: - Extension: Local -

extension DataManager {
    
    ///
    /// Get value stored in Userefaults.
    ///
    /// - parameter localTypeType: The type of value to save.
    ///
    func getLocalValue(for localDataType: LocalData) -> String? {
        return UserDefaults.standard.value(forKey: localDataType.rawValue) as? String
    }
    
    ///
    /// Saves the specified value for specified data type in UserDefaults.
    ///
    /// - parameter value: The value to save.
    /// - parameter localTypeType: The type of value to save.
    ///
    func saveLocalValue(_ value: String, for localDataType: LocalData) {
        UserDefaults.standard.set(value, forKey: localDataType.rawValue)
    }
}
