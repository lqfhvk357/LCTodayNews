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
        self.tableView.estimatedRowHeight = 0
        self.tableView.rowHeight = 150
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
        LCServerTool.requestHomeNews(forCategory: title.category){ result in
            self.headerEndRefresh()
            switch result {
            case .success(let response):
                if let datas = LCHomeNewsData.modelform(response){
                    print("requsetHomeNews:\n\(JSON(response.data))")
                    
                    self.news = datas.data.filter{ newsData -> Bool in
                        newsData.contentModel != nil
                    }
                    
                    print("models:\n\(datas)")
                    if self.news.count != datas.data.count {
                        print("errer!!!!!!!!!!!!!!!! self.news.count : \(self.news.count)  --- datas.data.count : \(datas.data.count)")
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
        self.footerEndRefresh()
    }

}


