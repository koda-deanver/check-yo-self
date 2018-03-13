//********************************************************************
//  PlayerData.swift
//  Check Yo Self
//  Created by Phil on 3/8/17
//
//  Description: Hold all enumerations
//********************************************************************

import Foundation

// The phases of Collabration
enum CreationPhase: String{
    case check = "Check"
    case brainstorm = "Brainstorm"
    case develop = "Develop"
    case align = "Align"
    case improve = "Improve"
    case make = "Make"
    case none = "Profile"
}

// Possible errors to handle
enum ErrorType{
    case question(String)
    case connection(Error)
    case permissions(String)
    case data(String)
}
