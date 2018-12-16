//
//  LCVideoTitleData.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import Foundation

struct LCVideoTitleData: Decodable {
    let message: String
    let data: [LCHomeNewsTitle]
}

extension LCVideoTitleData: ResponseToModel {}
