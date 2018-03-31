//
//  CubeViewController.swift
//  check-yo-self
//
//  Created by phil on 12/9/16.
//  Copyright © 2016 ThematicsLLC. All rights reserved.
//

import UIKit

/// Acts as home screen for the app.
final class CubeViewController: SkinnedViewController {
    
    // MARK: - Public Members -
    
    /// Determines whether to show video.
    var newPlayer = false
    
    // MARK: - Outlets -
    
    // Cube Projects
    @IBOutlet private weak var cubeProjectsLabel: UILabel!
    
    // Stats
    @IBOutlet private weak var gemLabel: UILabel!
    
    // Main cube
    @IBOutlet private weak var userBackdrop: UIImageView!
    @IBOutlet private weak var userImage: UIButton!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var phaseImage: UIImageView!
    
    /// Button that launches knowledge base screen.
    @IBOutlet private weak var knowledgeBaseButton: UIButton!
    /// Button that launches profile screen.
    @IBOutlet private weak var profileButton: UIButton!
    /// Button that launches friend list screen.
    @IBOutlet private weak var friendsButton: UIButton!
    /// Button that launches connections screen.
    @IBOutlet private weak var connectionsButton: UIButton!
    
    // Bottom buttons
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var checkButton: UIButton!
    
    // MARK: - Lifecycle -
    
    override func style() {
        
        super.style()
        
        cubeProjectsLabel.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        
        gemLabel.font = UIFont(name: Font.pure, size: Font.largeSize)
        gemLabel.textColor = User.current.favoriteColor.uiColor
        
        userBackdrop.image = User.current.favoriteColor.alertBackdrop
        
        let avatar = AvatarManager.shared.getAvatar(for: User.current)
        let image = CameraManager.shared.savedImage ?? avatar.image
        userImage.setImage(image, for: .normal)
        
        userLabel.text = User.current.displayName
        userLabel.font = UIFont(name: Font.heavy, size: Font.largeSize)
        
        checkButton.titleLabel?.font = UIFont(name: Font.heavy, size: Font.largeSize)
        logoutButton.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        
        setupMiniButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        gemLabel.text = String(User.current.gems)
        if newPlayer { playVideo() }
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Sets up and styles *knowledgeBaseButton*, *profileButton*, *friendsButton*, and *connectionsButton*.
    ///
    private func setupMiniButtons() {
        
        let buttons = [knowledgeBaseButton, profileButton, friendsButton, connectionsButton]
        let buttonImages = [#imageLiteral(resourceName: "knowledge-base-icon"), #imageLiteral(resourceName: "profile-icon"), #imageLiteral(resourceName: "friends-icon"), #imageLiteral(resourceName: "connections-icon")]
        
        for (index, button) in buttons.enumerated() {
            
            guard let button = button else { continue }
            button.setBackgroundImage(User.current.favoriteColor.connectionBackdrop, for: .normal)
            
            let inset = button.frame.width * 0.1
            button.setImage(buttonImages[index], for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
        }
    }
    
    ///
    /// Plays introduction video presented by Sir Charles Kirby.
    ///
    private func playVideo() {
        
        let videoURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "welcome", ofType:"mp4")!)
        BSGCommon.playVideo(url: videoURL, onController: self)
        newPlayer = false
    }
}

// MARK: - Extension: Actions -

extension CubeViewController {
    
    @IBAction func cubeProjectButtonPressed(_ sender: UIButton) {
        showAlert(BSGCustomAlert(message: "Cube projects coming soon."))
    }
    
    @IBAction func gemHitboxPressed(_ sender: UIButton) {
        showAlert(BSGCustomAlert(message: "To redeem JabbRGems go to CollabRJabbR.com or tap the K button below!", options: [(text:"Sweet!", handler: {})]))
    }
    
    @IBAction func userImagePressed(_ sender: UIButton) {
        let avatar = AvatarManager.shared.getAvatar(for: User.current)
        showAlert(BSGCustomAlert(message: avatar.bio))
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
    
    @IBAction func friendsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showFriendList", sender: self)
    }
    
    @IBAction func knowledgeBaseButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showKnowledgeBase", sender: self)
    }
    
    @IBAction func connectionsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showConnections", sender: self)
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        guard let viewController = tabBarController?.viewControllers?[1] as? QuestionsViewController else { return }
        viewController.isCheckYoSelfGame = true
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        
        let logoutAlert = BSGCustomAlert(message: "Logout of Check Yo Self?", options: [(text: "Logout", handler: {
            User.current = nil
            self.dismiss(animated: true, completion: nil)
        }),(text: "Cancel", handler: {})])
        
        showAlert(logoutAlert)
    }
}
