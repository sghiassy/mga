//
//  GPNSTLogger.swift
//  mga
//
//  Created by Shaheen Ghiassy on 10/3/17.
//  Copyright © 2017 Shaheen Ghiassy. All rights reserved.
//

import UIKit

// Example of Logging
class GPNSTLogger {
    public static let shared = GPNSTLogger()
    var log: [String] = []
    
    private init() { } // This prevents others from using the default '()' initializer for this class.
    
    public func log(_ message: String) {
        debugPrint("Logging NST :: \(message)")
        self.log.append(message)
    }
}
