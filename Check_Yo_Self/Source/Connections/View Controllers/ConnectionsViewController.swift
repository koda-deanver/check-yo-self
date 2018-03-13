//
//  ConnectionsViewController.swift
//  check-yo-self
//
//  Created by Phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  This replaced the old *DevicesViewController* and now uses collectionView.
//

import UIKit

/// Screen displaying all possible connections. Connections that are being used display on a green backdrop.
final class ConnectionsViewController: SkinnedViewController {
    
    // MARK: - Private Members -
    
    private var connections: [Connection] { return ConnectionManager.shared.existingConnections }
    
    // MARK: - Outlets -
    
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle -
    
    override func style() {
        super.style()
        connectionsLabel.textColor = User.current.ageGroup.textColor
    }
}

// MARK: - Extension: Collection View -

extension ConnectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ConnectionManager.shared.existingConnections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "connectionCell", for: indexPath) as? ConnectionCell else { return UICollectionViewCell() }
        
        cell.configure(for: connections[indexPath.row], containingViewController: self)
        
        return cell
    }
}

// MARK: - Extension: Actions -

extension ConnectionsViewController {
    
     @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
     }
}

