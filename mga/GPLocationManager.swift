//
//  GPLocationManager.swift
//  mga
//
//  Created by Shaheen Ghiassy on 10/4/17.
//  Copyright © 2017 Shaheen Ghiassy. All rights reserved.
//


import CoreLocation

class GPLocationManager: NSObject, CLLocationManagerDelegate {
    
    public static let shared = GPLocationManager()
    var seenError : Bool = false
    var locationStatus : NSString = "Not Started"
    
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(45.522713, -122.672944)
    
    var locationManager: CLLocationManager!
    
    private override init() {
        seenError = false
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        self.currentLocation = coord
        print(coord.latitude)
        print(coord.longitude)
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case .restricted:
            locationStatus = "Restricted Access to location"
        case .denied:
            locationStatus = "User denied access to location"
        case .notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
}
