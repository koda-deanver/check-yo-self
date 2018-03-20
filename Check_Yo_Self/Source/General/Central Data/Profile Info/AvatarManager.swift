//
//  AvatarManager.swift
//  check-yo-self
//
//  Created by phil on 1/10/17.
//  Copyright © 2017 ThematicsLLC. All rights reserved.
//

import UIKit

// MARK: - Struct -

/// Holds information about an avatar.
struct Avatar {
    
    // MARK: - Public Members -
    
    /// Image for avatar.
    let image: UIImage
    /// Name of avatar.
    let name: String
    /// Decriptive job title.
    let discipline: String
    /// A short description explaining why you relate to this avatar.
    var bio: String { return "\(name) identifies as \(identity.displayedIdentity) and mainly plays in the \(genre) genre." }
    
    /// Used to locate avatar based on User.
    let genre: CollabrationGenre
    /// Used to locate avatar based on User.
    let identity: Identity
    
    // MARK: - Initializers -
    
    init(_ image: UIImage, name: String, discipline: String, genre: CollabrationGenre, identity: Identity){
        
        self.image = image
        self.name = name
        self.discipline = discipline
        
        self.genre = genre
        self.identity = identity
    }
}

/// Provides functions for dealing with avatar selection.
class AvatarManager {
    
    // MARK: - Public Members -
    
    static let shared = AvatarManager()
    
    // MARK: - Private Members -
    
    /// Currently used as default avatar.
    private let genericMaleAvatar = Avatar(#imageLiteral(resourceName: "Freeform2"), name: "Generic Avatar", discipline: "Adjust your profile to get a cutomized avatar.", genre: .general, identity: .unknown)
    /// Not currently used.
    private let genericFemaleAvatar = Avatar(#imageLiteral(resourceName: "Freeform1"), name: "Generic Avatar", discipline: "Adjust your profile to get a cutomized avatar.", genre: .general, identity: .unknown)
    
    private let maleAvatars: [Avatar] = [
        
        Avatar(#imageLiteral(resourceName: "CRMacintosh_Architect"), name: "CR Macintosh", discipline: "Architect", genre: .realEstate, identity: .straightMale),
        Avatar(#imageLiteral(resourceName: "ChadGutstein_Machinima"), name: "Chad Gutstein", discipline: "Machinima", genre: .selling, identity: .straightMale),
        Avatar(#imageLiteral(resourceName: "OskarEustice_Storyteller"), name: "Oscar Eustice", discipline: "Storyteller", genre: .live, identity: .straightMale),
        Avatar(#imageLiteral(resourceName: "DannyMeyer_Restauranteur"), name: "Danny Meyer", discipline: "Restauranteur", genre: .foodie, identity: .straightMale),
        Avatar(#imageLiteral(resourceName: "TylerOakley_Publisher"), name: "Tyler Oakley", discipline: "Publisher", genre: .publications, identity: .straightMale),
        Avatar(#imageLiteral(resourceName: "AaronSorkin_Screenwriter"), name: "Aaron Sorkin", discipline: "Screenwriter", genre: .lensed, identity: .straightMale)
    ]
    
    private let femaleAvatars: [Avatar] = [
        
        Avatar(#imageLiteral(resourceName: "Zida_Architect"), name: "Zida", discipline: "Architect", genre: .realEstate, identity: .straightFemale),
        Avatar(#imageLiteral(resourceName: "ChelseaClinton_Philanthropist"), name: "Chelsea Clinton", discipline: "Philanthropist", genre: .selling, identity: .straightFemale),
        Avatar(#imageLiteral(resourceName: "Beyonce_Publisher"), name: "Beyonce", discipline: "Publisher", genre: .live, identity: .straightFemale),
        Avatar(#imageLiteral(resourceName: "AliceWaters_Foodie"), name: "Alice Waters", discipline: "Foodie", genre: .foodie, identity: .straightFemale),
        Avatar(#imageLiteral(resourceName: "AliLew_Gamer"), name: "Ali Lew", discipline: "Gamer", genre: .publications, identity: .straightFemale),
        Avatar(#imageLiteral(resourceName: "TinaFey_Writer"), name: "Tina Fey", discipline: "Writer", genre: .lensed, identity: .straightFemale)
    ]
    
    // MARK: - Public Methods -
    
    ///
    /// Get avatar matching user.
    ///
    /// - parameter user: The user to get avatar for.
    ///
    /// - returns: Avatar matching user or default avatar.
    ///
    func getAvatar(for user: User) -> Avatar {
        
        switch user.identity {
        case .straightMale, .gayMale: return getAvatarMatching(genre: user.favoriteGenre, from: maleAvatars) ?? genericMaleAvatar
        case .straightFemale, .gayFemale: return getAvatarMatching(genre: user.favoriteGenre, from: femaleAvatars) ?? genericMaleAvatar
        case .unknown: return genericMaleAvatar
        }
    }
    
    ///
    /// Searches gven array of avatars for one matching genre.
    ///
    /// - parameter genre: The Collabration Genre to find avatar for.
    /// - parameter avatars: The array of avatars to look through.
    ///
    /// - returns: Avatar matching genre or nil.
    ///
    private func getAvatarMatching(genre: CollabrationGenre, from avatars: [Avatar]) -> Avatar? {
        
        for avatar in avatars where avatar.genre == genre {
            return avatar
        }
        return nil
    }
}


