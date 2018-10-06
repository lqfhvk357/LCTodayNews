//
//  LCServerTool.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/22.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import Moya

class LCServerTool {
    /// 首页baseRequest
    static func requestData(_ target: LCHomeService, completion: @escaping Completion) -> () {
        let provider = MoyaProvider<LCHomeService>()
        provider.request(target, completion: completion)
    }
    
    ///首页新闻标题
    static func requestHomeTiltes(completion: @escaping Completion) -> () {
        let target = LCHomeService.homeTitles(device_id: Device_id, iid: Iid)
        requestData(target, completion: completion)
    }
    
    ///首页导航栏搜索接口
    static func requsetHomeSearchBarInfo(completion: @escaping Completion) -> (){
        let target = LCHomeService.homeSearchBarInfo(device_id: Device_id, iid: Iid)
        requestData(target, completion: completion)
    }
    
    
    ///首页更多新闻标题
    static func requestHomeMoreTitles(completion: @escaping Completion) -> () {
        let target = LCHomeService.homeMoreTitles(device_id: Device_id, iid: Iid)
        requestData(target, completion: completion)
    }
    
    ///首页新闻
    static func requestHomeNews(forCategory category: LCTitleType = .recommend,
                                 tt_from: String = "",
                                 refresh_reason: Int = 0,
                                 strict: Int = 0,
                                 detail: Int = 0,
                                 min_behot_time: Int = 0,
                                 max_behot_time: Int = 0,
                                completion: @escaping Completion) -> () {
        let target = LCHomeService.homeNews(device_id: Device_id, category: category.rawValue, tt_from: tt_from, refresh_reason: refresh_reason, strict: strict, detail: detail, min_behot_time: min_behot_time, max_behot_time: max_behot_time)
        requestData(target, completion: completion)
    }
}
