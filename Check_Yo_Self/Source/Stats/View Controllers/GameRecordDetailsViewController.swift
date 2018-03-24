//
//  GameRecordDetailsViewController.swift
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
    /// The statistics to show in bottom table.
    private var gameStats: [GameStat] = []
    
    /// Used to format dates for start and end times.
    lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var centerMapButton: UIButton!
    
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle -
    
    override func style() {
        
        super.style()
        
        if let location = gameRecord.location {
            
            centerMapOnLocation(location: location)
            
            let marker = LocationMarker(title: User.current.uid, locationName: dateFormatter.string(from: gameRecord.endTime), discipline: "This is where you finished this game!", coordinate: (location.coordinate))
            mapView.addAnnotation(marker)
        }
        
        centerMapButton.titleLabel?.font = UIFont(name: Font.main, size: Font.mediumSize)
        
        gameImageView.image = gameRecord.questionType.image
        
        scoreLabel.font = UIFont(name: Font.heavy, size: Font.largeSize)
        scoreLabel.text = "Score: \(gameRecord.score)"
        scoreLabel.textColor = User.current.favoriteColor.uiColor
        
        buildGameStatArray()
    }
    
    ///
    /// Populated *connectionGameStats* array with stats from *gameRecord*.
    ///
    private func buildGameStatArray() {
        
        let gems = gameRecord.gemsEarned
        let gemValue = gems >= 0 ? "+\(gems)" : "-\(gems)"
        let gemStat = GameStat(image: #imageLiteral(resourceName: "JabbRGem"), name: "Gems Earned", value: gemValue)
        
        let startTimeStat = GameStat(image: #imageLiteral(resourceName: "TabBarIconStats"), name: "Started", value: dateFormatter.string(from: gameRecord.startTime))
        let endTimeStat = GameStat(image: #imageLiteral(resourceName: "TabBarIconStats"), name: "Ended", value: dateFormatter.string(from: gameRecord.endTime))
        
        gameStats += [gemStat, startTimeStat, endTimeStat]
        
        if let steps = gameRecord.steps {
            gameStats.append(GameStat(image: #imageLiteral(resourceName: "Health"), name: "Daily Steps", value: String(steps)))
        }
        
        if let heartData = gameRecord.heartData {
            let heartRateStat = GameStat(image: #imageLiteral(resourceName: "Fitbit"), name: "Resting Heart Rate", value: String(heartData.restingHeartRate))
            let fatBurnMinutesStat = GameStat(image: #imageLiteral(resourceName: "Fitbit"), name: "Fat Burn Minutes", value: String(heartData.fatBurnMinutes))
            let cardioMinutesStat = GameStat(image: #imageLiteral(resourceName: "Fitbit"), name: "Cardio Minutes", value: String(heartData.cardioMinutes))
            let peakMinutesStat = GameStat(image: #imageLiteral(resourceName: "Fitbit"), name: "Peak Minutes", value: String(heartData.peakMinutes))
            
            gameStats += [heartRateStat, fatBurnMinutesStat, cardioMinutesStat, peakMinutesStat]
        }
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

// MARK: - Extension: UITableViewDataSource, UITableViewDelegate -

extension GameRecordDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameStatCell") as? GameStatCell else { return UITableViewCell() }
        cell.configure(withStat: gameStats[indexPath.row])
        
        return cell
    }
    
    // Only used for spacer.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeightSmall
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.rowHeightSmall
    }
}

// MARK: - Extension: Actions -

extension GameRecordDetailsViewController {
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func centerMapButtonPressed(_ sender: UIButton) {
        centerMapOnLocation(location: gameRecord.location)
    }
}
