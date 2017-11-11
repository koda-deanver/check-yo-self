//********************************************************************
// LocationMarker.swift
//  Check Yo Self
//  Created by Phil on 12/13/16
//
//  Description: A marker object used to display details on a map
//********************************************************************

import Foundation

import Foundation
import MapKit

class LocationMarker: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    var subtitle: String? {
        return locationName
    }
    //********************************************************************
    // Designated Initializer
    // Description: Initialize all variables of class
    //********************************************************************
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
}
