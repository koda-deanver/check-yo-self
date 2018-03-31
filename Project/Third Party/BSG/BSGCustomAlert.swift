//
//  BSGCustomAlert.swift
//  stack_300
//
//  Created by Phil Rattazzi on 5/31/17
//  Copyright © 2017 Brook Street Games. All rights reserved.
//
//  Custom alert with vertical button options.
//

struct BSGCustomAlert {
    
    let message: String
    let options: [(text: String, handler: Closure)]
    
    // MARK: - Initializers -
    
    init(message: String, options: [(text: String, handler: Closure)] = [("OK", {})]){
        self.message = message
        self.options = options
    }
}
