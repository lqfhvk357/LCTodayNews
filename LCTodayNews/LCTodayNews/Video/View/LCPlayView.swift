//
//  LCPlayView.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import AVKit

class LCPlayView: UIView {

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        didSet {
            let playerLayer = self.layer as! AVPlayerLayer
            playerLayer.player = self.player
        }
    }
    
    convenience init(frame: CGRect, player: AVPlayer) {
        self.init(frame: frame)
        self.player = player
        let playerLayer = self.layer as! AVPlayerLayer
        playerLayer.player = self.player
        playerLayer.videoGravity = .resizeAspectFill
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

}
