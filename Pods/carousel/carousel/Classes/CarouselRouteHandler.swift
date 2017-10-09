//
//  CarouselMain.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import UIKit
import AirGap

class CarouselRouteHandler: RouteHandler {
    override public func routes(server:Server) {
        
        server.on(.SHOW, "/") { (req, res, done) in
            let lightCarouselABisOn = req.query("abTestCarouselSimple") == "true"
            
            if (lightCarouselABisOn) {
                // Since the carousel-light experiment is on, redirect the request to the carousel-light domain
                res.status = .PermanentRedirect // 301
                res.location = "carousel-light.groupon.com"
                return done()
            }
            
            res.viewC = CarouselViewController()
            done()
        }
        
    }
}
