//********************************************************************
//  DataEntryDetailsViewController.swift
//  Check Yo Self
//  Created by Phil on 12/13/16
//
//  Description: Detailed view of one game instance
//********************************************************************

import UIKit
import MapKit
//import CoreLocation

class DataEntryDetailsViewController: GeneralViewController {
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var phaseImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gemLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var fatBurnLabel: UILabel!
    @IBOutlet weak var cardioLabel: UILabel!
    @IBOutlet weak var peakLabel: UILabel!
    
    //********************************************************************
    // Action: backButton
    // Description: Go back to table view
    //********************************************************************
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //********************************************************************
    // Action: centerMapButtonPressed
    // Description: Recenter map if user gets lost
    //********************************************************************
    @IBAction func centerMapButtonPressed(_ sender: UIButton) {
        let dataEntry = PlayerData.sharedInstance.tableIndex!
        if dataEntry.location != nil{
            centerMapOnLocation(location: dataEntry.location!)
        }
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Set up all labels with temporary saved data from PlayerData
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataEntry = PlayerData.sharedInstance.tableIndex!
        if dataEntry.phase == .check{
            self.phaseImage.image = #imageLiteral(resourceName: "TripleCheck")
        }else{
            self.phaseImage.image = UIImage(named: String(format: "%@.png", dataEntry.phase.rawValue))
        }
        
        self.scoreLabel.text = String(dataEntry.score)
        
        // Add plus sign if positive gems
        let gems = dataEntry.gemsEarned
        if gems >= 0{
            self.gemLabel.text = "+\(gems)"
        }else{
            self.gemLabel.text = "\(gems)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        startTimeLabel.text = dateFormatter.string(from: dataEntry.startTime)
        endTimeLabel.text = dateFormatter.string(from: dataEntry.endTime)
        
        if(dataEntry.location != nil){
            centerMapOnLocation(location: dataEntry.location!)
            
            let optionalName: String? = PlayerData.sharedInstance.displayName
            let yourLocation = LocationMarker(title: optionalName!,
                                  locationName: dateFormatter.string(from: dataEntry.endTime),
                                  discipline: "This is where you finished this game!",
                                  coordinate: (dataEntry.location!.coordinate))
            mapView.addAnnotation(yourLocation)
        }else{
            //locationLabel.text = ("No Location Data")
        }
        
        // Display Step Count
        if let steps = dataEntry.steps{
            self.stepCountLabel.text = String(steps)
        }
        // Display Heart Rate
        if let heartRateInfo = dataEntry.heartDictionary{
            if let restingHeartRate = heartRateInfo[HeartCategory.restingHeartRate.rawValue]{
                self.heartRateLabel.text = "\(restingHeartRate)"
            }
            if let fatBurnMinutes = heartRateInfo[HeartCategory.fatBurnMinutes.rawValue]{
                self.fatBurnLabel.text = "\(fatBurnMinutes)"
            }
            if let cardioMinutes = heartRateInfo[HeartCategory.cardioMinutes.rawValue]{
                self.cardioLabel.text = "\(cardioMinutes)"
            }
            if let peakMinutes = heartRateInfo[HeartCategory.peakMinutes.rawValue]{
                self.peakLabel.text = "\(peakMinutes)"
            }
        }
    }
    
    //********************************************************************
    // Action: centerMapOnLocation
    // Description: Move map to focus on location point
    //********************************************************************
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
