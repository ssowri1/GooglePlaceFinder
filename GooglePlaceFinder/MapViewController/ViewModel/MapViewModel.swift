//
//  MapViewModel.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import GoogleMaps

class MapViewModel: ParentObject {
    
    var db: DBHelper = DBHelper()

    func insertPlace(_ response: GMSAddress, locality: String) {
        db.insert(name: locality, latitude: response.coordinate.latitude, longitude: response.coordinate.longitude)
    }
    
    func configureMarker(_ coordinate: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = AppConstants.youAreHere
        marker.appearAnimation = .pop
        return marker
    }
}
