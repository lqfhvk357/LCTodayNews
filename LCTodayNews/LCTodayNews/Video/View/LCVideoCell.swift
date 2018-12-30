//
//  LCVideoCell.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit

class LCVideoCell: UITableViewCell {
    
    
    typealias TagHandle = (_ news: LCHomeNewsDesc) -> Void
    var oldOrientation: UIDeviceOrientation = .portrait
    

    lazy var playView: LCVideoPlayView = {
        let playView = LCVideoPlayView.lc_loadForBundle()
        
        playView.tapHandle = { [weak self] in
            if let url = self!.news?.video_main_url {
                playView.videoUrl = url
            }else{
                self!.tapPalyViewHandle?(self!.news!)
            }
        }
        return playView
    }()
    

    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var uploaderImageV: UIImageView!
    @IBOutlet weak var uploaderNameL: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var tapPalyViewHandle: TagHandle?
    
    var videoUrl: String? {
        didSet {
            playView.videoUrl = videoUrl
        }
    }
    
    var news: LCHomeNewsDesc? {
        didSet {
            playView.stopPlay()
            playView.videoUrl = nil
            
            guard let news = news else {
                playView.tap?.isEnabled = false
                return
            }
            playView.tap?.isEnabled = true
            
            playView.videoTltleL.text = news.title
            commentButton.setTitle("\(news.comment_count)", for: .normal)
            if let video_detail_info = news.video_detail_info {
                playView.videoImage.kf.setImage(with: URL(string: video_detail_info.detail_video_large_image.urlString), placeholder: UIImage())
                if video_detail_info.video_watch_count > 10000 {
                    let text = String(format: "%.2f万次播放", Double(video_detail_info.video_watch_count) / 10000.0)
                    playView.playNumsL.text = text
                }else{
                    playView.playNumsL.text = "\(video_detail_info.video_watch_count)次播放"
                }
            }
            
            if let user_info = news.user_info {
                uploaderImageV.kf.setImage(with: URL(string: user_info.avatar_url))
                uploaderNameL.text = user_info.name
            }
            self.playView.video_duration = news.video_duration
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(playView)
        
        playView.backgroundColor = UIColor.clear
        
        uploaderImageV.layer.cornerRadius = 17
        uploaderImageV.layer.masksToBounds = true
        uploaderImageV.layer.borderColor = UIColor.lightGray.cgColor
        uploaderImageV.layer.borderWidth = 0.5
        
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        playView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth*9/16)
    }
}
