//
//  LCCollectionViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/11.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias DidSelectItemCell = (LCSmallVideoCell) -> ()

class LCCollectionViewController: UICollectionViewController, LCPageTitleProtocol, ScrollViewRefreshHeader, ScrollViewRefreshFooter {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    var request: DataRequest?
    
    lazy var loadingView: LCLoadingView = {
        let height = ScreenHeight - NavBarHeight - TabBarHeight
        let loadV = LCLoadingView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: height))
        return loadV
    }()
    
    var newsTitle: LCPageHeaderTitle?
    var news = [LCSmallVideos.LCVideoNews]()
    var pullTime: TimeInterval = 0.0
    var animView: UIView?
    var didSelectItemCell: DidSelectItemCell?
    
    
    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.headerDidRefresh()
    }
    
    //Views
    func setupViews() {
        self.collectionView!.lc_registerNibCell(cellClass: LCSmallVideoCell.self)
        self.collectionView!.backgroundColor = UIColor.clear
        let flowLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        
        let width = ScreenWidth / 2 - 0.5
        let height = width * 960 / 540
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        
        self.addRefreshHeader()
        self.addRefreshFooter()
        self.shouldHiddenFooter(with: news)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.lc_dequeueReusableCell(indexPath: indexPath) as LCSmallVideoCell
        cell.news = self.news[indexPath.item].contentModel
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LCSmallVideoCell
        let frame = cell.convert(CGPoint.zero, to: UIApplication.shared.keyWindow)
        print(frame)
        didSelectItemCell?(cell)
    }
    

    //MARK: headerRefresh & footerRefresh
    func headerDidRefresh() {

        guard let title = newsTitle as? LCHomeNewsTitle else {
            self.headerEndRefresh()
            return
        }
        pullTime = Date().timeIntervalSince1970
        if news.count == 0 {
            self.headerEndRefresh()
            self.view.addSubview(loadingView)
            loadingView.anim()
        }
        
        request = LCServerTool.requestHomeNews(forCategory: title.category, min_behot_time: pullTime, newsKind: .smallVideo){ data in
            self.headerEndRefresh()
            self.loadingView.removeFromSuperview()
            switch data.result {
            case .success(let responseData):
                print("\(title.category) --- requsetHomeNews:\n\(JSON(responseData))")
                if let datas = LCSmallVideos.modelformVideoData(responseData){
                    let noNULLDatas = datas.data.filter{ newsData -> Bool in
                        newsData.contentModel != nil
                    }
                    self.news = noNULLDatas
                    
                    print("models:\n\(datas)")
                    if noNULLDatas.count != datas.data.count {
                        print("errer!!!!!!!!!!!!!!!! noNULLDatas.count : \(noNULLDatas.count)  --- datas.data.count : \(datas.data.count)")
                    }
                    
                    self.collectionView?.reloadData()
                    self.shouldHiddenFooter(with: self.news)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func footerDidRefresh() {
        guard let title = newsTitle as? LCHomeNewsTitle else {
            return
        }
        pullTime = Date().timeIntervalSince1970
        request = LCServerTool.requestMoreHomeNews(forCategory: title.category, list_count: self.news.count, max_behot_time: pullTime, newsKind: .smallVideo){ data in
            self.footerEndRefresh()
            switch data.result {
            case .success(let responseData):
                print("requsetHomeNews:\n\(JSON(responseData))")
                if let datas = LCSmallVideos.modelformVideoData(responseData){
                    let noNULLDatas = datas.data.filter{ newsData -> Bool in
                        newsData.contentModel != nil
                    }
                    self.news.append(contentsOf: noNULLDatas)
                    
                    print("models:\n\(datas)")
                    if noNULLDatas.count != datas.data.count {
                        print("errer!!!!!!!!!!!!!!!! noNULLDatas.count : \(noNULLDatas.count)  --- datas.data.count : \(datas.data.count)")
                    }
                    
                    self.collectionView?.reloadData()
                    self.shouldHiddenFooter(with: self.news)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}



