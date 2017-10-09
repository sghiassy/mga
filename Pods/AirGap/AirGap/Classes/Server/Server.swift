//
//  DNSConfig.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

public typealias DoneBlock = () -> Void
public typealias RouteReqResBlock = (_ req: Request, _ res: Response, _ done: DoneBlock) -> Void // DONE block is to allow for async responses
public typealias ResponseBlock = (_ res: Response) -> Void


import UIKit

public class Server: NSObject {

    let config : DomainConfigModel
    var routeHandler: RouteHandler
    var routes: [RequestType : [String : RouteReqResBlock]] = [:]
    
    // MARK: Object Lifecycle

    init(domain: String, routeHandler: RouteHandler, config: DomainConfigModel) {
        self.config = config
        self.routeHandler = routeHandler
        
        // I don't know how to iterate over ENUMs in Swift, so I'm doing it the stupid way :(
        // but this also what the compiler is probably going to do under the hood anyways  ;)
        self.routes[.SHOW] = [:]
        self.routes[.GET] = [:]
        self.routes[.POST] = [:]
        self.routes[.PUT] = [:]
        self.routes[.DELETE] = [:]
        self.routes[.CONNECT] = [:]
        self.routes[.HEAD] = [:]
        self.routes[.OPTIONS] = [:]
        self.routes[.TRACE] = [:]
        self.routes[.PATCH] = [:]
        
        super.init()
        self.boot()
    }
    
    // Run this function to start initiating the server
    // and run the main function in the routeHandler
    public func boot() {
        self.routeHandler.routes(server: self)
    }
    
    // MARK: Request Delivery Methods
    
    public func deliverRequest(_ req: Request, _ cb: ResponseBlock) {
        guard let routeHandler = self.matchRoute(req) else {
            print("ROUTE NOT FOUND: \(req)")
            let notFound = Response(.NotFound, body:["error":"Route Handler for Requeset not found"])
            return cb(notFound)
        }
        
        let res = Response()
        routeHandler(req, res) { () in
            cb(res)
        }
    }
    
    func matchRoute(_ req: Request) -> RouteReqResBlock? {
        guard let routesForVerb: [String : RouteReqResBlock] = self.routes[req.verb] else { // First check if there are any routes registered for this verb
            return nil
        }
        
        let routeMatchesPathExactly = routesForVerb[req.path] != nil
        
        if (routeMatchesPathExactly) {
            return routesForVerb[req.path] // if we have an exact match, then its not necessary to continue
        }
        
        /*
         *
         *  The below fuzzy search algorithim needs a lot more testing / features
         *  Minimal functionatliy for now.
         *  Probably should pull out this functionality into its own seperate open-source repo for Swift simple pattern matching
         *  Good test cases can be found at: https://github.com/snd/url-pattern
         */
        
        // Begin Fuzzy Search
        for route in routesForVerb {
            let routeContainsPathExpression = route.key.contains(":")
            
            if (!routeContainsPathExpression) { break } // If we didn't find an exact match, than any route that doesn't have a wildcard in it, is not a valid route
            
            let routePathParts = route.key.components(separatedBy: "/")
            let requestPathParts = req.path.components(separatedBy: "/")
            
            let reqAndRouteHaveTheSameNumberOfPaths = requestPathParts.count == routePathParts.count
            
            if (!reqAndRouteHaveTheSameNumberOfPaths) { break } // If the req and the route don't have the same number of slashes (/) then they clearly are not a match
            
            // At this point we have similar heurisitcs of paths, so now we need to match up the wildcards
            var pathsMatch = true
            var ctr = -1
            
            for routePathPart in routePathParts {
                ctr += 1
                let routePartIsWild = String(routePathPart.prefix(1)) == ":"
                let partsMatchExactly = routePathPart == requestPathParts[ctr]
                
                if (routePartIsWild) { // if its wild, then we're all good
                    continue
                }
                
                if (!partsMatchExactly) { // if not wild, they must match exactly
                    pathsMatch = false
                    break
                }
            }
            
            // If we now know the paths match, build the request object
            // NOTE: This may look redudant to the loop above, but we can't begin to modify the request object, until we are fully certain
            //       the two paths match first
            if (pathsMatch) {
                ctr = -1
                for var routePathPart in routePathParts {
                    ctr += 1
                    let routePartIsWild = String(routePathPart.prefix(1)) == ":"

                    if (routePartIsWild) {
                        routePathPart.remove(at: routePathPart.startIndex) // remove starting ":" from route part
                        req.param[routePathPart] = requestPathParts[ctr]
                    }
                }
                return route.value // return the callback block
            }
        }
        
        return nil
    }
    
    // MARK: Route Registration Methods
    
    public func on(_ verb: RequestType, _ path: String, _ cb:@escaping RouteReqResBlock) {
        precondition(self.validiatePath(verb, path) == true, "The route:\(path) for verb:\(verb) on domain:\(self.config.host) you are registering for has not been defined in the domain's YAML configuration")
        precondition(self.routes[verb]?[path] == nil, "The route for path:\(path) has already been defined")
        
        self.routes[verb]?[path] = cb
    }
    
    func validiatePath(_ verb: RequestType, _ path: String) -> Bool {
        let configPaths = self.config.paths
        
        var pathIsDefinedInYamlSpec = false
        
        for configPathDefinition in configPaths {
            if pathIsDefinedInYamlSpec { break } // break when the inner loop breaks
            
            if (path == configPathDefinition.key.string) {
                for configPathDefinitionEntry in configPathDefinition.value.dictionary! {
                    let verbsValue = verb.rawValue.components(separatedBy:".").last?.uppercased()
                    let configsValue = configPathDefinitionEntry.key.string?.uppercased()
                    if (verbsValue == configsValue) {
                        pathIsDefinedInYamlSpec = true
                        break
                    }
                }
            }
        }
        
        return pathIsDefinedInYamlSpec
    }
    
    // MARK: Syntactic-sugar setters / getters
    
    public var hostname: String {
        get {
            return self.config.host
        }
    }
    
    public override var description: String {
        return self.config.host
    }
}
