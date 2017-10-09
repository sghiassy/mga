//
//  Browser.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import UIKit

public enum BrowserTransitionType {
    case none
    case push
    case refresh
    case modal // Not Implemented Yet
    case flip // // Not Implemented Yet
    case fade // Not Implemented Yet
}

public typealias OptionalCallback = ((_:Response)->())?

public class Browser {
    public static let shared = Browser()
    public var viewport: Viewport
    let dns: DNS = DNS()
    var history: [String] = []
    
    private init() {
        self.viewport = Viewport()
        self.viewport.onUserEnteredNewAddress = { (str) in
            let req = Request(str)
            req.verb = .SHOW
            req.browserTransitionType = .refresh
            Browser.issue(req, completion: { (res) in
                // nada
            })
        }
    }
    
    public static func setup() {
        // Just a stub function for people who want to feel more comfortable calling setup first.
        // But really any method will call the init method, which will init the DNS sub-system
    }
    
    // MARK: - Navigation Methods
    
    // Have the browser make a data request or navigate to a page
    public static func show(_ request: String, _ completion:OptionalCallback = nil) {
        let req = Request(request)
        req.verb = .SHOW
        req.browserTransitionType = .push
        Browser.issue(req, completion: completion)
    }
    
    public static func get(_ request: String, _ completion:OptionalCallback = nil) {
        let req = Request(request)
        req.verb = .GET
        Browser.issue(req, completion: completion)
    }
    
    public static func post(_ req: String, body: [String:Any]?, _ completion:OptionalCallback = nil) {
        let req = Request(req)
        req.verb = .POST
        req.body = body ?? [:]
        Browser.issue(req, completion: completion)
    }
    
    public static func back(_ animated: Bool = true) {
        let prevUrl = Browser.shared.history[Browser.shared.history.count - 2]
        Browser.shared.viewport.urlBrowserBarText = prevUrl
        Browser.shared.viewport.pop(animated: animated)
    }
    
    // The underlying agnostic request
    public static func issue(_ req: Request, completion:OptionalCallback = nil) {
        Browser.shared.viewport.urlBrowserBarText = req.url.absolutePath
        
        if (req.verb == .SHOW) {
            Browser.shared.history.append(req.url.absolutePath) // Browsers only save website urls to their history. Not all requeusts
        }
        
        guard let server = Browser.shared.dns.serverForDomain(req.host) else {
            return completion!(Response(.NotFound, body:["error":"Domain Not Found"]))
        }
        
        server.deliverRequest(req) { (res) in
            let shouldUpdateView = res.status == .OK && req.verb == .SHOW
            let shouldIssueRedirectRequest = res.status == .TemporaryRedirect || res.status == .PermanentRedirect
            
            if (shouldUpdateView) {
                Browser.shared.viewport.updateViewportWithVC(res.viewC, transitionType: req.browserTransitionType)
            }
            
            if (shouldIssueRedirectRequest) {
                let redirectRequest: Request = req.dup()
                redirectRequest.updateURL(res.location)
                // Does more information need to be copied here?
                DispatchQueue.main.async {
                    Browser.issue(redirectRequest, completion: { (res) in
                        completion?(res)
                    })
                }
            } else {
                completion?(res)
            }
        }
    }
    
    // MARK: - Convienence Methods
    
    // syntactic-sugar
    public static var rootViewController: UIViewController {
        return Browser.shared.viewport
    }
    
    // syntactic-sugar
    public static var frame: CGRect {
        get {
            return Browser.shared.viewport.view.frame
        }
        set {
            Browser.shared.viewport.view.frame = frame
        }
    }

}
