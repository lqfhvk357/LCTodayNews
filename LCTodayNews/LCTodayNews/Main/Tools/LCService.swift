//
//  LCService.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import Moya

public extension TargetType {
    var baseURL: URL { return URL(string: "https://is.snssdk.com")! }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
//| category  | String | N    | 新闻类别  | video   |
//    | tt_from  | String | N    | 下拉刷新或加载更多  | pull / load_more  |
//    | refresh_reason  | Int | N    |   | 1  |
//    | strict  | Int | N    |   | 0  |
//    | detail  | Int | N    |   | 1  |
//    | min_behot_time  | Int | 下拉刷新的参数   |   | 1515848500  |
//    | max_behot_time  | Int | 加载更多的参数   |   | 1515848500  |
///home
enum LCHomeService {
    case homeTitles(device_id : Int, iid: Int)
    case homeMoreTitles(device_id : Int, iid: Int)
    case homeSearchBarInfo(device_id : Int, iid: Int)
    case homeNews(device_id : Int, category: String, tt_from: String, refresh_reason: Int, strict: Int, detail: Int, min_behot_time: Int, max_behot_time: Int)
}

extension LCHomeService: TargetType {
    var path: String {
        switch self {
        case .homeTitles(_, _):
            return "/article/category/get_subscribed/v1/"
        case .homeMoreTitles(_, _):
            return "/article/category/get_extra/v1/"
        case .homeSearchBarInfo(_, _):
            return "/search/suggest/homepage_suggest/"
        case .homeNews(_, _, _, _, _, _, _, _):
            return "/api/news/feed/v58/"
        }
        
    }

    var task: Task {
        switch self {
        case let .homeTitles(device_id, iid),
              let .homeMoreTitles(device_id, iid),
              let .homeSearchBarInfo(device_id, iid):
            return .requestParameters(parameters: ["device_id": device_id,
                                                   "iid": iid],
                                      encoding: JSONEncoding.default)
            
        case let .homeNews(device_id, category, tt_from, refresh_reason, strict, detail, min_behot_time, max_behot_time):
            return .requestParameters(parameters: ["device_id": device_id,
                                                   "category": category,
                                                   "tt_from": tt_from,
                                                   "refresh_reason": refresh_reason,
                                                   "strict": strict,
                                                   "detail": detail,
                                                   "min_behot_time": min_behot_time,
                                                   "max_behot_time": max_behot_time],
                                      encoding: JSONEncoding.default)
        }
        
    }

}



