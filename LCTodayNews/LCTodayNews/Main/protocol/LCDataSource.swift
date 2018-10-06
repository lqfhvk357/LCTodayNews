
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
    static func swiftyJSONFrom(_ response: Response) -> JSON
    static func modelform(_ response: Response) -> Self?
    static func modelform(_ data: Data) -> Self?
    static func modelform(_ content: String) -> Self?
}

extension ResponseToModel where Self: Decodable{
    static func swiftyJSONFrom(_ response: Response) -> JSON {
        let json = JSON(response.data)
        return json
    }
    
    static func modelform(_ response: Response) -> Self? {
        let dcit = swiftyJSONFrom(response)
        if let json = try? dcit.rawData(){
            if let model = modelform(json){
                return model;
            }
        }
        return nil
    }
    
    static func modelform(_ data: Data) -> Self?{
        do {
            let model = try JSONDecoder().decode(Self.self, from: data)
            return model
        }catch{
            print(error)
            return nil
        }
    }
    
    static func modelform(_ content: String) -> Self?{
        do {
            let contentModel = try JSONDecoder().decode(Self.self, from: content.data(using: .utf8)!)
            return contentModel
        }catch{
            print(error)
            return nil
        }
    }
}
