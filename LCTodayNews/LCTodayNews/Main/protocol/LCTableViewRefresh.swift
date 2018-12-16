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

protocol ScrollViewRefreshHeader {
    func headerDidRefresh() -> Void
}

extension ScrollViewRefreshHeader where Self: UITableViewController {
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

extension ScrollViewRefreshHeader where Self: UICollectionViewController {
    func addRefreshHeader() -> Void {
        collectionView?.mj_header = LCRefreshHeader{ [weak self] in
            self!.headerDidRefresh()
        }
    }
    
    func headerBeginRefresh() -> Void {
        collectionView?.mj_header.beginRefreshing()
    }
    
    func headerEndRefresh() -> Void {
        collectionView?.mj_header.endRefreshing()
    }
}


protocol ScrollViewRefreshFooter {
    func footerDidRefresh() -> Void
}

extension ScrollViewRefreshFooter where Self: UITableViewController {
    func addRefreshFooter() -> Void {
        tableView.mj_footer = LCRefreshFooter{ [weak self] in
            self!.footerDidRefresh()
        }
    }
    
    func shouldHiddenFooter(with datas: Array<Any>) -> Void {
        tableView.mj_footer.isHidden = datas.count < 5
    }
    
    func footerEndRefresh() -> Void {
        tableView.mj_footer.endRefreshing()
    }
}

extension ScrollViewRefreshFooter where Self: UICollectionViewController {
    func addRefreshFooter() -> Void {
        collectionView?.mj_footer = LCRefreshFooter{ [weak self] in
            self!.footerDidRefresh()
        }
    }
    
    func shouldHiddenFooter(with datas: Array<Any>) -> Void {
        collectionView?.mj_footer.isHidden = datas.count < 5
    }
    
    func footerEndRefresh() -> Void {
        collectionView?.mj_footer.endRefreshing()
    }
    
}
