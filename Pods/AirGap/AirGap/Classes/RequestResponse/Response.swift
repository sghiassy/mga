//
//  Response.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import UIKit

public class Response: NSObject {

    public var viewC: UIViewController?
    public var status: StatusCodes = .OK
    public var body: [String:Any] = [:]
    public var location: String = "" // https://en.wikipedia.org/wiki/HTTP_location
    
    convenience init(_ status: StatusCodes, body: [String:Any]) {
        self.init()
        self.status = status
        self.body = body
    }
    
}
