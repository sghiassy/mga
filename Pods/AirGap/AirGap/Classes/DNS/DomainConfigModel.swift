//
//  DomainConfigModel.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/5/17.
//

import UIKit
import Yaml

class DomainConfigModel: NSObject {
    
    let config: Yaml
    let host: String

    init(config: Yaml) throws {
        self.config = config
        
        guard let domainDefinition = self.config["domain"].dictionary,
              let host = domainDefinition["url"]?.string else {
                throw AirGapConfigError.RequiredInfoMissing
        }
        
        self.host = host
    }
    
    public var paths: [Yaml:Yaml] {
        get {
            guard let pathDefinitions = self.config["paths"].dictionary else {
                return [:]
            }
            return pathDefinitions
        }
    }
}
