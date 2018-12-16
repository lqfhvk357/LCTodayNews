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

class LCHomeViewController: LCHomeBaseViewController {
    
    let bag = DisposeBag()
    
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
        gradLayer.endPoint = CGPoint(x: 0.618, y: 0)
        return gradLayer
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Datas
    override func getTitles() {
        
        if let titles = LCHomeNewsTitle.readNewsTitles(for: KHomeTitlesKey) {
            self.titles = titles
            self.updateSelectTitle(in: 0)
        }else{
            let defaultTitle = LCHomeNewsTitle.init(category: "", name: "推荐", select: true)
            self.titles.append(defaultTitle)
            LCServerTool.requestHomeTiltes { data in
                switch data.result {
                case .success(let responseData):
                    //                    let json = JSON(response.data)
                    //                    print(json)
                    
                    if let titleDatas = LCHomeNewsTitleData.modelform(data: responseData){
                        self.titles = titleDatas.data.data
                        self.titles.insert(defaultTitle, at: 0)
                        self.titleHeader.reloadData()
                        
                        LCHomeNewsTitle.save(newsTitles: self.titles, for: KHomeTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func getOtherTitles() {
        
        if let otherTitles = LCHomeNewsTitle.readNewsTitles(for: KHomeOtherTitlesKey) {
            self.others = otherTitles
        }else{
            LCServerTool.requestHomeMoreTitles { data in
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
        let newsTitle = self.titles[index]
        print(newsTitle)
        guard childViewControllerDict[newsTitle.category] == nil else{
            return
        }
        
        let selectVC = LCHomeNewsController()
        selectVC.newsTitle = newsTitle
        self.addChildViewController(selectVC)
        pageScrollView.addSubview(selectVC.view)
        let height = ScreenHeight - NavBarHeight - TabBarHeight - titleHeader.height
        selectVC.view.frame = CGRect(x: ScreenWidth*CGFloat(index), y: 0, width: ScreenWidth, height: height)
        childViewControllerDict[newsTitle.category] = selectVC
    }
    
    //MARK: - Views
    override func setupTitleHeader() {
        super.setupTitleHeader()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = moreTitleButton.bounds
    }

}

