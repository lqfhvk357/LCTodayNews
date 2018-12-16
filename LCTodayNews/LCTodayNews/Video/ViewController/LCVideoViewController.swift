//
//  LCVideoViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import SwiftyJSON

class LCVideoViewController: LCHomeBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //MARK: - Datas
    override func getTitles() {
        
        if let titles = LCHomeNewsTitle.readNewsTitles(for: KVideoTitlesKey) {
            self.titles = titles
            self.updateSelectTitle(in: 0)
        }else{
            let defaultTitle = LCHomeNewsTitle.init(category: "video", name: "推荐", select: true)
            self.titles.append(defaultTitle)
            LCServerTool.requestVideoTiltes { data in
                switch data.result {
                case .success(let responseData):
                    let json = JSON(responseData)
                    print(json)
                    
                    if let titleDatas = LCVideoTitleData.modelform(data: responseData){
                        self.titles = titleDatas.data
                        self.titles.insert(defaultTitle, at: 0)
                        self.titleHeader.reloadData()
                        
                        LCHomeNewsTitle.save(newsTitles: self.titles, for: KVideoTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func selectVC(_ index: Int) {
        NotificationCenter.default.post(name: AVPlayerShouldStop, object: nil)
        
        let newsTitle = self.titles[index]
        print(newsTitle)
        guard childViewControllerDict[newsTitle.category] == nil else{
            return
        }
        
        let selectVC = LCVideoTableViewController()
        selectVC.newsTitle = newsTitle
        self.addChildViewController(selectVC)
        pageScrollView.addSubview(selectVC.view)
        let height = ScreenHeight - NavBarHeight - TabBarHeight - titleHeader.height
        selectVC.view.frame = CGRect(x: ScreenWidth*CGFloat(index), y: 0, width: ScreenWidth, height: height)
        childViewControllerDict[newsTitle.category] = selectVC
    }

}
