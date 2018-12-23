//
//  LCFakeNavBar.swift
//  LCPushNavBarAnimation
//
//  Created by 罗超 on 2018/12/18.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias TapHandle = ()->()

class LCFakeNavBar: UIView {
    
    @IBOutlet weak var whiteViewLeading: NSLayoutConstraint!
    @IBOutlet weak var whiteViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var hotBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tipsL: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    var tapHandle: TapHandle?
    var backClick: TapHandle?
    
    let bag = DisposeBag()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.navbarBarTint
        
        searchTF.alpha = 0
        arrowBtn.alpha = 0
        searchBtn.alpha = 0
        whiteView.layer.cornerRadius = 5
        whiteView.layer.masksToBounds = true
        
        print(whiteView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapWhite))
        whiteView.addGestureRecognizer(tap)
//        arrowBtn.rx.controlEvent(UIControlEvents.touchUpInside).subscribe {[weak self] _ in
//            backClick?()
//        }.disposed(by: bag)
    }

    //MARK: - Events
    @objc func tapWhite(tagGR: UITapGestureRecognizer) {
        tapHandle?()
        print("here")
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        backClick?()
    }
    
    //MARK: - Animate
    func readyPopAnim() {
        layoutIfNeeded()
        whiteViewLeading.constant = 15
        whiteViewTrailing.constant = 15
    }
    
    func popAnim() {
        searchBtn.alpha = 0
        searchTF.alpha = 0
        arrowBtn.alpha = 0
        
        tipsL.alpha = 1
        hotBtn.alpha = 1
        
        updateConstraints()
        layoutIfNeeded()
    }
    
    func cancelPopAnim() {
        whiteViewLeading.constant = 45
        whiteViewTrailing.constant = 58
    }
    
    func readyPushAnim() {
        layoutIfNeeded()
        whiteViewLeading.constant = 45
        whiteViewTrailing.constant = 58
    }
    
    func pushAnim() {
        searchBtn.alpha = 1
        searchTF.alpha = 1
        arrowBtn.alpha = 1
        
        tipsL.alpha = 0
        hotBtn.alpha = 0
        
        updateConstraints()
        layoutIfNeeded()
    }
}
