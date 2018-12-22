//
//  LCLoadingView.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/21.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

class LCLoadingView: UIView {

    lazy var toutiaoL: UILabel = {
        let labal = UILabel()
        labal.font = UIFont.boldSystemFont(ofSize: 33)
        labal.textColor = UIColor.black
        labal.text = "今日头条"
        return labal
    }()
    
    let greenlayer = CALayer()
    let redlayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.init(0xF5F5F5)
        self.addSubview(toutiaoL)
        toutiaoL.frame = CGRect(x: 200, y: 200, width: 149, height: 40)
        toutiaoL.center = self.center
        
        greenlayer.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        layer.addSublayer(greenlayer)
        let toutiaFrame = toutiaoL.frame
        greenlayer.frame = toutiaFrame
//
        redlayer.path = setupPath().cgPath
        redlayer.fillColor =  UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
        greenlayer.addSublayer(redlayer)
//
        greenlayer.mask = toutiaoL.layer
        toutiaoL.frame = greenlayer.bounds
        
//        anim()
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
    
    func anim() {
        let baseAnim = CABasicAnimation(keyPath: "transform")
        baseAnim.toValue = CATransform3DMakeTranslation(150, 0, 0)
        baseAnim.duration = 1
        baseAnim.repeatCount = 10000
        redlayer.add(baseAnim, forKey: nil)
    }
    
    func setupPath() -> UIBezierPath {
        let bzPath = UIBezierPath()
        
        bzPath.move(to: CGPoint(x: 0, y: 0))
        bzPath.addLine(to: CGPoint(x: 10, y: 40))
        bzPath.addLine(to: CGPoint(x: 30, y: 40))
        bzPath.addLine(to: CGPoint(x: 20, y: 0))
        bzPath.addLine(to: CGPoint(x: 0, y: 0))
        bzPath.close()
        return bzPath
    }

}
