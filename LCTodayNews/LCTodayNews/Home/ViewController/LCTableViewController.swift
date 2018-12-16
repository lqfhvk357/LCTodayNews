//
//  LCTableViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import MJRefresh
import PromiseKit


protocol NewsTitleProtocol where Self: UIViewController  {
    var newsTitle: LCHomeNewsTitle? { set get }
    var pullTime: TimeInterval { set get }
}

class LCTableViewController: UITableViewController, NewsTitleProtocol, ScrollViewRefreshHeader, ScrollViewRefreshFooter {
    
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
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
    
    
    func headerDidRefresh() {}
    func footerDidRefresh() {}
}

    
    




