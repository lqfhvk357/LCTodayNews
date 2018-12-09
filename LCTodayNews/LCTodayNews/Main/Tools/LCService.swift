//
//  LCService.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

public extension TargetType {
    var baseURL: URL { return URL(string: "https://is.snssdk.com")! }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
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
    case homeNews(device_id : Int, category: String, list_count: Int, count: Int, tt_from: String, refresh_reason: Int, strict: Int, detail: Int, min_behot_time: Double, max_behot_time: Double)
}

extension LCHomeService: TargetType {
    public static var partUrlString = "v88"
    
    var path: String {
        switch self {
        case .homeTitles(_, _):
            return "/article/category/get_subscribed/v1/"
        case .homeMoreTitles(_, _):
            return "/article/category/get_extra/v1/"
        case .homeSearchBarInfo(_, _):
            return "/search/suggest/homepage_suggest/"
        case .homeNews(_, _, _, _, _, _, _, _, _, _):
            return "/api/news/feed/\(LCHomeService.partUrlString)/"
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
            
        case let .homeNews(device_id, category, list_count, count, tt_from, refresh_reason, strict, detail, min_behot_time, max_behot_time):
            let params = [  "device_id": device_id,
                            "category": category,
                            "list_count": list_count,
                            "count": count,
                            "tt_from": tt_from,
                            "refresh_reason": refresh_reason,
                            "strict": strict,
                            "detail": detail,
                            "min_behot_time": min_behot_time,
                            "max_behot_time": max_behot_time,
                            "iid": Iid,
                            ] as [String : Any]
            
//            let url = baseURL.absoluteString + "/api/news/feed/v88/?"
//            Alamofire.request(url, parameters: params).responseJSON { (response) in
//                // 网络错误的提示信息
//                guard response.result.isSuccess else { return }
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    guard json["message"] == "success" else { return }
//                    guard let datas = json["data"].array else { return }
//                    print("datas -- \(json["data"])" )
//                    print("count -- \(datas.count)")
//                }
//            }
            return .requestParameters(parameters: params,
                                      encoding: JSONEncoding.default)
        }
        
    }

}



