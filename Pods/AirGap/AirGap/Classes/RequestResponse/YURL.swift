//
//  YURL.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/2/17.
//

import UIKit

class YURL: NSObject, NSCopying { // Named stupidly, so I didn't have to worry about namespacing against Foundation.URL

    var originalStr: String
    var url: NSURLComponents?
    
    init(_ str: String) {
        self.originalStr = str
        self.url = NSURLComponents(url: YURL.sanitizeURL(str), resolvingAgainstBaseURL: false)
    }
    
    public func query(_ param: String) -> String? {
        // Go through the query items and find a matching query item
        // Can't believe it's this hard to do such a simple thing! (ScG)
        
        if let queryItems = self.url?.queryItems {
            return queryItems.filter({ (item) in
                item.name == param
            }).first?.value!
        }
        return nil
    }
    
    var path: String {
        get {
            // There has to be a better way for this nightmare? (ScG)
            let defaultPath = "/"
            guard let path = self.url?.path else {
                return defaultPath
            }
            return path == "" ? defaultPath : path
        }
    }
    
    var host: String {
        get {
            return self.url?.host ?? ""
        }
    }
    
    public var absolutePath: String {
        get {
            return self.url?.string ?? ""
        }
    }
    
    static func sanitizeURL(_ str: String) -> URL {
        let str = str.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanUrl: URL?
        if (str.prefix(4) == "http" || str.prefix(5) == "https") {
            cleanUrl = URL(string: str)
        } else if (str.prefix(3) == "ios") {
            cleanUrl = URL(string: str)
        } else {
            cleanUrl = URL(string: "ios://\(str)") // Include some default transport type, if none was provided, just so that NSURL works
        }
        return cleanUrl! // How do I get rid of this unwrap
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let url = YURL(self.originalStr)
        url.url = self.url?.copy() as! NSURLComponents
        return url
    }
    
    public override var description: String {
        return self.url?.description ?? self.originalStr
    }
    
}
