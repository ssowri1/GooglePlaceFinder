//
//  GoogleMapService.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import GoogleMaps

class GoogleMapService: NSObject {
    static func getAddressFromLatLong(position: CLLocationCoordinate2D, handler: @escaping(_ address: GMSAddress) -> Void) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            if let location = response?.firstResult() {
                let lines = location as GMSAddress
                handler(lines)
            }
        }
    }
    
    func geoCoder(address: String, handler: @escaping(_ coordinate: CLLocationCoordinate2D) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                handler(coordinates)
            }
        })
    }
}
