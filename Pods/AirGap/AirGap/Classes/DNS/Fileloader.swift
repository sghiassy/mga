//
//  Fileloader.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/4/17.
//

import Foundation
import Yaml

enum AirGapConfigError: Error {
    case AirGapConfigFileMissing
    case AirGapConfigMissingRequiredInfo
    case DomainConfigFileMissing
    case InvalidYamlDocument
    case RequiredInfoMissing
}

class Fileloader: NSObject {
    
    private static let AIRGAP_CONFIG_FILENAME: String = "Airgap"
    private static let AIRGAP_CONFIG_FILENAME_EXT: String = "json"
    
    public class func loadAirgapConfig() throws -> AirgapConfigModel {
        guard let doc = Fileloader.loadfile(fileName: AIRGAP_CONFIG_FILENAME, fileType: AIRGAP_CONFIG_FILENAME_EXT, inBundle: Bundle(identifier: Bundle.main.bundleIdentifier!)!) else {
            throw AirGapConfigError.AirGapConfigFileMissing
        }
        
        var json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: doc.data(using: .utf8)!)
        } catch {
            print(error)
        }
        
        guard let config = json as? [String: Any],
              let domains = config["domains"] as? [[String: Any]] else {
            throw AirGapConfigError.AirGapConfigMissingRequiredInfo
        }
    
        return AirgapConfigModel(config: domains)
    }
    
    public class func loadfile(fileName: String, fileType: String, inBundle bundle: Bundle) -> String? {
        guard let path = bundle.path(forResource: fileName, ofType: fileType) else {
            return nil
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content
        } catch {
            return nil
        }
    }
    
    public class func loadYamlFile(fileName: String, bundleIdentifier: String) throws -> Yaml {
        // Load the YAML document from disk
        guard let yamlDoc = Fileloader.loadfile(fileName: fileName, fileType: "yaml", inBundle: Bundle(identifier: bundleIdentifier)!) else {
            throw AirGapConfigError.DomainConfigFileMissing
        }
        
        // Attempt to parse the YAML file
        guard let yamlFile: Yaml = try! Yaml.load(yamlDoc) else {
            throw AirGapConfigError.InvalidYamlDocument
        }
        
        return yamlFile
    }
    
    public class func RouteHandlerForBundleId(_ bundleIdentifier: String, inFile routeHandlerFileName:String) -> RouteHandler {
        // Get the Route Handler as defined in the spec
        let b = Bundle(identifier: bundleIdentifier)
        let namespace = b?.infoDictionary!["CFBundleExecutable"] as! String;
        let fileName = "\(namespace).\(routeHandlerFileName)"
        let classInst = NSClassFromString(fileName) as! RouteHandler.Type
        // TODO: Need to provide exception handling to verify that the RouteHandler specified can be loaded from disk. Otherwise, a generic nil exception is thrown here
        return classInst.init()
    }
    
}

