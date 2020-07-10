//
//  OuraAPI.swift
//  check-yo-self
//
//  Created by AA10 on 03/07/2020.
//  Copyright © 2020 ThematicsLLC. All rights reserved.
//

import UIKit

class OuraAPI {
    
    static let sharedInstance: OuraAPI = OuraAPI()
    
    static let baseAPIURL = URL(string:"https://api.ouraring.com")
    
    func authorize(with token: String) {
        let sessionConfiguration = URLSessionConfiguration.default
        var headers = sessionConfiguration.httpAdditionalHeaders ?? [:]
        headers["Authorization"] = "Bearer \(token)"
        sessionConfiguration.httpAdditionalHeaders = headers
        session = URLSession(configuration: sessionConfiguration)
    }
    
    var session: URLSession?
}
