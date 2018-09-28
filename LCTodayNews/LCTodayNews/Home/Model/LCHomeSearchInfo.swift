//
//  LCHomeSearchInfo.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/28.
//  Copyright © 2018年 罗超. All rights reserved.
//

//"homepage_search_suggest" : "猫咪和主人 | 磷酸二氢钾 | 养花的好处",
//"call_per_refresh" : 2,
//"suggest_words" : [
//{
//"id" : 0,
//"word" : "猫咪和主人"
//},
//{
//"id" : 0,
//"word" : "磷酸二氢钾"
//},
//{
//"id" : 0,
//"word" : "养花的好处"
//}
//]


import Foundation
import Moya
import SwiftyJSON





struct LCHomeSearchInfoData: Decodable {
    let message: String
    
    struct LCHomeSearchInfo: Decodable {
        let homepage_search_suggest: String
        let call_per_refresh: Int
        
        struct LCSearchWord: Decodable {
            let id: Int
            let word: String
        }
        let suggest_words: [LCSearchWord]
    }
    let data: LCHomeSearchInfo
}

extension LCHomeSearchInfoData:ResponseToModel{}
