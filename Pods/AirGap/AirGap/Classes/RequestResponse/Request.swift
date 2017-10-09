//
//  Request.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/1/17.
//


public enum RequestType: String {
    case SHOW // SHOW is the only custom method. Its like an <a> tag in the web browser. Which is basicaly a GET request, but then shows the result to the browser's screen. Unlike a GET request in itself, which is data-only
    case GET
    case POST
    case PUT
    case DELETE
    case CONNECT
    case HEAD
    case OPTIONS
    case TRACE
    case PATCH // list from https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
}

public enum StatusCodes: Int { // https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
    case OK = 200
    case PermanentRedirect = 301
    case TemporaryRedirect = 302
    case NotFound = 404
    case IAmATeapot = 418
}

import UIKit

public class Request: NSObject, NSCopying {
    
    public var verb: RequestType = .GET
    var browserTransitionType: BrowserTransitionType = .none
    var url: YURL
    var param: [String:String] = [:]
    public var body: [String:Any] = [:]
    
    init(_ str: String) {
        self.url = YURL(str)
    }
    
    public func query(_ param: String) -> String {
        guard let value = self.url.query(param) else {
            return ""
        }
        return value
    }
    
    public func param(_ param: String) -> String {
        guard let value = self.param[param] else {
            return ""
        }
        return value
    }
    
    public func updateURL(_ str: String) { // Is there a better way to do this? Setter?
        self.url = YURL(str)
    }
    
    var path: String {
        get {
            return self.url.path
        }
    }
    
    var host: String {
        get {
            return self.url.host
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let url = Request("")
        url.url = self.url.copy() as! YURL
        url.verb = self.verb
        return url
    }
    
    public func dup() -> Request {
        return self.copy() as! Request // Is there a better way to do this?
    }
    
    public override var description: String {
        return self.url.absolutePath
    }
    
}
