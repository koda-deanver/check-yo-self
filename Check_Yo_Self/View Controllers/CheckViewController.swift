//********************************************************************
//  LoginViewController.swift
//  Check Yo Self
//  Created by Phil on 1/19/17
//
//  Description: Used to force a Check phase on the tab bar
//********************************************************************

import UIKit

class CheckViewController: GeneralViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //********************************************************************
    // viewDidLoad
    // Description: Update users profile and force profile questions for
    // a new user
    //********************************************************************
    override func viewDidAppear(_ animated: Bool) {
        // Switch to check phase
        PlayerData.sharedInstance.runCheckOnce = true
        // Go to Play Tab
        self.tabBarController?.selectedIndex = 1
        /*if PlayerData.sharedInstance.tutorialDictionary["MeetUpTutorialVideo"] == nil{
            PlayerData.sharedInstance.tutorialDictionary["MeetUpTutorialVideo"] = false
            let videoURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "MettUpTutorialVideo", ofType:"mp4")!)
            VideoBase.playVideo(url: videoURL, onController: self)
        }*/
    }

}
