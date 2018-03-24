//
//  LocationMarker.swift
//  check-yo-self
//
//  Created by phil on 12/13/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation
import MapKit

/// Used to mark a location on a map.
class LocationMarker: NSObject, MKAnnotation {
    
    // MARK - Public Members -
    
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    // MARK: - Initializers -
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
}
