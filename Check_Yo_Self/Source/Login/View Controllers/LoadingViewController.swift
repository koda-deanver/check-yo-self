//
//  LoadingViewController.swift
//  check-yo-self
//
//  Created by phil on 1/19/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit
import Firebase

/// Displays loading animation.
final class LoadingViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    @IBOutlet weak var loadingGif: UIImageView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animation and sound
        self.loadingGif.image = UIImage.gifImageWithName(name: "logo-shake")
        BSGCommon.playSound("chorus-instrumental", ofType: "mp3")
        
        // Authorize firebase
        Auth.auth().signInAnonymously(){
            user, error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
