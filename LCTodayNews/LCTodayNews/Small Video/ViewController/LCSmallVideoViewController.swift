//
//  LCSmallVideoViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/11.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import SnapKit

class LCSmallVideoViewController: LCPageViewController {
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    override var prefersStatusBarHidden: Bool {return shouldHiddenStatusBar}
    
    var shouldHiddenStatusBar = false
    let navBar = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: NavBarHeight))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldHiddenStatusBar = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    //MARK: - Datas
    override func getTitles() {
        let defaultTitle = LCHomeNewsTitle.init(category: "hotsoon_video", name: "推荐", select: true)
        let newsTitle1 = LCHomeNewsTitle.init(category: "ugc_video_beauty", name: "颜值")
        let newsTitle2 = LCHomeNewsTitle.init(category: "ugc_video_food", name: "美食")
        self.titles = [defaultTitle, newsTitle1, newsTitle2]
    }
    
    //MARK: - Views
    override func setupTitleHeader() {
        navBar.backgroundColor = UIColor.white
        self.view.addSubview(navBar)
        
        navBar.addSubview(self.titleHeader)
        self.titleHeader.snp.makeConstraints({ make in
            make.left.right.bottom.equalTo(navBar)
            make.height.equalTo(titleHeight)
        })
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        navBar.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(navBar)
            make.height.equalTo(0.3)
        }
    }
    
    override func setupPageScrollView() {
        super.setupPageScrollView()
        pageScrollView.frame = CGRect(x: 0, y: NavBarHeight, width: ScreenWidth, height: ScreenHeight)
    }

    override func selectVC(_ index: Int) {
        let newsTitle = self.titles[index]
        print(newsTitle)
        guard childViewControllerDict[newsTitle.pageTitleID] == nil else{
            return
        }
        
        let selectVC = LCCollectionViewController()
        selectVC.newsTitle = newsTitle
        self.addChildViewController(selectVC)
        pageScrollView.addSubview(selectVC.view)
        let height = ScreenHeight - TabBarHeight - NavBarHeight
        selectVC.view.frame = CGRect(x: ScreenWidth*CGFloat(index), y: 0, width: ScreenWidth, height: height)
        childViewControllerDict[newsTitle.pageTitleID] = selectVC
        
        selectVC.didSelectItemCell = { [weak self] cell in
            let vc = LCSmallVideoPlayViewController()
            vc.news = cell.news
            let origin = cell.convert(CGPoint.zero, to: UIApplication.shared.keyWindow)
            vc.beginFrame = CGRect.init(origin: origin, size: cell.frame.size)
            vc.animView.image = cell.backImageView.image
            vc.fakeTabBar = self?.tabBarController?.tabBar.snapshotView(afterScreenUpdates: false)
//            vc.fakeWindow = UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: false)
            vc.fakeNavBar = self?.navBar.snapshotView(afterScreenUpdates: true)
            self?.shouldHiddenStatusBar = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



