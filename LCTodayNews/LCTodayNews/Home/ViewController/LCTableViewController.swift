//
//  LCTableViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import MJRefresh
import Moya
import PromiseKit
import SwiftyJSON

class LCTableViewController: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }

    var newsTitle: LCHomeNewsTitle?
    var news = [LCHomeNewsData.LCHomeNews]()
    var pullTime: TimeInterval = 0.0
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()

//        LCServerTool.requsetHomeSearchBarInfo{ result in
//            switch result {
//            case .success(let response):
//                if let titles = LCHomeSearchInfoData.modelform(response) {
//                    print("requsetHomeSearchBarInfo:\n\(titles)");
//                }
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    
    }
    
    //Views
    fileprivate func setupTableView() -> Void {
        self.tableView.backgroundColor = UIColor.tableViewBackgoundColor
//        self.tableView.estimatedRowHeight = 0
//        self.tableView.rowHeight = 150
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        self.addRefreshHeader()
        self.addRefreshFooter()
        self.shouldHiddenFooter(with: news)
    }
    
    // MARK: - Table view data source
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("datas.count --- \(news.count)")
        return self.news.count
//        return 10
    }
}



// MARK: - RefreshControl Extension
extension LCTableViewController: TableViewRefreshHeader, TableViewRefreshFooter{
    
    func headerDidRefresh() {
        guard let title = newsTitle else {
            return
        }
        pullTime = Date().timeIntervalSince1970
        
        
        LCServerTool.requestHomeNews(forCategory: title.category, min_behot_time: pullTime){ result in
            self.headerEndRefresh()
            switch result {
            case .success(let response):
                if let datas = LCHomeNewsData.modelform(response){
                    print("\(title.category) --- requsetHomeNews:\n\(JSON(response.data))")
                    
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
            }
        }
    }
    
    func footerDidRefresh() {
        guard let title = newsTitle else {
            return
        }
        LCServerTool.requestMoreHomeNews(forCategory: title.category, list_count: self.news.count, max_behot_time: pullTime){ result in
            self.footerEndRefresh()
            switch result {
            case .success(let response):
                if let datas = LCHomeNewsData.modelform(response){
                    print("requsetHomeNews:\n\(JSON(response.data))")
                    
                    let noNULLDatas = datas.data.filter{ newsData -> Bool in
                        newsData.contentModel != nil && newsData.contentModel?.stick_style != 1
                    }
                    self.news.append(contentsOf: noNULLDatas)
                    
                    print("models:\n\(datas)")
                    if noNULLDatas.count != datas.data.count {
                        print("errer!!!!!!!!!!!!!!!! noNULLDatas.count : \(noNULLDatas.count)  --- datas.data.count : \(datas.data.count)")
                    }
                    
                    self.tableView.reloadData()
                    self.shouldHiddenFooter(with: self.news)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
}


