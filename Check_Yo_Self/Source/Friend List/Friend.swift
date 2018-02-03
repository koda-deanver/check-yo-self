//********************************************************************
//  Friend.swift
//  Check Yo Self
//  Created by Phil on 3/26/17
//
//  Description: Store data for a facebook friend
//********************************************************************

import Foundation

class Friend: NSObject {
    
    let facebookID: String
    let facebookName: String
    let facebookImageData: NSData?
    
    init(_ facebookID: String, facebookName: String, facebookImageData: NSData?){
        self.facebookID = facebookID
        self.facebookName = facebookName
        self.facebookImageData = facebookImageData
    }
    
    override var description: String{
        let descriptionString = "Name: \(facebookName)\n"
        return descriptionString
    }
}
