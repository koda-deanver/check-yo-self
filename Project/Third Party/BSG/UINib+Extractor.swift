//
//  UINib+Extractor.swift
//  KWI
//
//  Created by Sean Orelli on 9/9/16.
//  Copyright © 2016 Fuzz Productions, LLC. All rights reserved.
//

import Foundation

extension UINib {
    
    ///
    /// This will load a single nib from the xib with the given name
    ///
    /// - parameter name: Xib file name
    ///
    /// - returns: instantiated view, if any, from xib
    ///
    final class func viewForNibNamed(_ name: String) -> UIView? {
        
        let nib = UINib(nibName: name, bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        
        if let view = views.first as? UIView {
            return view
        }
        
        return nil
    }
    
    ///
    /// This will load a nib matching the given Type, from the xib with the given name
    ///
    /// - parameter classType: class type to instantiate from the xib
    /// - parameter name: Xib file name
    ///
    /// - returns: instantiated view, if any, from xib
    ///
    final class func viewWithClass<T>(classType: T.Type, fromNibNamed name: String) -> T? {
        
        let nib = UINib(nibName: name, bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        
        for view in views {
            
            if let upcastedView = view as? T {
                return upcastedView
            }
        }
        
        return nil
    }
}
