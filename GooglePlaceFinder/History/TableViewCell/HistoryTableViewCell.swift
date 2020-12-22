//
//  HistoryTableViewCell.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    var data: Places? {
        didSet {
            if let placeID = data?.placeID, let name = data?.name {
                titleLabel?.text = "\(placeID)). " + "\(name)"
            }
        }
    }
}
