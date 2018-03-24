//
//  SyncingViewController.swift
//  check-yo-self
//
//  Created by phil on 1/19/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit
import Firebase

/// Displays loading animation.
final class SyncingViewController: GeneralViewController {
    
    // MARK: - Private Members -
    
    @IBOutlet private weak var gif: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Animation and sound
        self.gif.image = UIImage.gifImageWithName(name: "logo-shake")
        BSGCommon.playSound("chorus-instrumental", ofType: "mp3")
        
        label.font = UIFont(name: Font.heavy, size: Font.largeSize)
        
        loadConfiguration() {
            BSGCommon.stopSound()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
