//
//  GameRecordDetailsViwController.swift
//  check-yo-self
//
//  Created by phil on 12/2/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//
//  Updated from DataEntryDetails on 3/20/18.
//

import MapKit
import CoreLocation

final class GameRecordDetailsViewController: SkinnedViewController {
    
    // MARK: - Public Members -
    
    var gameRecord: GameRecord!
    
    // MARK: - Private Members -
    
    /// Radius shown in map.
    private let regionRadius: CLLocationDistance = 1000
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var centerMapButton: UIButton!
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var gemLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    
    // MARK: - Lifecycle -
    
    override func style() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        if let location = gameRecord.location {
            
            centerMapOnLocation(location: location)
            
            let marker = LocationMarker(title: User.current.username, locationName: dateFormatter.string(from: gameRecord.endTime), discipline: "This is where you finished this game!", coordinate: (location.coordinate))
            mapView.addAnnotation(marker)
        }
        
        gameImageView.image = gameRecord.questionType.image
        
        scoreLabel.text = String(gameRecord.score)
        
        let gems = gameRecord.gemsEarned
        gemLabel.text = gems > 0 ? "+\(gems)" : "-\(gems)"
        
        startTimeLabel.text = "Started: \(dateFormatter.string(from: gameRecord.startTime))"
        endTimeLabel.text = "Ended: \(dateFormatter.string(from: gameRecord.endTime))"
    }

    ///
    /// Center map to focus on location.
    ///
    /// - parameter location: Location desired to be in center of map.
    ///
    private func centerMapOnLocation(location: CLLocation?) {
        
        guard let location = location else { return }
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - Extension: Actions -

extension GameRecordDetailsViewController {
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func centerMapButtonPressed(_ sender: UIButton) {
        centerMapOnLocation(location: gameRecord.location)
    }
}
