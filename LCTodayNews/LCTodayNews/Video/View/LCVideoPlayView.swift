//
//  LCVideoPlayView.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/29.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import AVKit

public let AVPlayerShouldStop: NSNotification.Name = NSNotification.Name(rawValue: "AVPlayerShouldStop")
public let statusBarShouldHidden: NSNotification.Name = NSNotification.Name(rawValue: "statusBarShouldHidden")
public let statusBarShouldAppear: NSNotification.Name = NSNotification.Name(rawValue: "statusBarShouldAppear")

class LCVideoPlayView: LCPlayView {
    typealias EnevtsHandle = () -> ()
    typealias FullHandle = (UIDeviceOrientation) -> ()
    typealias HiddenHandle = (Bool) -> ()
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var loadImageV: UIImageView!
    
    @IBOutlet weak var shadeView: LCShadeView!
    @IBOutlet weak var videoTltleL: UILabel!
    @IBOutlet weak var playNumsL: UILabel!
    
    @IBOutlet weak var failView: UIView!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var allScreenButton: UIButton!
    @IBOutlet weak var beginTimeL: UILabel!
    @IBOutlet weak var endTimeL: UILabel!
    @IBOutlet weak var timeSlider: LCTimeSlider!
    
    @IBOutlet weak var titleLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var allScreenButtonWidthConstraint: NSLayoutConstraint!
    
    let loadImageAnimKey = "loadImageAnim"
    var oldOrientation: UIDeviceOrientation = .portrait
    var tap: UITapGestureRecognizer?
    weak var portraitSuperview: UIView?
    var beginFrame: CGRect = .zero
    var convertToWindowFrame: CGRect = .zero
    
    
    var tapHandle: EnevtsHandle?
    var didPlayHandle: EnevtsHandle?
    var didStopHandle: EnevtsHandle?
    
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
    
    
    var active = false
    var playing = false
    
    var video_duration: Int? {
        didSet {
            if let video_duration = video_duration {
                let min = video_duration / 60
                let sec = video_duration % 60
                
                let time = String(format: "%02d:%02d", min, sec)
                endTimeL.text = time
                beginTimeL.text = "00:00"
                timeSlider.value = 0
            }
        }
    }
    
    var timer: Timer?
    var playTimer: Timer?
    
    
    deinit {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        playButton.layer.cornerRadius = 24
        playButton.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayView))
        self.addGestureRecognizer(tap)
        self.tap = tap
        
        shadeView.colors = [
                            UIColor(r: 0, g: 0, b: 0, a: 0.8).cgColor,
                            UIColor(r: 0, g: 0, b: 0, a: 0.382).cgColor,
                            ]
        shadeView.startPoint = CGPoint(x: 0, y: 0)
        shadeView.endPoint = CGPoint(x: 0, y: 1)
        
        timeSlider.setThumbImage(UIImage(named: "audio_slider_image"), for: .normal)
        
        timeSlider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        timeSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        timeSlider.addTarget(self, action: #selector(sliderTouchCancel), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        
    }
    
    //MARK: - Private
    func play(urlString: String) {
        let decodeData = Data(base64Encoded: urlString, options: Data.Base64DecodingOptions(rawValue: 0))
        let url = String(data: decodeData!, encoding: .utf8)!
        let playerItem = AVPlayerItem.init(url: URL(string: url)!)
        
        let player = AVPlayer.init(playerItem: playerItem)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
        
        if self.player != nil {
            self.player?.removeObserver(self, forKeyPath: "timeControlStatus")
        }
        self.player = player
        
        player.play()
    }
    
    func didPlay() {
        stopLoadingAnim()
        addPlayTimer()
        
        playing = true
        self.backgroundColor = UIColor.black
        
        videoImage.isHidden = true
        shadeView.isHidden = true
        bottomView.isHidden = false
        playButton.isUserInteractionEnabled = true
        
        didPlayHandle?()
    }
    
    func pausePlay() {
        playing = false
        self.shadeView.isHidden = false
        self.player?.pause()
        
        removePlayTimer()
        removeHiddenShadeViewTimer()
    }
    
    func stopPlay() {
        stopLoadingAnim()
        pausePlay()
        
        active = false
        videoImage.isHidden = false
        failView.isHidden = true
        bottomView.isHidden = true
        
        playButton.isUserInteractionEnabled = false
        playButton.isSelected = false
        
        NotificationCenter.default.removeObserver(self)
        
        didStopHandle?()
    }
    
    func addPlayTimer() {
        playTimer = Timer(timeInterval: 1, repeats: true, block: {[weak self] _ in
            if let currentTime = self!.player?.currentTime() {
                let currentTimeSec = Int(currentTime.value) / Int(currentTime.timescale)
                let min = currentTimeSec / 60
                let sec = currentTimeSec % 60
                
                self?.beginTimeL.text = String(format: "%02d:%02d", min, sec)
                
                guard self!.video_duration != nil else {return}
                self?.timeSlider.value = Float(currentTimeSec) / Float(self!.video_duration!)
            }
        })
        RunLoop.current.add(playTimer!, forMode: .commonModes)
    }
    
    func removePlayTimer() {
        playTimer?.invalidate()
        playTimer = nil
    }
    
    func addHiddenShadeViewTimer() {
        timer = Timer(timeInterval: 2, repeats: false, block: {[weak self] _ in
            self?.shadeView.isHidden = true
            if self!.oldOrientation == .landscapeRight || self!.oldOrientation == .landscapeLeft {
                NotificationCenter.default.post(name: statusBarShouldHidden, object: nil)
            }
            self?.removeHiddenShadeViewTimer()
        })
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    func removeHiddenShadeViewTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func showFailView() {
        stopLoadingAnim()
        failView.isHidden = false
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
    
    func transform(_ orientation: UIDeviceOrientation) {
        let keyWindow = UIApplication.shared.keyWindow
        
        if orientation == .portrait {
            UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.portrait, animated: false)
            titleLeftConstraint.constant = 15
            allScreenButtonWidthConstraint.constant = 30
            titleTopConstraint.constant = 10
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
                self.playButton.transform = CGAffineTransform.identity
                self.frame = self.convertToWindowFrame
            }) { _ in
                self.removeFromSuperview()
                self.frame = self.beginFrame
                self.portraitSuperview?.addSubview(self)
                self.oldOrientation = orientation
            }
            
        }else {
            var transform: CGAffineTransform
            
            if self.oldOrientation == .portrait {
                titleLeftConstraint.constant = 30
                allScreenButtonWidthConstraint.constant = 36
                titleTopConstraint.constant = 30
                
                if orientation == .landscapeLeft {
                    transform  = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.5))
                    UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.landscapeRight, animated: false)
                }else {
                    transform  = CGAffineTransform(rotationAngle: -CGFloat(Double.pi * 0.5))
                    UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.landscapeLeft, animated: false)
                }
                
                let playBtnTransform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                
                
                self.beginFrame = self.frame
                self.convertToWindowFrame = self.convert(self.bounds, to: keyWindow)
                
                self.portraitSuperview = self.superview
                let strongSelf = self
                strongSelf.removeFromSuperview()
                keyWindow?.addSubview(strongSelf)
                self.frame = self.convertToWindowFrame
                
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.transform = transform
                    self.playButton.transform = playBtnTransform
                    self.bounds = CGRect(x: 0, y: 0, width: ScreenHeight, height: ScreenWidth)
                    self.center = keyWindow!.center
                }) { _ in
                    self.oldOrientation = orientation
                }
            }else {
                if orientation == .landscapeLeft {
                    transform  = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.5))
                    UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.landscapeRight, animated: false)
                }else {
                    transform  = CGAffineTransform(rotationAngle: -CGFloat(Double.pi * 0.5))
                    UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.landscapeLeft, animated: false)
                }
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.transform = transform
                }) { _ in
                    self.oldOrientation = orientation
                }
            }
        }
    }
    
    //MARK: - Events
    @objc func tapPlayView() {
        if active {
            if let player = player,  player.rate > 0{
                playButton.isSelected = true
                shadeView.isHidden = !shadeView.isHidden
                
                if shadeView.isHidden {
                    removeHiddenShadeViewTimer()
                    if oldOrientation == .landscapeRight || oldOrientation == .landscapeLeft {
                        NotificationCenter.default.post(name: statusBarShouldHidden, object: nil)
                    }
                }else{
                    NotificationCenter.default.post(name: statusBarShouldAppear, object: nil)
                    addHiddenShadeViewTimer()
                }
                
            }else {
                shadeView.isHidden = !shadeView.isHidden
                
                if oldOrientation == .landscapeRight || oldOrientation == .landscapeLeft {
                    if shadeView.isHidden {
                        NotificationCenter.default.post(name: statusBarShouldHidden, object: nil)
                    }else{
                        NotificationCenter.default.post(name: statusBarShouldAppear, object: nil)
                    }
                }
            }
            
            
            
        }else {
            
            NotificationCenter.default.post(name: AVPlayerShouldStop, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerShouldStop), name: AVPlayerShouldStop, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(sessionInterruptionHandle), name: Notification.Name.AVAudioSessionInterruption, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            
            
            active = true
            shadeView.isHidden = true
            startLoadingAnim()
            
            if let video_main_url = videoUrl {
                self.videoUrl = video_main_url
            }else {
                tapHandle?()
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
            addPlayTimer()
            addHiddenShadeViewTimer()
        }else{
            pausePlay()
        }
        
    }
    
    @IBAction func allscreen(_ sender: UIButton) {
        if oldOrientation == .portrait {
            transform(.landscapeLeft)
            oldOrientation = .landscapeLeft
            allScreenButton.isSelected = true
            
            shadeView.isHidden = true
            if shadeView.isHidden {
                NotificationCenter.default.post(name: statusBarShouldHidden, object: nil)
            }
        }else {
            transform(.portrait)
            oldOrientation = .portrait
            NotificationCenter.default.post(name: statusBarShouldAppear, object: nil)
            allScreenButton.isSelected = false
        }
    }
    
    @objc func sliderTouchDown() {
        print(1)
        removeHiddenShadeViewTimer()
        removePlayTimer()
    }
    
    @objc func sliderValueChanged(slide: UISlider) {
        print(2)
        
        if let currentTime = player?.currentTime(), let video_duration = video_duration {
            let currentTimeSec = Int(slide.value * Float(video_duration))
            let min = currentTimeSec / 60
            let sec = currentTimeSec % 60
            
            beginTimeL.text = String(format: "%02d:%02d", min, sec)
            let value = Int(slide.value * Float(video_duration)) * Int(currentTime.timescale)
            player?.seek(to: CMTime(value: CMTimeValue(value), timescale: currentTime.timescale))
        }
        
    }
    
    @objc func sliderTouchCancel() {
        addPlayTimer()
        addHiddenShadeViewTimer()
        print(3)
    }
    
    //MARK: - Observer Call
    @objc func playerShouldStop() {
        self.stopPlay()
    }
    
    @objc func playerDidEnd() {
        self.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        self.stopPlay()
        if oldOrientation != .portrait {
            transform(.portrait)
            oldOrientation = .portrait
            allScreenButton.isSelected = false
            NotificationCenter.default.post(name: statusBarShouldAppear, object: nil)
            
        }
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
    
    @objc func deviceOrientationDidChange(noti: Notification) {
        guard UIDevice.current.orientation != oldOrientation else{
            return
        }
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            transform(UIDevice.current.orientation)
            allScreenButton.isSelected = true
            if oldOrientation == .portrait {
                shadeView.isHidden = true
                if shadeView.isHidden {
                    NotificationCenter.default.post(name: statusBarShouldHidden, object: nil)
                }
            }
            oldOrientation = UIDevice.current.orientation
        case .portrait:
            transform(UIDevice.current.orientation)
            allScreenButton.isSelected = false
            NotificationCenter.default.post(name: statusBarShouldAppear, object: nil)
            oldOrientation = UIDevice.current.orientation
        default:
            break
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let _ = object as? AVPlayer, keyPath == "timeControlStatus", let timeControlStatus = change?[.newKey] as? Int, timeControlStatus == 2{
            if !playButton.isUserInteractionEnabled {
                didPlay()
            }
        }
    }
    
}
