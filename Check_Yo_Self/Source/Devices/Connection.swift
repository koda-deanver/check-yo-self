//********************************************************************
//  Connection.swift
//  Check Yo Self
//  Created by Phil on 3/8/17
//
//  Description: Used to make loading data for connections easier. Handles
// all connection with external data.
//********************************************************************

import Foundation

import FacebookLogin
import FacebookCore
import CoreLocation

class Connection: NSObject{
    let type: ConnectionType
    var isConnected: Bool?

    init(type: ConnectionType){
        self.type = type
    }
    
    func checkConnection(){
        switch self.type{
        case .cube:
            self.isConnected = false
        case .facebook:
            if AccessToken.current != nil{
                self.isConnected = true
            }else{
                self.isConnected = false
            }
        case .health:
            PlayerData.sharedInstance.getStepCountHK(completion: {_ in
                self.isConnected = true
            }, failure: {_ in
                self.isConnected = false
            })
        case .fitbit:
            PlayerData.sharedInstance.getHeartRateFB(completion: {_ in
                self.isConnected = true
            }, failure: {errorType in
                switch errorType{
                case .data:
                    self.isConnected = true
                default:
                    self.isConnected = false
                }
            })
        case .maps:
            if PlayerData.sharedInstance.getLocation() != nil{
                self.isConnected = true
            }else{
                self.isConnected = false
            }
        default:
            break
            
        }
    }
}
