//
//  LCHomeViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa
import SnapKit
import Alamofire
import Spring

class LCHomeViewController: LCPageViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    var titlesRequest: DataRequest?
    var otherTitlesRequest: DataRequest?
    let bag = DisposeBag()
    
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
    
    lazy var titleView: LCAllTitleView = {
        let titleV = LCAllTitleView.lc_loadForBundle()
        titleV.completion = { [weak self] completionTitles, titleShouldScroll, selectIndex in
            self?.reloadAllViews(titles: completionTitles[0], others: completionTitles[1], selectIndex: selectIndex)
        }
        
        return titleV
    }()

    let springView = SpringView()
    
    lazy var moreTitleButton: UIButton = {
        let moreTitleButton = UIButton()
        moreTitleButton.setImage(UIImage(named: "add_channel_titlbar_thin_new"), for: .normal)
        moreTitleButton.rx.controlEvent(.touchUpInside).subscribe {[weak self] _ in
            self?.showTitlesView()
            }.disposed(by: bag)
        return moreTitleButton
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradLayer = CAGradientLayer()
        let startColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6).cgColor
        let endColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        gradLayer.colors = [startColor, endColor]
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 0.3, y: 0)
        return gradLayer
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let searchButton = UIButton()
//        searchButton.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
//        searchButton.backgroundColor = UIColor.yellow
//        searchButton.rx.controlEvent(.touchUpInside).subscribe {[weak self] _ in
//            let vc = LCSearchResultsViewController()
//            vc.view.backgroundColor = UIColor.white
//            let search = LCSearchViewController.init(searchResultsController: vc)
//            search.searchBar.text = "shou"
//            search.searchBar.tintColor = UIColor.white
//            search.searchBar.barTintColor = UIColor.black
//            search.searchBar.barStyle = .black
//            search.searchBar.setValue("取消", forKey: "_cancelButtonText")
//            self?.present(search, animated: true, completion: nil)
//        }.disposed(by: bag)
//
//        self.navigationItem.titleView = searchButton
    }
    
    //MARK: - Datas
    override func getTitles() {
        
        if let titles = LCHomeNewsTitle.readNewsTitles(for: KHomeTitlesKey) {
            self.titles = titles
            self.updateSelectTitle(in: 0)
        }else{
            let defaultTitle = LCHomeNewsTitle.init(category: "", name: "推荐", select: true)
            self.titles.append(defaultTitle)
            titlesRequest = LCServerTool.requestHomeTiltes { data in
                switch data.result {
                case .success(let responseData):
                    //                    let json = JSON(response.data)
                    //                    print(json)
                    
                    if let titleDatas = LCHomeNewsTitleData.modelform(data: responseData){
                        self.titles = titleDatas.data.data
                        self.titles.insert(defaultTitle, at: 0)
                        self.reloadViews()
                        
                        LCHomeNewsTitle.save(newsTitles: self.titles as! [LCHomeNewsTitle], for: KHomeTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        getOtherTitles()
    }
    
    func getOtherTitles() {
        
        if let otherTitles = LCHomeNewsTitle.readNewsTitles(for: KHomeOtherTitlesKey) {
            self.others = otherTitles
        }else{
            otherTitlesRequest = LCServerTool.requestHomeMoreTitles { data in
                switch data.result {
                case .success(let responseData):
                    if let titleDatas = LCHomeNewsTitleData.modelform(data: responseData){
                        self.others = titleDatas.data.data
                        LCHomeNewsTitle.save(newsTitles: titleDatas.data.data, for: KHomeOtherTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    
    override func selectVC(_ index: Int) {
        if self.titles[selectIndex].pageTitleID == "video" {
            NotificationCenter.default.post(name: AVPlayerShouldStop, object: nil)
        }
        
        let newsTitle = self.titles[index]
        print(newsTitle)
        guard childViewControllerDict[newsTitle.pageTitleID] == nil else{
            return
        }
        
        var selectVC: UIViewController & LCPageTitleProtocol
        
        switch newsTitle.pageTitleID {
        case "video":
            selectVC = LCVideoTableViewController()
        case "hotsoon_video":
            selectVC = LCCollectionViewController()
        default:
            selectVC = LCHomeNewsController()
        }
        
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
        
        let btnBackV = UIView()
        self.view.addSubview(btnBackV)
        btnBackV.snp.makeConstraints { make in
            make.right.equalTo(self.view)
            make.centerY.equalTo(titleHeader)
            make.height.equalTo(43)
            make.width.equalTo(btnBackV.snp.height)
        }
        
        btnBackV.layer.addSublayer(gradientLayer)
        
        btnBackV.addSubview(moreTitleButton)
        moreTitleButton.snp.makeConstraints{ $0.edges.equalTo(btnBackV) }
    }
    
    override func setupPageScrollView() {
        super.setupPageScrollView()
        self.pageScrollView.frame = CGRect(x: 0, y: NavBarHeight+titleHeight, width: ScreenWidth, height: ScreenHeight)
    }
    
    func showTitlesView() {
        titleView.enChange = false
        titleView.titles = [self.titles as! [LCHomeNewsTitle], self.others as! [LCHomeNewsTitle]]
        titleView.show()

//        springView.backgroundColor = UIColor.blue
//        view.addSubview(springView)
//        springView.snp.makeConstraints { (make) in
//            make.width.height.equalTo(100)
//            make.center.equalTo(view)
//        }
//        springView.animation = "fadeInDown"
//        springView.curve = "easeIn"
//        springView.duration = 1
//        springView.animate()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = moreTitleButton.bounds
    }
    
    

}

