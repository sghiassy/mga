//
//  CheckoutRouteHandler.swift
//  checkout
//
//  Created by Shaheen Ghiassy on 10/2/17.
//

import UIKit
import AirGap

class CheckoutRouteHandler: RouteHandler {
    override open func routes(server:Server) {
        server.on(.SHOW, "/:sessionId") { (req, res, done) in
            res.viewC = CheckoutViewController(sessionId: req.param("sessionId"))
            done()
        }
    }
}
