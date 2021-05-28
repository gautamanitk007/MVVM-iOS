//
//  RoundedView.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit

class RoundedView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        layer.cornerRadius = 4.0
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
}
