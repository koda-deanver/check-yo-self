//********************************************************************
//  Media.swift
//  Check Yo Self
//  Created by Phil on 1/10/17
//
//  Description: Holds image sets and text loaded by App
//********************************************************************

import Foundation
import AVFoundation
import AVKit

final class Media{
    
    static var boomBox: AVAudioPlayer?
    
    // Messages to be displayed by slider on Map Screen
    static let progressAlertMessages: [CreationPhase: [String]] = [
        .none: ["let us know about your personal physical rhythms", "let us know about your personal physical rhythms", "let us know about your personal relationship to the sun", "let us know about your personal physical practices"],
        .check: ["explore your condition walking in to the meeting", "explore your feelings about your creative contribution", "help you examine your surroundings", "help you examine your fellow CollabRaters"],
        .brainstorm: ["push the boundries of your surroundings", "push the boundries of your team", "push the boundries of yourself", "explore ways to place your BRAINSTORMS into DEVELOPMENT"],
        .develop: ["expand the teams' ideas", "expand your ideas", "stretch the definition and boundries of the project", "explore ways to develop your product and to get you ready to ALLIGN"],
        .align: ["group the teams' ideas into buckets", "prioritize the buckets using your stated reasoning", "stretch the definition and boundries of the project", "explore ways to allign your game and get you closer to IMPROVING"],
        .improve: ["explore ways to improve your ultimate product", "explore ways to improve your progress towards the MAKING", "explore ways to improve your self worth", "explore ways to improve your team's confidence too"],
        .make: [ "help you assess your product", "help CollabRjabbR assess your product", "relate your product to your personal stated goal", "relate your goal to your team's stated goal"]
    ]
}

