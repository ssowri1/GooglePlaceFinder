//
//  NSObject.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import Foundation

class ParentObject: NSObject {
    
    var currentTimeInMilliSeconds: Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
}

extension NSObject {
    public class var onlyClassName: String {
        return String(describing: self).components(separatedBy: ".").last ?? ""
    }
}
