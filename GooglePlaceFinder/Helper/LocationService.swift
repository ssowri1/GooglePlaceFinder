//
//  LocationService.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import CoreLocation
import GoogleMaps

protocol LocationServiceDelegate: class {
    func trackingLocation(coordinate: CLLocationCoordinate2D, shouldSave: Bool)
}

public class LocationService: NSObject {
    weak var delegate: LocationServiceDelegate?
    public static var shared = LocationService()
    let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = CLLocationDistance(AppConstants.locationDistance)
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        super.init()
        locationManager.delegate = self
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            delegate?.trackingLocation(coordinate: location.coordinate, shouldSave: false)
        }
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .restricted,.denied,.notDetermined:
            fatalError(AppConstants.locationPermisionAlert)
        default: manager.startUpdatingLocation()
        }
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        manager.stopUpdatingLocation()
    }
}
