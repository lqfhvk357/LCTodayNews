//
//  LCHomeViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/29.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import SnapKit
import PromiseKit
import Alamofire
import CoreLocation
import RxCocoa
import RxSwift
import SwiftyJSON

class LCHomeViewController: UIViewController  {
    
    fileprivate var titles : [LCHomeNewsTitle] = []
    fileprivate var others : [LCHomeNewsTitle] = []
    fileprivate var childViewControllerDict: Dictionary<String, UIViewController> = [:]
    fileprivate var selectIndex = 0
    
    fileprivate weak var collectionView: UICollectionView?
    fileprivate weak var pageScrollView: LCHomePageScrollView?
    lazy var titleView: LCAllTitleView = {
        let titleV = LCAllTitleView.lc_loadForBundle()
        titleV.completion = { [weak self] completionTitles, titleShouldScroll, selectIndex in

            self?.selectIndex = selectIndex
            self?.titles = completionTitles[0]
            self?.others = completionTitles[1]
            
            LCHomeNewsTitle.save(newsTitles: self!.titles, for: KHomeTitlesKey)
            LCHomeNewsTitle.save(newsTitles: self!.others, for: KHomeOtherTitlesKey)
            
            self!.collectionView?.reloadData()
        }
        
        return titleV
    }()

    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.getTitles()
        self.getOtherTitles()
        self.sutupViews()
        
        
        
    }
    
    //MARK: - Datas
    fileprivate func getTitles() {
        
        if let titles = LCHomeNewsTitle.readNewsTitles(for: KHomeTitlesKey) {
            self.titles = titles
            self.updateSelectTitle(in: 0)
        }else{
            LCServerTool.requestHomeTiltes { result in
                switch result {
                case .success(let response):
//                    let json = JSON(response.data)
//                    print(json)
                    
                    if let titleDatas = LCHomeNewsTitleData.modelform(response: response){
                        self.titles = titleDatas.data.data
                        let defaultTitle = LCHomeNewsTitle.init(category: "", name: "推荐", select: true)
                        self.titles.insert(defaultTitle, at: 0)
                        self.collectionView?.reloadData()
                        
                        LCHomeNewsTitle.save(newsTitles: self.titles, for: KHomeTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    fileprivate func getOtherTitles() {
        
        if let otherTitles = LCHomeNewsTitle.readNewsTitles(for: KHomeOtherTitlesKey) {
            self.others = otherTitles
        }else{
            LCServerTool.requestHomeMoreTitles { result in
                switch result {
                case .success(let response):
                    if let titleDatas = LCHomeNewsTitleData.modelform(response: response){
                        self.others = titleDatas.data.data
                        LCHomeNewsTitle.save(newsTitles: titleDatas.data.data, for: KHomeOtherTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    //MARK: - Views
    fileprivate func sutupViews() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.estimatedItemSize = CGSize.zero
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 44), collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.yellow
        collectionView.lc_registerNibCell(cellClass: LCHomeTitleCell.self)
        collectionView.delegate = self
        collectionView.dataSource  = self
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        
        
        let pageScrollView = LCHomePageScrollView()
        pageScrollView.contentSize = CGSize(width: ScreenWidth*CGFloat(self.titles.count), height: 0)
        pageScrollView.backgroundColor = UIColor.green
        pageScrollView.isPagingEnabled = true
        self.view.addSubview(pageScrollView)
        let height = ScreenHeight - NavBarHeight - TabBarHeight - collectionView.height
        pageScrollView.frame = CGRect(x: 0, y: collectionView.height, width: ScreenWidth, height: height)
        self.pageScrollView = pageScrollView
        
        
        let fristVC = LCHomeNewsController()
        fristVC.newsTitle = self.titles.first
        self.addChildViewController(fristVC)
        pageScrollView.addSubview(fristVC.view)
        fristVC.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
    }
}

//MARK: - UICollectionViewDataSource Extension
extension LCHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.lc_dequeueReusableCell(indexPath: indexPath) as LCHomeTitleCell
        cell.homeTitle = self.titles[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegate Extension
extension LCHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.updateSelectTitle(in: indexPath.row)
        titleView.enChange = false
        titleView.titles = [self.titles, self.others]
        
        let keyWindow = UIApplication.shared.keyWindow!
        keyWindow.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(keyWindow.safeAreaLayoutGuide)
            }else{
                make.top.equalTo(keyWindow).offset(20)
                make.left.right.bottom.equalTo(keyWindow)
            }
        }
        
        
        titleView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        UIView.animate(withDuration: 0.3) {
            self.titleView.transform = CGAffineTransform.identity
        }
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Extension
extension LCHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSString.init(string: self.titles[indexPath.row].name).size(withAttributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)]).width
        let height:CGFloat = 28
        return CGSize(width: width, height: height)
    }
}


//MARK: Private
extension LCHomeViewController{
    func updateSelectTitle(in index: Int) -> Void {
        self.titles[selectIndex].select = false
        self.titles[index].select = true
        selectIndex = index
    }
}
