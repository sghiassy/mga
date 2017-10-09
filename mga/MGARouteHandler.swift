//
//  MGARouteHandler.swift
//  mga
//
//  Created by Shaheen Ghiassy on 10/3/17.
//  Copyright © 2017 Shaheen Ghiassy. All rights reserved.
//

import UIKit
import AirGap

class MGARouteHandler: RouteHandler {
    override public func routes(server:Server) {
        
        server.on(.POST, "/log") { (req, res, done) in
            req.body.forEach({ (entry) in
                if let message = entry.value as? String {
                    GPNSTLogger.shared.log(message)
                }
            })
        }
        
        server.on(.GET, "/location") { (req, res, done) in
            res.body["lat"] = GPLocationManager.shared.currentLocation.latitude
            res.body["lng"] = GPLocationManager.shared.currentLocation.latitude
            done()
        }
        
    }

}
