
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
    static func dictsFrom(_ response: Response) -> JSON
    static func modelArrayform(_ response: Response) -> [Self]
    static func modelform(_ response: Response) -> Self?
}

extension ResponseToModel where Self: Decodable{
    static func dictsFrom(_ response: Response) -> JSON {
        let json = JSON(response.data)
        return json["data"]["data"]
    }
    
    static func modelArrayform(_ response: Response) -> [Self] {
        let array = self.dictsFrom(response)
        var titles = [Self]()
        if let jsonArray = try? array.rawData(){
            if let modelArray = try? JSONDecoder().decode([Self].self, from: jsonArray){
                titles = modelArray
            }
        }
        
        if titles.count > 0 {
            return titles;
        }else{
            return [];
        }
    }
    
    static func modelform(_ response: Response) -> Self? {
        let dcit = self.dictsFrom(response)
        if let json = try? dcit.rawData(){
            if let model = try? JSONDecoder().decode(Self.self, from: json){
                return model
            }
        }
        return nil
    }
}
