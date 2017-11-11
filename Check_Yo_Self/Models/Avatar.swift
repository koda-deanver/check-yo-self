//
//  AvatarInformation.swift
//  Check_Yo_Self
//
//  Created by phil on 1/10/17.
//  Copyright © 2017 ThematicsLLC. All rights reserved.
//

import Foundation
import UIKit

class Avatar{
    let image: UIImage
    let name: String
    let identity: AvatarIdentity
    let discipline: String
    let bio: String
    
    init(_ image: UIImage, name: String, identity: AvatarIdentity, discipline: String, bio: String){
        self.image = image
        self.name = name
        self.identity = identity
        self.discipline = discipline
        self.bio = bio
    }
}
