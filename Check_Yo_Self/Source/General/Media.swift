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
    
    // Logos on top of Cube screen
    static let titleLogos: [UIImage] = [#imageLiteral(resourceName: "CheckYoSelf"), #imageLiteral(resourceName: "EasternConnState"), #imageLiteral(resourceName: "Usdan"), #imageLiteral(resourceName: "Gantom"), #imageLiteral(resourceName: "HIker"), #imageLiteral(resourceName: "Lightbox")]
    
    // Colored Images
    static let coloredButtonList: [UIImage] = [#imageLiteral(resourceName: "GameButtonGray"), #imageLiteral(resourceName: "GameButtonRed"), #imageLiteral(resourceName: "GameButtonGreen"), #imageLiteral(resourceName: "GameButtonBlue"), #imageLiteral(resourceName: "GameButtonCyan"), #imageLiteral(resourceName: "GameButtonMagenta"), #imageLiteral(resourceName: "GameButtonYellow")]
    static let alertBackdropList: [UIImage] = [#imageLiteral(resourceName: "AlertBackdropGray"), #imageLiteral(resourceName: "AlertBackdropRed"), #imageLiteral(resourceName: "AlertBackdropGreen"), #imageLiteral(resourceName: "AlertBackdropBlue"), #imageLiteral(resourceName: "AlertBackdropCyan"), #imageLiteral(resourceName: "AlertBackdropMagenta"), #imageLiteral(resourceName: "AlertBackdropYellow")]
    static let loadingSymbolList: [UIImage] = [#imageLiteral(resourceName: "LoadingSymbolRainbow"), #imageLiteral(resourceName: "LoadingSymbolRed"), #imageLiteral(resourceName: "LoadingSymbolGreen"), #imageLiteral(resourceName: "LoadingSymbolBlue"), #imageLiteral(resourceName: "LoadingSymbolCyan"), #imageLiteral(resourceName: "LoadingSymbolMagenta"), #imageLiteral(resourceName: "LoadingSymbolYellow")]
    static let connectionBackdropList: [UIImage] = [#imageLiteral(resourceName: "ConnectionBackdropGray"), #imageLiteral(resourceName: "ConnectionBackdropRed"), #imageLiteral(resourceName: "ConnectionBackdropGreen"), #imageLiteral(resourceName: "ConnectionBackdropBlue"), #imageLiteral(resourceName: "ConnectionBackdropCyan"), #imageLiteral(resourceName: "ConnectionBackdropMagenta"), #imageLiteral(resourceName: "ConnectionBackdropYellow")]
    
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
    
    // Females 0-5 Males 6-11 Freeform 12-13
    static let avatarList: [Avatar] = [
        // Female
        Avatar(#imageLiteral(resourceName: "Zida_Architect"), name: "Zida", identity: .female, discipline: "Architect", bio: "Zida identifies as Female and primarily plays in the REAL Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "ChelseaClinton_Philanthropist"), name: "Chelsea Clinton", identity: .female, discipline: "Philanthropist", bio: "Chelsea identifies as Female and primarily plays in the SELL Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "Beyonce_Publisher"), name: "Beyonce", identity: .female, discipline: "Publisher", bio: "Beyonce identifies as Female and primarily plays in the LIVE Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "AliceWaters_Foodie"), name: "Alice Waters", identity: .female, discipline: "Foodie", bio: "Alice identifies as Female and primarily plays in the FOOD Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "AliLew_Gamer"), name: "Ali Lew", identity: .female, discipline: "Gamer", bio: "Ali identifies as Female and primarily plays in the PUBS Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "TinaFey_Writer"), name: "Tina Fey", identity: .female, discipline: "Writer", bio: "Tina as Female and primarily plays in the LENSED Genre of CollabRation"),
        
        // Male
        Avatar(#imageLiteral(resourceName: "CRMacintosh_Architect"), name: "CR Macintosh", identity: .male, discipline: "Architect", bio: "Charles identifies as Male and primarily plays in the REAL Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "ChadGutstein_Machinima"), name: "Chad Gutstein", identity: .male, discipline: "Machinima", bio: "Chad identifies as Male and primarily plays in the SELL Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "OskarEustice_Storyteller"), name: "Oscar Eustice", identity: .male, discipline: "Storyteller", bio: "Oskar identifies as Male and primarily plays in the LIVE Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "DannyMeyer_Restauranteur"), name: "Danny Meyer", identity: .male, discipline: "Restauranteur", bio: "Danny identifies as Male and primarily plays in the FOOD Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "TylerOakley_Publisher"), name: "Tyler Oakley", identity: .male, discipline: "Publisher", bio: "Tyler identifies as Male and primarily plays in the PUBS Genre of CollabRation"),
        Avatar(#imageLiteral(resourceName: "AaronSorkin_Screenwriter"), name: "Aaron Sorkin", identity: .male, discipline: "Screenwriter", bio: "Aaron Sorkin identifies as Male and primarily plays in the LENSED Genre of CollabRation"),
        
        // Freeform
        Avatar(#imageLiteral(resourceName: "Freeform1"), name: "Female Avatar", identity: .female, discipline: "", bio: ""),
        Avatar(#imageLiteral(resourceName: "Freeform2"), name: "Male Avatar", identity: .male, discipline: "", bio: "")
    ]
}

