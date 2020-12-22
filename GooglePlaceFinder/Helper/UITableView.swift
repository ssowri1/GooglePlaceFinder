//
//  Collections.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import Foundation
import UIKit

public typealias nibName = String
public extension UITableView {
    func registerCell(name: nibName, bundle: Bundle?) {
        let nib = UINib(nibName: name, bundle: bundle)
        register(nib, forCellReuseIdentifier: name)
    }
    
    func registerHeaderFooterView(name: nibName, bundle: Bundle?) {
        let nib = UINib(nibName: name, bundle: bundle)
        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


// https://cocoacasts.com/dequeueing-reusable-views-with-generics-and-protocols
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
}
