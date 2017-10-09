//
//  DealDetailsRouteHandler.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/2/17.
//

import UIKit
import AirGap

class DealDetailsRouteHandler: RouteHandler {
    override open func routes(server:Server) {
        
        server.on(.SHOW, "/deals/:dealId") { (req, res, done) in
            res.viewC = DealDetailsViewController(dealId:req.param("dealId"))
            done()
        }
        
    }
}
