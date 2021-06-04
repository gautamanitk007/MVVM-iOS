//
//  UIButton+Extension.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 29/5/21.
//

import Foundation
import UIKit

extension UIButton{
    public func setImage(image: UIImage, renderMode: UIImage.RenderingMode,state:UIControl.State ,semantics sym:UISemanticContentAttribute,alignment align:ContentHorizontalAlignment,left lEdge:CGFloat,right rEdge:CGFloat){
        self.semanticContentAttribute = sym
        self.contentHorizontalAlignment = align
        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(image.withRenderingMode(renderMode), for: state)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:8, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: lEdge, bottom: 0, right: lEdge)
        titleLabel?.textAlignment = .center
    }
  
}
