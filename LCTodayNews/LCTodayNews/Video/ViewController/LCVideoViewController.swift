//
//  LCVideoViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import Alamofire

class LCVideoViewController: LCPageViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    override var prefersStatusBarHidden: Bool {return shouldHiddenStatus}
    
    var request: DataRequest?
    var shouldHiddenStatus = false
    
    
    lazy var navBar: LCFakeNavBar = {
        let navBar = Bundle.main.loadNibNamed("LCFakeNavBar", owner: nil, options: nil)?.last as! LCFakeNavBar
        navBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: NavBarHeight)
        navBar.tapHandle = { [weak self] in
            let vc = LCSearchResultsViewController()
            //            self?.tabBarController?.tabBar.isHidden = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return navBar
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenStatusBar), name: statusBarShouldHidden, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appearStatusBar), name: statusBarShouldAppear, object: nil)
    }
    

    //MARK: - Datas
    override func getTitles() {
        
        if let titles = LCHomeNewsTitle.readNewsTitles(for: KVideoTitlesKey) {
            self.titles = titles
            self.updateSelectTitle(in: 0)
        }else{
            let defaultTitle = LCHomeNewsTitle.init(category: "video", name: "推荐", select: true)
            self.titles.append(defaultTitle)
            request = LCServerTool.requestVideoTiltes { data in
                switch data.result {
                case .success(let responseData):
                    let json = JSON(responseData)
                    print(json)
                    
                    if let titleDatas = LCVideoTitleData.modelform(data: responseData){
                        self.titles = titleDatas.data
                        self.titles.insert(defaultTitle, at: 0)
                        self.reloadViews()
                        
                        LCHomeNewsTitle.save(newsTitles: self.titles as! [LCHomeNewsTitle], for: KVideoTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func selectVC(_ index: Int) {
        NotificationCenter.default.post(name: AVPlayerShouldStop, object: nil)
        
        let newsTitle = self.titles[index]
        print(newsTitle)
        guard childViewControllerDict[newsTitle.pageTitleID] == nil else{
            return
        }
        
        let selectVC = LCVideoTableViewController()
        selectVC.newsTitle = newsTitle
        self.addChildViewController(selectVC)
        pageScrollView.addSubview(selectVC.view)
        let height = ScreenHeight - NavBarHeight - TabBarHeight - titleHeader.lc_height
        selectVC.view.frame = CGRect(x: ScreenWidth*CGFloat(index), y: 0, width: ScreenWidth, height: height)
        childViewControllerDict[newsTitle.pageTitleID] = selectVC
    }

    //MARK: - Views
    override func setupTitleHeader() {
        super.setupTitleHeader()
        self.view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(NavBarHeight)
        }
    }
    
    //MARK: -
    
    @objc func hiddenStatusBar() {
        shouldHiddenStatus = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func appearStatusBar() {
        shouldHiddenStatus = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
