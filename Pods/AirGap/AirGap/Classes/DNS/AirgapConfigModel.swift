//
//  AirgapConfigModel.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/4/17.
//

import Foundation

class AirgapConfigModel: NSObject {
    
    public var domainConfigs: [[String:String]] = []
    
    public init(config: [[String: Any]]) {
        for domain in config {
            if let configFile = domain["config"] as? String,
               var bundleId = domain["bundle"] as? String {
                
                if (bundleId == "main") {
                    bundleId = Bundle.main.bundleIdentifier!
                }
                
                let domainConfig = ["configFile":configFile, "bundleId": bundleId]
                self.domainConfigs.append(domainConfig)
                
            }
        }
    }
}
