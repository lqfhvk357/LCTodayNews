//
//  LCVideoTableViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class LCVideoTableViewController: LCHomeNewsController {
    
    var videoRequest: DataRequest?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.rowHeight = 180 * ScreenWidth/320 + 58
        tableView.separatorStyle = .none
        tableView.lc_registerNibCell(cellClass: LCVideoCell.self)
        
        NotificationCenter.default.addObserver(forName: AVPlayerShouldStop, object: nil, queue: nil) { _ in
            self.videoRequest?.task?.cancel()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: AVPlayerShouldStop, object: nil)
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.lc_dequeueReusableCell(indexPath: indexPath) as LCVideoCell
        cell.news = self.news[indexPath.row].contentModel
        cell.tapPalyViewHandle = {[weak self] model in
            if let video_id = model.video_detail_info?.video_id {
                self!.videoRequest = LCServerTool.requestVideoUrl(video_id, completion: {[weak cell, self] (data)  in
                    switch data.result {
                    case .success(let responseData):
                        print("\(JSON(responseData))")
                        if let datas = LCVideoInfoData.modelform(data: responseData){
                            self?.news[indexPath.row].contentModel?.video_main_url = datas.data.video_list.video_1.main_url
                            cell!.videoUrl = datas.data.video_list.video_1.main_url
                        }
                    case .failure(let error):
                        cell!.videoUrl = nil
                        print(error.localizedDescription)
                        
                    }
                })
            }
        }
            
        cell.selectionStyle = .none
        return cell
    }


    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let lastIndexPath = self.tableView.indexPathsForVisibleRows?.last, lastIndexPath.row > self.news.count - 8{
            requestMoreData(with: false)
        }
        
    }
}
