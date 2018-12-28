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
    @IBOutlet weak var playButton: UIButton!
    
    let loadImageAnimKey = "loadImageAnim"
    
    var tagPalyViewHandle: TagHandle?
    var player: AVPlayer?
    var tap: UITapGestureRecognizer?
    
    var active = false
    var playing = false
    
    var timer: Timer? = Timer()
    
    var videoUrl: String? {
        willSet {
            guard active else { return }
            
            if let new = newValue {
                if new == videoUrl  {
                    if self.player != nil {
                        self.player?.play()
                    }else{
                        play(urlString: new)
                    }
                }else {
                    play(urlString: new)
                }
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
                videoImage.kf.setImage(with: URL(string: video_detail_info.detail_video_large_image.urlString), placeholder: UIImage())
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
        playView.backgroundColor = UIColor.white
        
        uploaderImageV.layer.cornerRadius = 17
        uploaderImageV.layer.masksToBounds = true
        uploaderImageV.layer.borderColor = UIColor.lightGray.cgColor
        uploaderImageV.layer.borderWidth = 0.5
        
        playButton.layer.cornerRadius = 24
        playButton.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayView))
        playView.addGestureRecognizer(tap)
        self.tap = tap
        

    }
    
    //MARK: - Private
    func play(urlString: String) {
        let decodeData = Data(base64Encoded: urlString, options: Data.Base64DecodingOptions(rawValue: 0))
        let url = String(data: decodeData!, encoding: .utf8)!
        let playerItem = AVPlayerItem.init(url: URL(string: url)!)
        
        let player = AVPlayer.init(playerItem: playerItem)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
        let playerLayer = playView.layer as! AVPlayerLayer
        playerLayer.player = player
        
        if self.player != nil {
            self.player?.removeObserver(self, forKeyPath: "timeControlStatus")
        }
        self.player = player
        
        player.play()
    }

    func didPlay() {
        stopLoadingAnim()
        playView.backgroundColor = UIColor.black
        tap?.isEnabled = true
        videoImage.isHidden = true
        shadeView.isHidden = true
        playButton.isUserInteractionEnabled = true
        playing = true
    }
    
    func stopPlay() {
        active = false
        playing = false
        stopLoadingAnim()
        failView.isHidden = true
        videoImage.isHidden = false
        shadeView.isHidden = false
        playButton.isUserInteractionEnabled = false
        playButton.isSelected = false
        player?.pause()
        timer?.invalidate()
        timer = nil
        
        NotificationCenter.default.removeObserver(self)
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
        if active {
            if let player = player,  player.rate > 0{
                playButton.isSelected = true
                shadeView.isHidden = !shadeView.isHidden
                
                if shadeView.isHidden {
                    self.timer?.invalidate()
                    self.timer = nil
                }else{
                    timer = Timer(timeInterval: 2, repeats: false, block: {[weak self] _ in
                        self?.shadeView.isHidden = true
                        self?.timer?.invalidate()
                        self?.timer = nil
                    })
                    RunLoop.current.add(timer!, forMode: .commonModes)
                }

            }else {
                shadeView.isHidden = !shadeView.isHidden
            }
        }else {
            
            NotificationCenter.default.post(name: AVPlayerShouldStop, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerShouldStop), name: AVPlayerShouldStop, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(sessionInterruptionHandle), name: Notification.Name.AVAudioSessionInterruption, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
 
            active = true
            shadeView.isHidden = true
            startLoadingAnim()
            
            if let video_main_url = videoUrl {
                self.videoUrl = video_main_url
            }else if let video_main_url = news?.video_main_url {
                self.videoUrl = video_main_url
            }else {
                tagPalyViewHandle?(news!)
            }
        }
  
    }
    @IBAction func replay(_ sender: Any) {
        failView.isHidden = true
        tapPlayView()
    }
    
    @IBAction func playButtonClick(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        if playButton.isSelected {
            self.player?.play()
            playing = true
            timer = Timer(timeInterval: 2, repeats: false, block: {[weak self] _ in
                self?.shadeView.isHidden = true
                self?.timer?.invalidate()
                self?.timer = nil
            })
            RunLoop.current.add(timer!, forMode: .commonModes)
        }else{
            playing = false
            self.shadeView.isHidden = false
            self.player?.pause()
            self.timer?.invalidate()
            self.timer = nil
        }
        
    }
    
    //MARK: - Observer Call
    @objc func playerShouldStop() {
        self.stopPlay()
    }
    
    @objc func playerDidEnd() {
        self.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        self.stopPlay()
    }
    
    @objc func sessionInterruptionHandle(noti: Notification) {
        if let type = noti.userInfo?[AVAudioSessionInterruptionTypeKey] as? AVAudioSessionInterruptionType, type == .began {
            if playing {
                self.player?.pause()
            }
        }else if let options = noti.userInfo?[AVAudioSessionInterruptionOptionKey] as? AVAudioSession.InterruptionOptions, options == .shouldResume {
            if playing {
                self.player?.play()
            }
        }
    }
    
    @objc func appWillResignActive() {
        if playing {
            self.player?.pause()
        }
    }
    
    @objc func appDidBecomeActive() {
        if playing {
            self.player?.play()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let timeControlStatus = change?[.newKey] as? Int, timeControlStatus == 2{
            if !playButton.isUserInteractionEnabled {
                didPlay()
            }
        }
    }
}
