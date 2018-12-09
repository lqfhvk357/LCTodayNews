
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
    static func modelform(data: Data) -> Self?
    static func modelform(content: String) -> Self?
}

extension ResponseToModel where Self: Decodable{

    static func modelform(data: Data) -> Self?{
        let json = JSON(data)
        if let jsonData = try? json.rawData(){
            do {
                let model = try JSONDecoder().decode(Self.self, from: jsonData)
                return model
            }catch{
                print(error)
                return nil
            }
        }
        return nil
        
    }
    
    static func modelform(content: String) -> Self?{
        do {
            let contentModel = try JSONDecoder().decode(Self.self, from: content.data(using: .utf8)!)
            return contentModel
        }catch{
            print(error)
            return nil
        }
    }
}
