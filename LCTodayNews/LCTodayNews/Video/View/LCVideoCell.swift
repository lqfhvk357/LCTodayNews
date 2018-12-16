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

public let AVPlayerShouldStop: NSNotification.Name = NSNotification.Name(rawValue: "AVPlayerShouldStop")

class LCVideoCell: UITableViewCell {
    
    typealias TagHandle = (_ news: LCHomeNewsDesc) -> Void

    @IBOutlet weak var playView: LCPlayView!
    @IBOutlet weak var shadeView: UIView!
    @IBOutlet weak var videoTltleL: UILabel!
    @IBOutlet weak var playNumsL: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var uploaderImageV: UIImageView!
    @IBOutlet weak var uploaderNameL: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var tagPalyViewHandle: TagHandle?
    var player: AVPlayer?
    
    
    var videoUrl: String? {
        didSet {
            guard let videoUrl = videoUrl else { return }

            let decodeData = Data(base64Encoded: videoUrl, options: Data.Base64DecodingOptions(rawValue: 0))
            let url = String(data: decodeData!, encoding: .utf8)!
            let playerItem = AVPlayerItem.init(url: URL(string: url)!)
            
            let player = AVPlayer.init(playerItem: playerItem)
            let playerLayer = playView.layer as! AVPlayerLayer
            playerLayer.player = player
            self.player = player
            
            play()
        }
    }
    var news: LCHomeNewsDesc? {
        didSet {
            guard let news = news else {
                return
            }
            
            videoUrl = nil
            stopPlay()
            
            videoTltleL.text = news.title
            commentButton.setTitle("\(news.comment_count)", for: .normal)
            if let video_detail_info = news.video_detail_info {
                videoImage.kf.setImage(with: URL(string: video_detail_info.detail_video_large_image.urlString))
                if video_detail_info.video_watch_count > 10000 {
                    let text = String(format: "%.2f万次播放", Double(video_detail_info.video_watch_count) / 10000.0)
                    playNumsL.text = text
                }else{
                    playNumsL.text = "\(video_detail_info.video_watch_count)次播放"
                }
            }
            
            if let user_info = news.user_info {
                uploaderImageV.kf.setImage(with: URL(string: user_info.avatar_url))
                uploaderNameL.text = user_info.name
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uploaderImageV.layer.cornerRadius = 17
        uploaderImageV.layer.masksToBounds = true
        uploaderImageV.layer.borderColor = UIColor.lightGray.cgColor
        uploaderImageV.layer.borderWidth = 0.5
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapShadeView))
        shadeView.addGestureRecognizer(tap)
        playView.backgroundColor = UIColor.black
        
        NotificationCenter.default.addObserver(forName: AVPlayerShouldStop, object: nil, queue: nil) { (notification) in
            self.stopPlay()
        }
    
        NotificationCenter.default.addObserver(forName: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { (notification) in
            self.stopPlay()
        }
        
//        NotificationCenter.default.addObserver(forName: AVPlayerItemd, object: nil, queue: nil) { ss in
//
//        }
//        NotificationCenter.default.addObserver(forName: AVPlayerItemDidPlayToEndTimeNotification, object: nil, queue: nil) { (notification) in
//            self.stopPlay()
//        }
        // Initialization code
    }

    func play() {
        videoImage.isHidden = true
        shadeView.isHidden = true
        player?.play()
    }
    
    func stopPlay() {
        videoImage.isHidden = false
        shadeView.isHidden = false
        player?.pause()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - Events
    @objc func tapShadeView(tap: UITapGestureRecognizer) {
        if let player = player,  player.rate > 0{
            
        }else {
            NotificationCenter.default.post(name: AVPlayerShouldStop, object: nil)
            if let video_main_url = videoUrl {
                self.videoUrl = video_main_url
            }else if let video_main_url = news?.video_main_url {
                self.videoUrl = video_main_url
            }else {
                tagPalyViewHandle?(news!)
            }
        }
  
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        print(change!)
        if let rate = keyPath, rate == "rate" {
        }
    }
}
