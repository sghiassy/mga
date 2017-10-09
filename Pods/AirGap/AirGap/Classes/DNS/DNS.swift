//
//  DNS.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import Foundation
import Yaml

public class DNS: NSObject {
    
    var servers: [String: Server] = [:]
    
    override init() {
        super.init()
        
        // Setup Configuration on boot
        let airgapConfig = try! Fileloader.loadAirgapConfig()
        for domainConfig in airgapConfig.domainConfigs {
            try! self.loadDomainConfig(filename: domainConfig["configFile"]!, bundleIdentifier: domainConfig["bundleId"]!) // need to switch string to types
        }
    }
    
    public func serverForDomain(_ domain: String) -> Server? {
        return self.servers[domain]
    }
    
    public func loadDomainConfig(filename: String, bundleIdentifier: String) throws {
        let yamlFile = try! Fileloader.loadYamlFile(fileName: filename, bundleIdentifier: bundleIdentifier)
        
        // Pull required information from YAML doc
        guard let domainDefinition = yamlFile["domain"].dictionary,
              let routeHandlerFileName = yamlFile["routeHandler"].string,
              let host = domainDefinition["url"]?.string else {
            throw AirGapConfigError.RequiredInfoMissing
        }
        
        // Instantite the RouteHandler class dynamically from filename defined in Yaml
        let routeHandler = Fileloader.RouteHandlerForBundleId(bundleIdentifier, inFile:routeHandlerFileName)
        
        // Instantiate Server
        let server = Server(domain:host, routeHandler:routeHandler, config: try! DomainConfigModel(config: yamlFile))
        
        // Save in Config
        if (self.servers[server.hostname] == nil) {
            self.servers[server.hostname] = server
        } else {
            preconditionFailure("\(server.hostname) is a Duplicate domain name")
        }
        
        // Also save a reference to the server for each domain alias specified in the configuration
        let aliases = yamlFile["aliases"].array
        aliases?.forEach({ (aliasEntry) in
            guard let alias = aliasEntry["host"].string else { return }
            if (self.servers[alias] == nil) {
                debugPrint("Adding alias \(alias) for \(server.hostname)")
                self.servers[alias] = server
            } else {
                preconditionFailure("\(alias) is a Duplicate alias name")
            }
        })
        
        print("Updated DNSConfig with server: \(server)")
    }
    
}
