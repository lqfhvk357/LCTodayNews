//
//  LCTitleModel.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import Moya
import Result

struct LCNavTitle : Decodable{
//    category = "news_health";
//    "concern_id" = 6215497895248923137;
//    "default_add" = 1;
//    flags = 0;
//    "icon_url" = "";
//    name = "\U5065\U5eb7";
//    "tip_new" = 0;
//    type = 4;
//    "web_url" = "";
    let category: String;
    let concern_id: String;
    let default_add: Int;
    let flags: Int;
    let icon_url: String;
    let name: String;
    let tip_new: Int;
    let type: Int;
    let web_url: String;
    
}

extension LCNavTitle: ResponseToModel{}


