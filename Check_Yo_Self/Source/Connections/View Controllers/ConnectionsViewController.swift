//
//  ConnectionsViewController.swift
//  check-yo-self
//
//  Created by phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  This replaced the old *DevicesViewController* and now uses collectionView.
//

import UIKit

/// Screen displaying all possible connections. Connections that are being used display on a green backdrop.
final class ConnectionsViewController: SkinnedViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle -
    
    override func style() {
        super.style()
        connectionsLabel.textColor = User.current.ageGroup.textColor
        NotificationManager.shared.addObserver(self, forNotificationType: .connectionUpdated, handler: #selector(countConnections))
    }
    
    // MARK: - Private Methods -
    
    @objc private func countConnections() {
        
        let count = ConnectionManager.shared.connectedConnections
        connectionsLabel.text = "Connections: \(count)/\(ConnectionManager.shared.existingConnections.count)"
        connectionsLabel.textColor = (count == ConnectionManager.shared.existingConnections.count) ? CubeColor.green.uiColor : User.current.ageGroup.textColor
    }
}

// MARK: - Extension: Collection View -

extension ConnectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ConnectionManager.shared.existingConnections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "connectionCell", for: indexPath) as? ConnectionCell else { return UICollectionViewCell() }
        
        cell.configure(for: ConnectionManager.shared.existingConnections[indexPath.row], containingViewController: self)
        
        return cell
    }
}

// MARK: - Extension: Actions -

extension ConnectionsViewController {
    
     @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
     }
}

