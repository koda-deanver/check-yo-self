//
//  ConnectionButton.swift
//  check-yo-self
//
//  Created by Phil on 3/6/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Holds view for single connection on *connectionsViewController*. EX: *Fitbit*, *HealthKit*.
class ConnectionCell: UICollectionViewCell {
    
    // MARK - Private Members -
    
    /// Connection model object.
    private var connection: Connection!
    /// Connections screen.
    private var containingViewController: GeneralViewController?
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var backdropButton: UIButton!
    @IBOutlet private weak var connectionImage: UIImageView!
    @IBOutlet private weak var checkmarkImage: UIImageView!
    @IBOutlet private weak var loadingImageView: UIImageView!
    
    // MARK: - Public Methods -
    
    ///
    /// Initial setup for connection view.
    ///
    /// - parameter connection: The connection to set up view to represent.
    ///
    func configure(for connection: Connection, containingViewController: GeneralViewController) {
        
        self.containingViewController = containingViewController
        self.connection = connection
        connection.cell = self
        
        guard let image = connection.type.image else { return }
        connectionImage.image = image
        
        style(for: connection.state)
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Style the view to match the specified state.
    ///
    /// - parameter state: The state of the connection view to style for.
    ///
    func style(for state: ConnectionState) {
      
        let backgroundImage = (connection.state == .connected) ? #imageLiteral(resourceName: "ConnectionBackdropGreen") : #imageLiteral(resourceName: "ConnectionBackdropGray")
        backdropButton.setBackgroundImage(backgroundImage, for: .normal)
        backdropButton.alpha = (state == .pending) ? 0.5 : 1.0
        connectionImage.alpha = (state == .pending) ? 0.5 : 1.0
        checkmarkImage.isHidden = !(state == .connected)
        loadingImageView.isHidden = !(state == .pending)
    
        if state == .pending { showPendingAnimation() }
    }
  
    ///
    /// Spin pending image until connection is no longer pending.
    ///
    private func showPendingAnimation() {
        
        UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
            self.loadingImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { _ in })
        
        // Second half of spin (half delay for smooth transition)
        UIView.animate(withDuration: 0.5, delay: 0.25,  animations: {
            self.loadingImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }, completion: { _ in
            self.style(for: self.connection.state)
        })
    }
}

// MARK: - Extension: Actions -

extension ConnectionCell {
    
    /// Attempt to connect to connection.
    @IBAction func backdropButtonPressed(_ sender: UIButton) {
        guard let viewController = containingViewController else { return }
        connection.handleInteraction(viewController: viewController)
    }
}