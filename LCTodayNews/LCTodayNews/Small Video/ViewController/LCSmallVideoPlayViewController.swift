//
//  LCSmallVideoPlayViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/11.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import AVKit
import SnapKit
import RxCocoa
import RxSwift


class LCSmallVideoPlayViewController: UIViewController {
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    let bag = DisposeBag()

    var news: LCVideoDesc? {
        didSet {
            
        }
        
    }
    
    let playView = LCPlayView()
    let animView = UIImageView()
    let closeBtn = UIButton()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.black
//        playView.frame = self.view.bounds
        self.view.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        animView.frame = self.view.bounds
        animView.contentMode = .scaleAspectFit
        self.view.addSubview(animView)
        
        
        closeBtn.setTitle("close", for: .normal)
        self.view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.left.equalTo(self.view).offset(100)
            make.width.height.equalTo(44)
        }
//        self.view.addSubview(playView)
//        playView.frame = self.view.bounds
//
        if let url = news?.raw_data.video.play_addr.url_list.first {
            let player = AVPlayer(url: URL(string: url)!)
            playView.player = player
            player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
            player.play()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.rx.controlEvent(.touchUpInside).subscribe {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: bag)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
            self.playView.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            self.playView.player?.play()
        }

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.playView.player?.pause()
        self.playView.player?.removeObserver(self, forKeyPath: "timeControlStatus")
        self.playView.player = nil
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let timeControlStatus = change?[.newKey] as? Int, timeControlStatus == 2{
            animView.removeFromSuperview()
        }
    }
}

