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
        let target = LCHomeService.homeMoreTitles(device_id: 6096495334, iid: 5034850950)
        requestData(target, completion: completion)

    }
}
