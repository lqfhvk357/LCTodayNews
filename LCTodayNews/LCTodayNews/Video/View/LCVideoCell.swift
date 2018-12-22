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
    @IBOutlet weak var loadImageV: UIImageView!
    @IBOutlet weak var failView: UIView!
    @IBOutlet weak var replayButton: UIButton!
    
    let loadImageAnimKey = "loadImageAnim"
    
    var tagPalyViewHandle: TagHandle?
    var player: AVPlayer?
    var tap: UITapGestureRecognizer?
    
    var active = false
    
    
    var videoUrl: String? {
        didSet {
            guard active else { return }

            if let videoUrl = videoUrl{
                let decodeData = Data(base64Encoded: videoUrl, options: Data.Base64DecodingOptions(rawValue: 0))
                let url = String(data: decodeData!, encoding: .utf8)!
                let playerItem = AVPlayerItem.init(url: URL(string: url)!)
                
                let player = AVPlayer.init(playerItem: playerItem)
                let playerLayer = playView.layer as! AVPlayerLayer
                playerLayer.player = player
                self.player = player
                
                play()
            }else {
                showFailView()
            }
            
        }
    }
    
    var news: LCHomeNewsDesc? {
        didSet {
            stopPlay()
            videoUrl = nil
            
            guard let news = news else {
                tap?.isEnabled = false
                return
            }
            tap?.isEnabled = true
            
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
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayView))
        playView.addGestureRecognizer(tap)
        self.tap = tap
        
        NotificationCenter.default.addObserver(forName: AVPlayerShouldStop, object: nil, queue: nil) { (notification) in
            self.stopPlay()
        }
    
        NotificationCenter.default.addObserver(forName: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { (notification) in
            self.stopPlay()
        }
    
    }

    func play() {
        stopLoadingAnim()
        tap?.isEnabled = true
        videoImage.isHidden = true
        shadeView.isHidden = true
        player?.play()
    }
    
    func stopPlay() {
        active = false
        stopLoadingAnim()
        failView.isHidden = true
        videoImage.isHidden = false
        shadeView.isHidden = false
        player?.pause()
    }
    
    func startLoadingAnim() {
        let baseAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        baseAnim.fromValue = 0
        baseAnim.toValue = CGFloat(Double.pi*2)
        baseAnim.repeatCount = 10000
        baseAnim.duration = 1
        
        loadImageV.layer.add(baseAnim, forKey: loadImageAnimKey)
        loadImageV.isHidden = false
    }
    
    func stopLoadingAnim() {
        loadImageV.isHidden = true
        loadImageV.layer.removeAnimation(forKey: loadImageAnimKey)
    }
    
    func showFailView() {
        stopLoadingAnim()
        failView.isHidden = false
    }
    //MARK: - Events
    @objc func tapPlayView() {
        active = true
        if let player = player,  player.rate > 0{
            
        }else {
            NotificationCenter.default.post(name: AVPlayerShouldStop, object: nil)
            shadeView.isHidden = true
            
            if let video_main_url = videoUrl {
                self.videoUrl = video_main_url
            }else if let video_main_url = news?.video_main_url {
                self.videoUrl = video_main_url
            }else {
                startLoadingAnim()
                tagPalyViewHandle?(news!)
            }
        }
  
    }
    @IBAction func replay(_ sender: Any) {
        failView.isHidden = true
        tapPlayView()
    }
    
}
