//
//  RouteHandlerServer.swift
//  
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import UIKit

open class RouteHandler: NSObject {
    public override required init() {
        
    }
    
    open func routes(server:Server) {
        preconditionFailure("\(NSStringFromClass(type(of: self))) method must override the routes function")
    }
}
