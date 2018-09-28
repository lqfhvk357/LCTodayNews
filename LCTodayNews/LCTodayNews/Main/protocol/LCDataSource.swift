
//
//  dataSource.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import Moya
import Result
import SwiftyJSON
import HandyJSON

public protocol ResponseToModel {
    static func SwiftyJSONFrom(_ response: Response) -> JSON
    static func modelform(_ response: Response) -> Self?
}

extension ResponseToModel where Self: Decodable{
    static func SwiftyJSONFrom(_ response: Response) -> JSON {
        let json = JSON(response.data)
        return json
    }
    
    static func modelform(_ response: Response) -> Self? {
        let dcit = self.SwiftyJSONFrom(response)
        if let json = try? dcit.rawData(){
            do {
                let model = try JSONDecoder().decode(Self.self, from: json)
                return model
            }catch{
                print(error)
            }
        }
        return nil
    }
}
