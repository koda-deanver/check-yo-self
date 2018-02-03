//********************************************************************
//  FitbitAPI.swift
//  Check Yo Self
//  Added by Phil on 12/2016
//
//  Description: Authenticate Fitbit
//
//  Credit to Ryan LaSante
//********************************************************************

import UIKit

class FitbitAPI {
	
	static let sharedInstance: FitbitAPI = FitbitAPI()
	
	static let baseAPIURL = URL(string:"https://api.fitbit.com/1")
	
	func authorize(with token: String) {
		let sessionConfiguration = URLSessionConfiguration.default
		var headers = sessionConfiguration.httpAdditionalHeaders ?? [:]
		headers["Authorization"] = "Bearer \(token)"
		sessionConfiguration.httpAdditionalHeaders = headers
		session = URLSession(configuration: sessionConfiguration)
	}
	
	var session: URLSession?
}
