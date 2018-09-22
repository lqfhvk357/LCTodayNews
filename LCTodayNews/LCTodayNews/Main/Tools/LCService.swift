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

///home
enum LCHomeService {
    case homeTitles(device_id : Int, iid: Int)
    case homeMoreTitles(device_id : Int, iid: Int)
    case homeSearchBarInfo(device_id : Int, iid: Int)
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
        }
    }

    var task: Task {
        switch self {
        case let .homeTitles(device_id, iid), let .homeMoreTitles(device_id, iid), let .homeSearchBarInfo(device_id, iid):
            return .requestParameters(parameters: ["device_id": device_id, "iid": iid], encoding: JSONEncoding.default)
        }
    }

}



