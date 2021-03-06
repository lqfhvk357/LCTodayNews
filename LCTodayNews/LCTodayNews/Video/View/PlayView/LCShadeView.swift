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
    
    var colors: [CGColor]? = [UIColor(r: 0, g: 0, b: 0, a: 0.9).cgColor, UIColor(r: 0, g: 0, b: 0, a: 0.382).cgColor] {
        didSet {
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.colors = colors
        }
    }
    
    // 0 ~ 1
    var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.startPoint = startPoint
        }
    }
    var endPoint = CGPoint(x: 0, y: 1) {
        didSet {
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.endPoint = endPoint
        }
    }
    
    //
    var locations: [NSNumber]? {
        didSet {
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.locations = locations
        }
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
        
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
    }
}
