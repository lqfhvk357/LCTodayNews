//
//  LCShadeView.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

class LCShadeView: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let gradientLayer = layer as! CAGradientLayer
        
        let startColor = UIColor(r: 0, g: 0, b: 0, a: 0.8)
        let endColor = UIColor(r: 0, g: 0, b: 0, a: 0.2)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.45)
        
    }
}
