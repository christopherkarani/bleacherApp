//
//  CollectionView+Ext.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import UIKit

extension UICollectionView {
    /// set a `UILabel` on screen with a message, for use when there is not data to display
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 38)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }
    func restore() {
        self.backgroundView = nil
    }
}
