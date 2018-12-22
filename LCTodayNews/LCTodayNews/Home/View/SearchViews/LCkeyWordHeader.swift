//
//  LCkeyWordHeader.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/21.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

typealias OpenHandle = (_ isOpen: Bool)->()

class LCkeyWordHeader: UICollectionReusableView {
    
    
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBackView: UIView!
    @IBOutlet weak var leftTitleL: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    
    var tapLeftView: OpenHandle?
    var tap: UITapGestureRecognizer?
    var isOpen = false
    let animTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    
    func setup(is open: Bool, section: Int) {
        isOpen = open
        switch section {
        case 1:
            leftTitleL.text = "历史记录"
            leftImageView.image = UIImage(named: "seemore_all_press")
            leftImageView.transform = isOpen ? animTransform : CGAffineTransform.identity
            rightBtn.setBackgroundImage(UIImage(named: "search_delete_night"), for: .normal)
            tap?.isEnabled = true
        case 2:
            leftTitleL.text = "猜你想搜的"
            leftImageView.image = nil
            rightBtn.setBackgroundImage(UIImage(named: "search_recommend_hide_night"), for: .normal)
            tap?.isEnabled = false
        default:
            tap?.isEnabled = false
            break
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(click))
        leftBackView.addGestureRecognizer(tap)
        self.tap = tap
    }
    
    @objc func click() {
        
        isOpen = !isOpen
        UIView.animate(withDuration: 0.25) {
            self.leftImageView.transform = self.isOpen ? self.animTransform : CGAffineTransform.identity
        }
        tapLeftView?(isOpen)
    }
}
