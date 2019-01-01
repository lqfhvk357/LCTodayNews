//
//  LCHomeNewsController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/8.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
    
//MARK: - life cycle
class LCHomeNewsController: LCTableViewController {
    
    var pullRequest: DataRequest?
    var moreRequest: DataRequest?
    var bufferNews = [LCHomeNewsData.LCHomeNews]()
    var lock = false
    
    
    
    lazy var loadingView: LCLoadingView = {
        let height = ScreenHeight - NavBarHeight - TabBarHeight - titleHeight
        let loadV = LCLoadingView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: height))
        return loadV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.lc_registerClassCell(cellClass: LCNewsCell.self)
        print("__\(#file)__\(#function)__\(#line)__")
        
        self.headerDidRefresh()
        
//        let runloop = CFRunLoopGetCurrent()
//        let mode = CFRunLoopMode.defaultMode
//        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { (observer, _) in
//            if self.bufferNews.count > 0 {
//                self.performSelector(onMainThread: #selector(LCHomeNewsController.endRefreshAndReloadData), with: nil, waitUntilDone: false, modes: [CFRunLoopMode.commonModes.rawValue as String])
//            }
////            [self performSelector:@selector(_notifyAllObservers) withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes]];
//        }
//        CFRunLoopAddObserver(runloop, observer, mode)
    }
    

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.lc_dequeueReusableCell(indexPath: indexPath) as LCNewsCell
        cell.news = self.news[indexPath.row].contentModel
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Table view data delegate
    
    
    // MARK: headerRefresh & footerRefresh
    override func headerDidRefresh() {
        super.headerDidRefresh()
        requestData()
    }
    
    override func footerDidRefresh() {
        super.footerDidRefresh()
        
        print(self.tableView.contentOffset)
        requestMoreData(with: true)
    }
    
    func requestData() {
        guard let title = newsTitle as? LCHomeNewsTitle else {
            return
        }
        pullTime = Date().timeIntervalSince1970
        if news.count == 0 {
            self.headerEndRefresh()
            self.view.addSubview(loadingView)
            loadingView.anim()
        }
        
        pullRequest = LCServerTool.requestHomeNews(forCategory: title.category, min_behot_time: pullTime){ data in
            self.headerEndRefresh()
            self.loadingView.removeFromSuperview()
            switch data.result {
            case .success(let responseData):
                print("\(title.category) --- requsetHomeNews:\n\(JSON(responseData))")
                if let datas = LCHomeNewsData.modelformNewsData(responseData){
                    let noNULLDatas = datas.data.filter{ newsData -> Bool in
                        newsData.contentModel != nil
                    }
                    self.news = noNULLDatas
                    
                    print("models:\n\(datas)")
                    if noNULLDatas.count != datas.data.count {
                        print("errer!!!!!!!!!!!!!!!! noNULLDatas.count : \(noNULLDatas.count)  --- datas.data.count : \(datas.data.count)")
                    }
                    
                    self.tableView.reloadData()
                    self.shouldHiddenFooter(with: self.news)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
                //Warning: -
                //                let testNews = LCHomeNewsData.LCHomeNews.init(code: "", content: "", contentModel: nil)
                //                self.news.append(testNews)
                //                self.tableView.reloadData()
                
            }
        }
    }
    
    @objc func requestMoreData(with isPull: Bool) {
        guard let title = newsTitle as? LCHomeNewsTitle else {
            return
        }
        guard !lock, bufferNews.count == 0 else {return}
        lock = true
        pullTime = Date().timeIntervalSince1970
        moreRequest = LCServerTool.requestMoreHomeNews(forCategory: title.category, list_count: self.news.count, max_behot_time: pullTime){ data in
            self.lock = false
            switch data.result {
            case .success(let responseData):
                if let datas = LCHomeNewsData.modelformNewsData(responseData){
                    print("requsetHomeNews:\n\(JSON(responseData))")
                    
                    self.bufferNews = datas.data.filter{ newsData -> Bool in
                        newsData.contentModel != nil && newsData.contentModel?.stick_style != 1
                    }

                    print("models:\n\(datas)")
                    if self.bufferNews.count != datas.data.count {
                        print("errer!!!!!!!!!!!!!!!! noNULLDatas.count : \(self.bufferNews.count)  --- datas.data.count : \(datas.data.count)")
                    }
                    if isPull {
                        self.endRefreshAndReloadData()
                        self.footerEndRefresh()
                        self.shouldHiddenFooter(with: self.news)
                    }else{
                        self.endRefreshAndReloadData()
                    }
                }
                
            case .failure(let error):
                self.footerEndRefresh()
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Private
    @objc func endRefreshAndReloadData() {
        self.news.append(contentsOf: self.bufferNews)
        self.bufferNews.removeAll()
        self.tableView.reloadData()
    }
    
}
