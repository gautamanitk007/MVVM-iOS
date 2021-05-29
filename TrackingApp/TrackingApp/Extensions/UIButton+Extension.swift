//
//  UIButton+Extension.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 29/5/21.
//

import Foundation
import UIKit

extension UIButton{
    public func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.semanticContentAttribute = .forceRightToLeft
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:8, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        titleLabel?.textAlignment = .center
    }
}
