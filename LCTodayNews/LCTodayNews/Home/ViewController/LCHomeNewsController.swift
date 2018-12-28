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

    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.lc_dequeueReusableCell(indexPath: indexPath) as LCNewsCell
        cell.news = self.news[indexPath.row].contentModel
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: headerRefresh & footerRefresh
    override func headerDidRefresh() {
        super.headerDidRefresh()
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
    
    override func footerDidRefresh() {
        super.footerDidRefresh()
        guard let title = newsTitle as? LCHomeNewsTitle else {
            return
        }
        pullTime = Date().timeIntervalSince1970
        moreRequest = LCServerTool.requestMoreHomeNews(forCategory: title.category, list_count: self.news.count, max_behot_time: pullTime){ data in
            self.footerEndRefresh()
            switch data.result {
            case .success(let responseData):
                if let datas = LCHomeNewsData.modelformNewsData(responseData){
                    print("requsetHomeNews:\n\(JSON(responseData))")
                    
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
