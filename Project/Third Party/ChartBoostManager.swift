//
//  ChartBoostManager.swift
//  check-yo-self
//
//  Created by AA10 on 06/07/2020.
//  Copyright © 2020 ThematicsLLC. All rights reserved.
//

import UIKit

class ChartBoostManager {
    static let sharedInstance: ChartBoostManager = ChartBoostManager()
    
    var cachedObject : CHBInterstitial!
    
    public func cacheInterstitial(location: String){
        cachedObject = CHBInterstitial.init(location: location, delegate: nil)
        cachedObject.cache()
    }
    
    public func showInterstitialfor(controller: UIViewController!){
        cachedObject.show(from: controller)
    }
    
}
