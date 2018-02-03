//********************************************************************
//  ConnectionAlert.swift
//  Who Dat
//  Created by Phil on 3/7/17
//
//  Description: Hold data to show in alert
//********************************************************************

import Foundation

class ConnectionAlert: NSObject{
    let title: String
    var connectionStatus: ConnectionStatus?
    let message: String
    let okButtonText: String
    let cancelButtonText: String?
    let okButtonCompletion: () -> Void
    let cancelButtonCompletion: () -> Void
    
    init(title: String, connectionStatus: ConnectionStatus? = nil, message: String, okButtonText: String, cancelButtonText: String? = nil, okButtonCompletion: @escaping () -> Void = {}, cancelButtonCompletion: @escaping () -> Void = {}){
        self.title = title
        self.connectionStatus = connectionStatus
        self.message = message
        self.okButtonText = okButtonText
        self.cancelButtonText = cancelButtonText
        self.okButtonCompletion = okButtonCompletion
        self.cancelButtonCompletion = cancelButtonCompletion
    }
}
