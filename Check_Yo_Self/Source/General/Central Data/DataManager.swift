//
//  DataManager.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 1/18/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

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
    func getUsers(matching query: [(field: UserDatabaseField, value: String)], success: @escaping ([User]) -> Void, failure: @escaping (String) -> Void) {
        
        fetchAllClients(success: { clients in
            
            var users: [User] = []
           
            searchingUsers: for userRecord in clients {
                
                guard let userInfo = userRecord.value as? [String: Any], let user = User(withUserInfo: userInfo) else { continue }
                
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
    /// - parameter success: Returns user on successful create.
    /// - parameter failure: Failure handler containing error string.
    ///
    func updateAccount(for user: User, success: ((User) -> Void)?, failure: ErrorClosure?) {
        
        let userPath = Constants.firebaseRootPath.child("clients/\(user.username)")
        
        let profile: [String: Any] = [
            UserDatabaseField.favoriteColor.rawValue : "\(user.favoriteColor.rawValue)",
            UserDatabaseField.ageGroup.rawValue : "\(user.ageGroup.rawValue)",
            UserDatabaseField.favoriteGenre.rawValue : "\(user.favoriteGenre.rawValue)",
            UserDatabaseField.identity.rawValue : "\(user.identity.rawValue)"
        ]
        
        var values: [String: Any] = [
            UserDatabaseField.username.rawValue : "\(user.username)",
            UserDatabaseField.password.rawValue : "\(user.password)",
            "profile": profile
        ]
        
        // Add facebook info if present.
        if let facebookID = user.facebookID, let facebookName = user.facebookName {
            values[UserDatabaseField.facebookID.rawValue] = "\(facebookID)"
            values[UserDatabaseField.facebookName.rawValue] = "\(facebookName)"
        }
        
        BSGFirebaseService.updateData(atPath: userPath, values: values, success: {
                success?(user)
        }, failure: {
            failure?("Failed to create user.")
        })
    }
    
    ///
    /// Get questions of specified type from database.
    ///
    /// - parameter success: Handler for successful load of questions.
    /// - parameter failure: Handler for failure to get questions.
    ///
    func getQuestions(ofType questionType: QuestionType, success: @escaping ([Question]) -> Void, failure: @escaping ErrorClosure) {
        
        let path = Constants.firebaseRootPath.child("questions/\(questionType.databaseNode)")
        
        BSGFirebaseService.fetchData(atPath: path, success: { snapshot in
            print(snapshot)
            guard let questionSnapshots = snapshot.value as? [[String: Any]] else {
                failure("Connection Error")
                return
            }
            
            var questions: [Question] = []
            
            for snapshot in questionSnapshots {
                guard let question = Question(withSnapshot: snapshot, type: questionType) else { continue }
                questions.append(question)
            }
            
            success(questions)
            
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
    
    // MARK: - Private Methods -
    
    ///
    /// Fetches dictionary of all clients in *clients* database section.
    ///
    /// - parameter success: Returns client dictionary.
    /// - parameter failure: Connection error blocked attempt at reading clients.
    ///
    private func fetchAllClients(success: @escaping ([String: Any]) -> Void, failure: @escaping (String) -> Void) {
        
        BSGFirebaseService.fetchData(atPath: Constants.firebaseRootPath.child("clients"), success: { snapshot in
            
            guard let clients = snapshot.value as? [String: Any] else {
                failure("Connection Error")
                return
            }
        
            success(clients)
            
        }, failure: {
            failure("Connection Error.")
        })
    }

}
