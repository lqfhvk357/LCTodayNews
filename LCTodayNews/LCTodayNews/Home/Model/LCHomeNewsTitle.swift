//
//  LCTitleModel.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

///新闻标题
//    category = "news_health";
//    "concern_id" = 6215497895248923137;
//    "default_add" = 1;
//    flags = 0;
//    "icon_url" = "";
//    name = "\U5065\U5eb7";
//    "tip_new" = 0;
//    type = 4;
//    "web_url" = "";


struct LCHomeNewsTitle : Decodable{
    let category: String
    var concern_id: String?
    var default_add: Int?
    var flags: Int?
    var icon_url: String?
    let name: String
    var tip_new: Int?
    var type: Int?
    var web_url: String?
    
    var select: Bool? = false
    
    init(category: String, name: String, select: Bool = false){
        self.category = category
        self.name = name
        self.select = select
    }
    
    var titleDict: [String : String]? {
        get {
            return ["category" : category, "name" : name]
        }
    }
    
    static func save(newsTitles: [LCHomeNewsTitle], for key: String) -> Void {
        UserDefaults.standard.set(newsTitles.map { $0.titleDict }, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func readNewsTitles(for key: String) -> [LCHomeNewsTitle]? {
        if let titleDicts = UserDefaults.standard.object(forKey: key) as? Array<Dictionary<String, String>>, titleDicts.count>0 {
            return titleDicts.compactMap { dict -> LCHomeNewsTitle? in
                if let category = dict["category"], let name = dict["name"]{
                    return LCHomeNewsTitle.init(category: category, name: name)
                }else{
                    return nil
                }
            }
        }else{
            return nil
        }
    }
    
}

struct LCHomeNewsTitleData: Decodable {
    let message: String
    
    struct LCHomeNewsTitleSubData: Decodable {
        let version: String
        let data: [LCHomeNewsTitle]
    }
    let data: LCHomeNewsTitleSubData
}

extension LCHomeNewsTitleData: ResponseToModel{}



///新闻标题category
enum LCTitleType: String {
    /// 推荐
    case recommend = ""
    /// 热点
    case hot = "news_hot"
    /// 地区
    case local = "news_local"
    /// 视频
    case video = "video"
    /// 社会
    case society = "news_society"
    /// 图片,组图
    case photos = "组图"
    /// 娱乐
    case entertainment = "news_entertainment"
    /// 科技
    case newsTech = "news_tech"
    /// 科技
    case car = "news_car"
    /// 财经
    case finance = "news_finance"
    /// 军事
    case military = "news_military"
    /// 体育
    case sports = "news_sports"
    /// 段子
    case essayJoke = "essay_joke"
    /// 街拍
    case imagePPMM = "image_ppmm"
    /// 趣图
    case imageFunny = "image_funny"
    /// 美图
    case imageWonderful = "image_wonderful"
    /// 国际
    case world = "news_world"
    /// 搞笑
    case funny = "funny"
    /// 健康
    case health = "news_health"
    /// 特卖
    case jinritemai = "jinritemai"
    /// 房产
    case house = "news_house"
    /// 时尚
    case fashion = "news_fashion"
    /// 历史
    case history = "news_history"
    /// 育儿
    case baby = "news_baby"
    /// 数码
    case digital = "digital"
    /// 语录
    case essaySaying = "essay_saying"
    /// 星座
    case astrology = "news_astrology"
    /// 辟谣
    case rumor = "rumor"
    /// 正能量
    case positive = "positive"
    /// 动漫
    case comic = "news_comic"
    /// 故事
    case story = "news_story"
    /// 收藏
    case collect = "news_collect"
    /// 精选
    case boutique = "boutique"
    /// 孕产
    case pregnancy = "pregnancy"
    /// 文化
    case culture = "news_culture"
    /// 游戏
    case game = "news_game"
    /// 股票
    case stock = "stock"
    /// 科学
    case science = "science_all"
    /// 宠物
    case pet = "宠物"
    /// 情感
    case emotion = "emotion"
    /// 家居
    case home = "news_home"
    /// 教育
    case education = "news_edu"
    /// 三农
    case agriculture = "news_agriculture"
    /// 美食
    case food = "news_food"
    /// 养生
    case regimen = "news_regimen"
    /// 电影
    case movie = "movie"
    /// 手机
    case cellphone = "cellphone"
    /// 旅行
    case travel = "news_travel"
    /// 问答
    case questionAndAnswer = "question_and_answer"
    /// 小说
    case novelChannel = "novel_channel"
    /// 直播
    case live_talk = "live_talk"
    /// 中国新唱将
    case chinaSinger = "中国新唱将"
    /// 火山直播
    case hotsoon = "hotsoon"
    /// 互联网法院
    case highCourt = "high_court"
    /// 快乐男声
    case happyBoy = "快乐男声"
    /// 传媒
    case media = "media"
    /// 百万英雄
    case millionHero = "million_hero"
    /// 彩票
    case lottery = "彩票"
    /// 中国好表演
    case chinaAct = "中国好表演"
    /// 春节
    case springFestival = "spring_festival"
    /// 微头条
    case weitoutiao = "weitoutiao"
    /// 小视频 推荐
    case hotsoonVideo = "hotsoon_video"
    /// 小视频 颜值/美女
    case ugcVideoBeauty = "ugc_video_beauty"
    /// 小视频 随拍
    case ugcVideoCasual = "ugc_video_casual"
    /// 小视频 美食
    case ugcVideoFood = "ugc_video_food"
    /// 小视频 户外
    case ugcVideoLife = "ugc_video_life"
}
