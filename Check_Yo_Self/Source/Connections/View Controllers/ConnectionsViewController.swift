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
    
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
}

// MARK: - Extension: Collection View -

extension ConnectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ConnectionManager.shared.existingConnections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        guard let connectionView = UINib.viewWithClass(classType: ConnectionView.self, fromNibNamed: "Connections") else { return cell }
        connectionView.frame = cell.frame
        cell.addSubview(connectionView)
        
        return cell
    }
}

// MARK: - Extension: Actions -

extension ConnectionsViewController {
    
     @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
     }
}

