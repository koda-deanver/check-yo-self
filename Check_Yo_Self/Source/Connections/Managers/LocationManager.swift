//
//  LocationManager.swift
//  check-yo-self
//
//  Created by phil on 3/16/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import CoreLocation

/// Provides services related to location.
final class LocationManager: NSObject {
    
    /// MARK: - Public Members -
    
    static let shared = LocationManager()
    
    var location: CLLocation? {
        return self.locationManager.location
    }
    
    // MARK: - Private Members -
    
    private var locationManager = CLLocationManager()
    
    // MARK: - Public Methods -
    
    ///
    /// Asks user for permission to use location in app.
    ///
    func configure() {
        locationManager.requestWhenInUseAuthorization()
    }
}
