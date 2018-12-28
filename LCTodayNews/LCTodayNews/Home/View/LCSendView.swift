
//
//  LCSendView.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/21.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import Spring

class LCSendView: UIView {
    @IBOutlet weak var shadeView: LCShadeView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionShadowView: UIView!
    @IBOutlet weak var animView: SpringView!
    
    let animTransform = CGAffineTransform(scaleX: 0.3, y: 0.3).translatedBy(x: 0, y: 100)
    let spriTransform = CGAffineTransform(scaleX: 0.98, y: 0.98)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        closeImage.layer.cornerRadius = 18
        closeImage.layer.shadowRadius = 5
        closeImage.layer.shadowColor = UIColor.black.cgColor
        closeImage.layer.shadowOpacity = 0.1
        closeImage.layer.shadowOffset = CGSize(width: 0, height: 0)
//        closeImage.layer.masksToBounds = true
        
        shadeView.colors = [UIColor(r: 255, g: 255, b: 255, a: 0).cgColor, UIColor(r: 255, g: 255, b: 255, a: 0.95).cgColor]
        shadeView.startPoint = CGPoint(x: 0, y: 0)
        shadeView.endPoint = CGPoint(x: 0, y: 0.5)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.layer.cornerRadius = 25
        collectionView.layer.masksToBounds = true
        
        collectionShadowView.layer.cornerRadius = 25
        collectionShadowView.layer.shadowRadius = 5
        collectionShadowView.layer.shadowColor = UIColor.black.cgColor
        collectionShadowView.layer.shadowOpacity = 0.5
        collectionShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        animView.backgroundColor = UIColor.clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.animView.transform = self.animTransform
            self.animView.alpha = 0
            self.shadeView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func show() {
//        animView.transform = animTransform
//        animView.alpha = 0
        shadeView.alpha = 0
        
        
        animView.scaleX = 0.3
        animView.scaleY = 0.3
        animView.animation = "slideUp"
        animView.curve = "easeIn"
        animView.duration = 0.5
        animView.animate()
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
//                self.animView.transform = CGAffineTransform.identity
//                self.animView.alpha = 1
                self.shadeView.alpha = 1
            })
            
//            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
//                self.animView.transform = self.spriTransform
//            })
            
        }, completion: nil)
    }
}
