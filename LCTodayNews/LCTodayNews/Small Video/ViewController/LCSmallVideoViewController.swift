//
//  LCSmallVideoViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/11.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import SnapKit

class LCSmallVideoViewController: LCHomeBaseViewController {
    
    let animView = UIImageView()
    var beginFrame: CGRect?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    

    override func getTitles() {
        let defaultTitle = LCHomeNewsTitle.init(category: "hotsoon_video", name: "推荐", select: true)
        let newsTitle1 = LCHomeNewsTitle.init(category: "ugc_video_beauty", name: "颜值")
        let newsTitle2 = LCHomeNewsTitle.init(category: "ugc_video_food", name: "美食")
        self.titles = [defaultTitle, newsTitle1, newsTitle2]
    }
    
    override func setupTitleHeader() {
        
        let navBar = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: NavBarHeight))
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
        guard childViewControllerDict[newsTitle.category] == nil else{
            return
        }
        
        let selectVC = LCCollectionViewController()
        selectVC.newsTitle = newsTitle
        self.addChildViewController(selectVC)
        pageScrollView.addSubview(selectVC.view)
        let height = ScreenHeight - TabBarHeight - NavBarHeight
        selectVC.view.frame = CGRect(x: ScreenWidth*CGFloat(index), y: 0, width: ScreenWidth, height: height)
        childViewControllerDict[newsTitle.category] = selectVC
        
        selectVC.didSelectItemCell = { [weak self] cell in
            let vc = LCSmallVideoPlayViewController()
            vc.news = cell.news
            
            self?.animView.image = cell.backImageView.image
            let origin = cell.convert(CGPoint.zero, to: UIApplication.shared.keyWindow)
            self?.beginFrame = CGRect.init(origin: origin, size: cell.frame.size)
            self?.tabBarController?.tabBar.isHidden = true
            self?.navigationController?.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension LCSmallVideoViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push, toVC.isKind(of: LCSmallVideoPlayViewController.self), fromVC.isKind(of: LCSmallVideoViewController.self) {
            return AnimationController(with: .push)
        }

        if operation == .pop, fromVC.isKind(of: LCSmallVideoPlayViewController.self) {
            return AnimationController(with: .pop)
        }

        return nil
    }
}

extension LCSmallVideoViewController: UIGestureRecognizerDelegate{}
