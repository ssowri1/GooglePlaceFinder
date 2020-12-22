//
//  DBModel.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

class Places {
    var name: String?
    var placeID: Int?
    var latitude: Double?
    var longitude: Double?
    init(name: String, placeID: Int, latitude: Double, longitude: Double) {
        self.name = name
        self.placeID = placeID
        self.latitude = latitude
        self.longitude = longitude
    }
}
