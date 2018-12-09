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
    
    enum TTFrom: String {
        case pull = "pull"
        case loadMore = "load_more"
        case auto = "auto"
        case enterAuto = "enter_auto"
        case preLoadMoreDraw = "pre_load_more_draw"
    }
    ///首页新闻
    static func requestHomeNews(forCategory category: String = LCTitleType.recommend.rawValue,
                                list_count: Int = 0,
                                count: Int = 20,
                                tt_from: String = TTFrom.pull.rawValue,
                                refresh_reason: Int = 1,
                                strict: Int = 0,
                                detail: Int = 1,
                                min_behot_time: Double = 0,
                                max_behot_time: Double = 0,
                                partUrlString: String = "v88",
                                completion: @escaping Completion) -> () {
//        LCHomeService.partUrlString = partUrlString
        
        print(category)
        let target = LCHomeService.homeNews(device_id: Device_id,
                                            category: category,
                                            list_count: list_count,
                                            count: count,
                                            tt_from: tt_from,
                                            refresh_reason: refresh_reason,
                                            strict: strict,
                                            detail: detail,
                                            min_behot_time: min_behot_time,
                                            max_behot_time: max_behot_time)
        requestData(target, completion: completion)
    }
    
    static func requestMoreHomeNews(forCategory category: String = LCTitleType.recommend.rawValue,
                                    list_count : Int,
                                    max_behot_time: Double,
                                completion: @escaping Completion) -> () {
        requestHomeNews(forCategory: category,
                        list_count: list_count,
                        count: 20,
                        tt_from: TTFrom.loadMore.rawValue,
                        max_behot_time: max_behot_time,
                        partUrlString : "v75",
                        completion: completion)
    }
}
