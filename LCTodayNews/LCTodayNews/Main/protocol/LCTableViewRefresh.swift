//
//  File.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/8.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import UIKit

//protocol hasTableView {
//    var tableView: UITableView
//
//}

protocol TableViewRefreshHeader {
    func headerDidRefresh() -> Void
}

extension TableViewRefreshHeader where Self: UITableViewController {
    func addRefreshHeader() -> Void {
        tableView.mj_header = LCRefreshHeader{ [weak self] in
            self!.headerDidRefresh()
        }
    }
    
    func headerBeginRefresh() -> Void {
        tableView.mj_header.beginRefreshing()
    }
    
    func headerEndRefresh() -> Void {
        tableView.mj_header.endRefreshing()
    }
}

protocol TableViewRefreshFooter {
    func footerDidRefresh() -> Void
}

extension TableViewRefreshFooter where Self:UITableViewController {
    func addRefreshFooter() -> Void {
        tableView.mj_footer = LCRefreshFooter{ [weak self] in
            self!.footerDidRefresh()
        }
    }
    
    func shouldHiddenFooter(with datas: Array<Any>) -> Void {
        tableView.mj_footer.isHidden = datas.count < 10
    }
    
    func footerEndRefresh() -> Void {
        tableView.mj_footer.endRefreshing()
    }
    
}
