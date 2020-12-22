//
//  HistoryViewModel.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import Foundation

class HistoryViewModel: NSObject {
    
    var places: [Places] = []
    var db: DBHelper = DBHelper()

    override init() {
        places = db.read()
    }
    
    var numberOfRows: Int {
        return places.count
    }
    
    func getPlace(index: Int) -> Places {
        return places[index]
    }
}
