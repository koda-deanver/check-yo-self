//
//  CubeViewController.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 12/9/16.
//  Copyright © 2016 ThematicsLLC. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications
import Firebase

/// Acts as home screen for the app.
class CubeViewController: GeneralViewController, PickAvatarViewControllerDelegate{
    
    /// Determines whether to show video.
    var newPlayer = false
    
    @IBOutlet weak var titleLogo: UIImageView!
    
    // Main cube
    @IBOutlet weak var cubeFace: UIImageView!
    @IBOutlet weak var userPic: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phaseImage: UIImageView!
    
    
    // Small buttons
    @IBOutlet weak var knowledgeBaseButton: UIButton!
    @IBOutlet weak var connectionsButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var gemLabel: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Add images to buttons
        /*let buttonImageDictionary: [UIButton: UIImage] = [
            knowledgeBaseButton: #imageLiteral(resourceName: "KnowledgeBaseIcon"),
            connectionsButton: #imageLiteral(resourceName: "ConnectionsIcon"),
            friendsButton: #imageLiteral(resourceName: "FriendsIcon"),
            profileButton: #imageLiteral(resourceName: "ProfileIcon")
        ]
        for (button, image) in buttonImageDictionary{
            let topImage = UIImageView(frame: CGRect(x: 0, y: 0, width: button.frame.width * 0.7, height: button.frame.height * 0.7))
            topImage.center = CGPoint(x: button.frame.width/2, y: button.frame.height/2)
            topImage.image = image
            button.addSubview(topImage)
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if newPlayer {
            let videoURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "AppTutorialVideo", ofType:"mp4")!)
            BSGCommon.playVideo(url: videoURL, onController: self)
            newPlayer = false
        }
        
        updateCubeProfile()
    }
    
    //********************************************************************
    // handleSwipe
    // Description: Control phase changing by swipe
    //********************************************************************
    func handleSwipe(sender: UISwipeGestureRecognizer){
        let currentIndex = Int(Media.titleLogos.index(of: self.titleLogo!.image!)!)
        print(currentIndex)
        if sender.direction == .left{
            let newIndex = BSGCommon.incrementValue(currentIndex, by: 1, max: Media.titleLogos.count - 1)
            print(newIndex)
            self.titleLogo.image = Media.titleLogos[newIndex]
        }else if sender.direction == .right{
            let newIndex = BSGCommon.incrementValue(currentIndex, by: -1, max: Media.titleLogos.count - 1)
            print(newIndex)
            self.titleLogo.image = Media.titleLogos[newIndex]
        }else{
            print("Invalid swipe")
        }
    }
    
    ///
    /// Reloads entire screen.
    ///
    /// This is used when a player changes something about thier profile, or when a relevant stat changes.
    ///
    func updateCubeProfile(){
        
        /*let playerColor = User.current.favoriteColor
        
        usernameLabel.text = User.current.username
        self.gemLabel.setTitle(String(format: "%d",PlayerData.sharedInstance.gemTotal), for: UIControlState.normal)
        
        self.gemLabel.setTitleColor(UIColor.white, for: .normal)
        
        // Phase Image
        if PlayerData.sharedInstance.creationPhase != .none{
            self.phaseImage.image = UIImage(named: PlayerData.sharedInstance.creationPhase.rawValue)
        }
        
        // Avatar
        if let facebookImageData = PlayerData.sharedInstance.facebookImageData{
            let facebookImage = UIImage(data: facebookImageData as Data)
            self.userPic.setImage(facebookImage, for: .normal)
            self.userPic.layer.cornerRadius = userPic.frame.height * 0.4
            self.userPic.layer.masksToBounds = true
        }else{
            // Assign avatar based on profile questions
            if let avatar = PlayerData.sharedInstance.avatar{
                self.userPic.setImage(avatar.image, for: .normal)
            }
        }
        
        // Backdrop
        //self.cubeFace.image = Media.alertBackdropList[playerColor.intValue()]
        
        // Small Buttons
        /*self.knowledgeBaseButton.setImage(Media.connectionBackdropList[playerColor.intValue()], for: .normal)
        self.connectionsButton.setImage(Media.connectionBackdropList[playerColor.intValue()], for: .normal)
        self.friendsButton.setImage(Media.connectionBackdropList[playerColor.intValue()], for: .normal)
        self.profileButton.setImage(Media.connectionBackdropList[playerColor.intValue()], for: .normal)*/
        
        // Play Button
        /*switch self.appSkin!{
        case .adult:
            self.playButton.setImage(#imageLiteral(resourceName: "PlayButtonWhite"), for: .normal)
        case .child:
            self.playButton.setImage(#imageLiteral(resourceName: "PlayButtonBlack"), for: .normal)
        }*/*/
    }
    
}

extension CubeViewController{
    func pickAvatarViewController(_ controller: PickAvatarViewController, didFinishChoosing avatar: Avatar) {
        PlayerData.sharedInstance.avatar = avatar
        self.dismiss(animated: true)
    }
    
    func pickAvatarViewControllerDidCancel(_ controller: PickAvatarViewController) {
        self.dismiss(animated: true)
    }
}

// MARK: - Extension: Actions -

extension CubeViewController {
    
    @IBAction func friendsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showFriendList", sender: self)
    }
    
    @IBAction func userPicPressed(_ sender: UIButton) {
        // Show alert if player has an avatar
        if let avatar = PlayerData.sharedInstance.avatar{
            /*self.showConnectionAlert(ConnectionAlert(title: "\(avatar.name)\nOccupation: \(avatar.discipline)", message: "\(avatar.bio)", okButtonText: "Keep", cancelButtonText: "Change", okButtonCompletion: {
             
             }, cancelButtonCompletion: {
             let pickAvatarNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PickAvatarNavigation") as! UINavigationController
             let pickAvatarViewController = pickAvatarNavigationController.viewControllers[0] as! PickAvatarViewController
             pickAvatarViewController.delegate = self
             pickAvatarViewController.oldAvatar = avatar
             self.present(pickAvatarNavigationController, animated: true)
             }))*/
        }
    }
    
    @IBAction func gemLabelPressed(_ sender: UIButton) {
        //print(QuestionStorage.sharedInstance)
        // Show Gem Alert
        /*self.showConnectionAlert(ConnectionAlert(title: "JabbRGems", message: "To reddem JabbRGems for ColLAB GEAR go to CollabRjabbR.com in the Membership Marketplace or just click the K button below!", okButtonText: "Cool"))*/
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        // TODO: Launch profile screen
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        //PlayerData.sharedInstance.runCheckOnce = true
        //self.tabBarController?.selectedIndex = 1
    }
}
