//
//  LCServerTool.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/22.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import SwiftyJSON

public typealias Completion = (_ result: DataResponse<Data>) -> Void
let baseURL = "https://is.snssdk.com"
enum SubPath: String {
    case homeTitles = "/article/category/get_subscribed/v1/"
    case homeMoreTitles = "/article/category/get_extra/v1/"
    case homeSearchBarInfo = "/search/suggest/homepage_suggest/"
    case homeNews = "/api/news/feed/v88/"
}

class LCServerTool {
    /// 首页baseRequest
    static func requestData(_ partUrl: String, params: Dictionary<String, Any>, completion: @escaping Completion) -> () {
        let url = baseURL + partUrl
        Alamofire.request(url, method: .get, parameters: params).responseData { completion($0) }
    }
    
    ///首页新闻标题
    static func requestHomeTiltes(completion: @escaping Completion) -> () {
        let params = ["device_id": Device_id, "iid": Iid]
        requestData(SubPath.homeTitles.rawValue, params: params, completion: completion)
    }
    
    ///首页导航栏搜索接口
    static func requsetHomeSearchBarInfo(completion: @escaping Completion) -> (){
        let params = ["device_id": Device_id, "iid": Iid]
        requestData(SubPath.homeSearchBarInfo.rawValue, params: params, completion: completion)
    }
    
    
    ///首页更多新闻标题
    static func requestHomeMoreTitles(completion: @escaping Completion) -> () {
        let params = ["device_id": Device_id, "iid": Iid]
        requestData(SubPath.homeMoreTitles.rawValue, params: params, completion: completion)
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
        
        let params = [  "device_id": Device_id,
                        "category": "news_car",
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
  
        let url = baseURL + SubPath.homeNews.rawValue
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                guard let datas = json["data"].array else { return }
                print("datas -- \(json["data"])" )
                print("count -- \(datas.count)")
//                completionHandler(pullTime, datas.compactMap({ NewsModel.deserialize(from: $0["content"].string) }))
            }
        }
        requestData(SubPath.homeNews.rawValue, params: params, completion: completion)
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
