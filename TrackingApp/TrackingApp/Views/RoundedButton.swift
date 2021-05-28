//
//  RoundedButton.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import UIKit

class RoundedButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 6.0
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
}
