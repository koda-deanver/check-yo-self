//
//  CubeViewController.swift
//  check-yo-self
//
//  Created by Phil Rattazzi on 12/9/16.
//  Copyright © 2016 ThematicsLLC. All rights reserved.
//

import UIKit
import MapKit
import Firebase

/// Acts as home screen for the app.
class CubeViewController: SkinnedViewController {
    
    /// Determines whether to show video.
    var newPlayer = false
    
    // MARK: - Outlets -
    
    @IBOutlet weak var titleLogo: UIImageView!
    
    // Main cube
    @IBOutlet weak var cubeFace: UIImageView!
    @IBOutlet weak var userPic: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phaseImage: UIImageView!
    
    /// Button that launches knowledge base screen.
    @IBOutlet weak var knowledgeBaseButton: UIButton!
    /// Button that launches profile screen.
    @IBOutlet weak var profileButton: UIButton!
    /// Button that launches friend list screen.
    @IBOutlet weak var friendsButton: UIButton!
    /// Button that launches connections screen.
    @IBOutlet weak var connectionsButton: UIButton!
    
    @IBOutlet weak var gemLabel: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - Lifecycle -
    
    override func style() {
        setupButtons()
    }
    
    ///
    /// Style button with correct images and color.
    ///
    private func setupButtons() {
        
        let buttons = [knowledgeBaseButton, profileButton, friendsButton, connectionsButton]
        let buttonImages = [#imageLiteral(resourceName: "KnowledgeBaseIcon"), #imageLiteral(resourceName: "ProfileIcon"), #imageLiteral(resourceName: "FriendsIcon"), #imageLiteral(resourceName: "ConnectionsIcon")]
        
        for (index, button) in buttons.enumerated() {
            
            guard let button = button else { continue }
            button.setBackgroundImage(User.current.favoriteColor.connectionBackdrop, for: .normal)
            
            let inset = button.frame.width * 0.1
            button.setImage(buttonImages[index], for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
        }
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
    
    /// Can't do this in storyboard because of double segue.
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
        guard let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as? ProfileViewController else { return }
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: profileViewController, action: #selector(profileViewController.exit))
        profileViewController.navigationItem.setLeftBarButton(backButton, animated: false)
        profileViewController.shouldPreloadChoices = true
        
        let navigationController = UINavigationController(rootViewController: profileViewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
    }
}
