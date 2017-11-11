//********************************************************************
//  CubeViewController.swift
//  Check Yo Self
//  Created by Phil on 12/9/16
//
//  Description: Main screen displaying user profile info and total gems
//  as well as other relevant information.
//********************************************************************

import UIKit
import MapKit
import UserNotifications
import Firebase

class CubeViewController: GeneralViewController, PickAvatarViewControllerDelegate{
    
    var checkAlertShown = false
    var token: String?
    var newPlayer: Bool?
    
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
    //********************************************************************
    // Action: profileButtonPressed
    // Description: Allow user to retake profile questions
    //********************************************************************
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        PlayerData.sharedInstance.creationPhase = .none
        PlayerData.sharedInstance.avatar = nil
        print(PlayerData.sharedInstance.creationPhase.rawValue)
        self.tabBarController?.selectedIndex = 1
        self.tabBarController?.setTabsActive(false)
    }
    
    //********************************************************************
    // Action: userPicPressed
    // Description: User tapped on avatar
    //********************************************************************
    @IBAction func userPicPressed(_ sender: UIButton) {
        // Show alert if player has an avatar
        if let avatar = PlayerData.sharedInstance.avatar{
            self.showConnectionAlert(ConnectionAlert(title: "\(avatar.name)\nOccupation: \(avatar.discipline)", message: "\(avatar.bio)", okButtonText: "Keep", cancelButtonText: "Change", okButtonCompletion: {
                
            }, cancelButtonCompletion: {
                let pickAvatarNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PickAvatarNavigation") as! UINavigationController
                let pickAvatarViewController = pickAvatarNavigationController.viewControllers[0] as! PickAvatarViewController
                pickAvatarViewController.delegate = self
                pickAvatarViewController.oldAvatar = avatar
                self.present(pickAvatarNavigationController, animated: true)
            }))
        }
    }
    
    //********************************************************************
    // Action: gemLabelPressed
    // Description: Display alert explaining gems
    //********************************************************************
    @IBAction func gemLabelPressed(_ sender: UIButton) {
        print(QuestionStorage.sharedInstance)
        // Show Gem Alert
        self.showConnectionAlert(ConnectionAlert(title: "JabbRGems", message: "To reddem JabbRGems for ColLAB GEAR go to CollabRjabbR.com in the Membership Marketplace or just click the K button below!", okButtonText: "Cool"))
    }
    
    //********************************************************************
    // Action: playButtonPressed
    // Description: Second way of reaching Play screen other than tab bar
    //********************************************************************
    @IBAction func playButtonPressed(_ sender: UIButton) {
        PlayerData.sharedInstance.runCheckOnce = true
        self.tabBarController?.selectedIndex = 1
    }
    
    //********************************************************************
    // viewDidLoad
    // Description:
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request permission for push notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]){
            (granted, error) in
            if granted{
                print("Permission for notifications granted")
                //self.loadNotificationData()
            }else{
                if let error = error{
                    print(error.localizedDescription)
                }
            }
        }
        
        // Set up gesture recognizers
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(CubeViewController.handleSwipe(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CubeViewController.handleSwipe(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        // Add images to buttons
        let buttonImageDictionary: [UIButton: UIImage] = [
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
        }
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
    
    //********************************************************************
    // viewDidLoad
    // Description: Update users profile and force profile questions for
    // a new user
    //********************************************************************
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(PlayerData.sharedInstance.creationPhase == .none){
            if let newPlayer = self.newPlayer, newPlayer == true{
                self.newPlayer = false
                let videoURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "AppTutorialVideo", ofType:"mp4")!)
                BSGCommon.playVideo(url: videoURL, onController: self)
            }else{
                // Show Profile Questions Alert
                self.showConnectionAlert(ConnectionAlert(title: "Hey \(PlayerData.sharedInstance.displayName)!", message: "This series of questions will hopefully help personalize your experience.", okButtonText: "Start", okButtonCompletion: {
                    self.tabBarController?.setTabsActive(false)
                    self.tabBarController?.selectedIndex = 1
                }))
            }
        // Creation Phase not .none
        }else if !self.checkAlertShown{
            self.checkAlertShown = true
            // Show Profile Questions Alert on log in
            self.showConnectionAlert(ConnectionAlert(title: "Hey \(PlayerData.sharedInstance.displayName)!", message: "Don't forget to Check Yo Self", okButtonText: "Right On"))
        }
        updateCubeProfile()
    }
    
    //********************************************************************
    // updateCubeProfile
    // Description: Update all labels and pictures when screen is loaded
    //********************************************************************
    func updateCubeProfile(){
        let playerColor = PlayerData.sharedInstance.cubeColor
        // Name and gems
        self.usernameLabel.text = PlayerData.sharedInstance.displayName
        self.gemLabel.setTitle(String(format: "%d",PlayerData.sharedInstance.gemTotal), for: UIControlState.normal)
        
        switch self.appSkin!{
        case .adult:
            self.gemLabel.setTitleColor(UIColor.white, for: .normal)
        case .child:
            self.gemLabel.setTitleColor(UIColor.black, for: .normal)
        }
        
        
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
        self.cubeFace.image = Media.alertBackdropList[playerColor.intValue()]
        
        // Small Buttons
        self.knowledgeBaseButton.setImage(Media.connectionBackdropList[playerColor.intValue()], for: .normal)
        self.connectionsButton.setImage(Media.connectionBackdropList[playerColor.intValue()], for: .normal)
        self.friendsButton.setImage(Media.connectionBackdropList[playerColor.intValue()], for: .normal)
        self.profileButton.setImage(Media.connectionBackdropList[playerColor.intValue()], for: .normal)
        
        // Play Button
        switch self.appSkin!{
        case .adult:
            self.playButton.setImage(#imageLiteral(resourceName: "PlayButtonWhite"), for: .normal)
        case .child:
            self.playButton.setImage(#imageLiteral(resourceName: "PlayButtonBlack"), for: .normal)
        }
    }
    
    //********************************************************************
    // shouldPerformSegue(withIdentifier)
    // Description: Decide whether to launch segue
    //********************************************************************
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier{
            case "ShowFriendList":
                guard PlayerData.sharedInstance.facebookID != nil else{
                    self.showConnectionAlert(ConnectionAlert(title: "No Facebook Friends", message: "Log in to Facebook on the Connection page to see your friend list.", okButtonText: "OK", okButtonCompletion: {
                        _ in
                        
                    }))
                    return false
                }
            default:
                break
        }
        return true
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
