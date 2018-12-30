//
//  LCHomeNews.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/28.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON
import PromiseKit

//{"abstract":"今天，习近平总书记在辽宁忠旺集团考察时强调指出，“我们毫不动摇地发展公有制经济，也毫不动摇地支持、保护、扶持民营经济发展、非公有制经济发展”。",
//    "action_extra":"{\"channel_id\": 0}",
//    "action_list":[{"action":1,"desc":"","extra":{}},
//                        {"action":3,"desc":"","extra":{}},
//                        {"action":7,"desc":"","extra":{}},
//                        {"action":9,"desc":"","extra":{}}],
//    "aggr_type":1,
//    "allow_download":false,
//    "article_alt_url":"http://m.toutiao.com/group/article/6606040831663014413/",
//    "article_sub_type":0,
//    "article_type":1,
//    "article_url":"https://m2.people.cn/r/MV8xXzMwMzE3NTgwXzEwMDNfMTUzODA4ODQwMQ==?source=da",
//    "ban_comment":0,
//    "behot_time":1538140582,"bury_count":0,"cell_flag":262155,"cell_layout_style":1,"cell_type":0,"comment_count":3807,"content_decoration":"","cursor":1538140582999,"digg_count":3,"display_url":"http://toutiao.com/group/6606040831663014413/","filter_words":[{"id":"8:0","is_selected":false,"name":"看过了"},{"id":"9:1","is_selected":false,"name":"内容太水"},{"id":"5:9103642","is_selected":false,"name":"拉黑作者:人民网"},{"id":"2:11781096","is_selected":false,"name":"不想看:宏观经济"},{"id":"6:38334","is_selected":false,"name":"不想看:总书记"}],"forward_info":{"forward_count":121},"group_id":6606040831663014413,"has_m3u8_video":false,"has_mp4_video":0,"has_video":false,"hot":0,"ignore_web_transform":1,"interaction_data":"","is_stick":true,"is_subject":false,"item_id":6606040831663014413,"item_version":0,"keywords":"中国石油,民营经济,国有企业,非公有制经济,民营企业,公有制经济","label":"置顶","label_extra":{"icon_url":{},"is_redirect":false,"redirect_url":"","style_type":0},"label_style":1,"level":0,"log_pb":{"impr_id":"20180928211622010020078072091F055","is_following":"0"},"media_info":{"avatar_url":"http://p3.pstatp.com/large/ca400072481685ad43b","follow":false,"is_star_user":false,"media_id":50502346173,"name":"人民网","recommend_reason":"","recommend_type":0,"user_id":50502346173,"user_verified":true,"verified_content":""},"media_name":"人民网","need_client_impr_recycle":1,"publish_time":1538088738,"read_count":2202593,"repin_count":13125,"rid":"20180928211622010020078072091F055","share_count":13601,"share_info":{"cover_image":null,"description":null,"on_suppress":0,"share_type":{"pyq":0,"qq":0,"qzone":0,"wx":0},"share_url":"http://m.toutiao.com/group/6606040831663014413/?iid=0\u0026app=news_article\u0026is_hit_share_recommend=0","title":"总书记一锤定音，关于民企的无谓争论可休矣","token_type":1,"weixin_cover_image":{"height":1121,"uri":"large/tos-cn-i-0000/02964130-c2a8-11e8-9dc5-0cc47ad28bf2","url":"http://p3.pstatp.com/large/tos-cn-i-0000/02964130-c2a8-11e8-9dc5-0cc47ad28bf2","url_list":[{"url":"http://p3.pstatp.com/large/tos-cn-i-0000/02964130-c2a8-11e8-9dc5-0cc47ad28bf2"},{"url":"http://pb9.pstatp.com/large/tos-cn-i-0000/02964130-c2a8-11e8-9dc5-0cc47ad28bf2"},{"url":"http://pb1.pstatp.com/large/tos-cn-i-0000/02964130-c2a8-11e8-9dc5-0cc47ad28bf2"}],"width":900}},"share_url":"http://m.toutiao.com/group/6606040831663014413/?iid=0\u0026app=news_article\u0026is_hit_share_recommend=0","show_dislike":false,"show_portrait":false,"show_portrait_article":false,"source":"人民网","source_icon_style":5,"source_open_url":"sslocal://profile?uid=50502346173","stick_label":"置顶","stick_style":1,"tag":"news_politics","tag_id":6606040831663014413,"tip":0,"title":"总书记一锤定音，关于民企的无谓争论可休矣","ugc_recommend":{"activity":"","reason":"人民网官方头条号"},"url":"https://m2.people.cn/r/MV8xXzMwMzE3NTgwXzEwMDNfMTUzODA4ODQwMQ==?source=da","user_info":{"avatar_url":"http://p3.pstatp.com/thumb/ca400072481685ad43b","description":"人民网官方头条号:权威、实力，源自人民","follow":false,"follower_count":0,"name":"人民网","schema":"sslocal://profile?uid=50502346173\u0026refer=all","user_auth_info":"{\"auth_type\": \"0\", \"auth_info\": \"人民网官方头条号\"}","user_id":50502346173,"user_verified":true,"verified_content":"人民网官方头条号"},"user_repin":0,"user_verified":1,"verified_content":"人民网官方头条号","video_style":0}

struct LCHomeNewsDesc: Decodable {
    let abstract: String
    
    struct newsAction: Decodable {
        let action: Int
        let desc: String

        struct actionExtra: Decodable {

        }
        let extra: actionExtra
    }
    let action_list: [newsAction]?
    let aggr_type: Int
    let allow_download: Bool
    let article_alt_url: String?
    let article_sub_type: Int
    let article_type: Int
    let article_url: String
    let ban_comment: Int
    let behot_time: Int
    let bury_count: Int
    let cell_flag: Int
    let cell_layout_style: Int
    let cell_type: Int
    let comment_count: Int //
    let cursor: Int
    let digg_count: Int
    let display_url: String

    struct newForward_info: Decodable {
        let forward_count: Int
    }
    let forward_info: newForward_info
    let gallary_flag: Int?
    let gallary_image_count: Int?
    let group_flags: Int?
    let group_id: Int?
    let has_image: Bool?            // 有图片？
    let has_m3u8_video: Bool?
    let has_mp4_video: Int?
    let has_video: Bool?            // 有视频？
    let hot: Int
    let ignore_web_transform: Int
    
    struct newsImage_list: Decodable{
        let height: Int
        let width: Int
        let uri: String
        let url: String
        var urlString: String {
            guard url.contains(".webp") else { return url}
            return url.replacingOccurrences(of: ".webp", with: ".png")
        }
        struct imageUrl: Decodable {
            let url: String
            var urlString: String {
                guard url.contains(".webp") else { return url}
                return url.replacingOccurrences(of: ".webp", with: ".png")
            }
        }
        let url_list: [imageUrl]
    }
    let image_list: [newsImage_list]?
    let is_stick: Bool?
    let is_subject: Bool
    let item_id: Int
    let item_version: Int
    let keywords: String?           //关键词
    
    let large_image_list: [newsImage_list]?
    
    let label: String?
    let label_style: Int?
    let level: Int
    let like_count: Int?

    struct newsLog_pb: Decodable {
        let impr_id: String
    }
    let log_pb: newsLog_pb

    struct newMedia_info: Decodable {
        let avatar_url: String
        let follow: Bool
        let is_star_user: Bool
        let media_id: Int
        let name: String
        let recommend_reason: String
        let recommend_type: Int
        let user_id: Int
        let user_verified: Bool
        let verified_content: String
    }
    let media_info: newMedia_info?
    let media_name: String?
    let middle_image: newsImage_list?
    let preload_web: Int?
    let publish_time: Int
    let read_count: Int
    let repin_count: Int?
    let rid: String
    let share_count: Int
    let share_url: String
    let show_portrait: Bool
    let show_portrait_article: Bool
    let source: String
    let source_icon_style: Int
    let source_open_url: String
    let stick_label: String?        // 置顶
    let stick_style: Int?
    let tag: String?
    let tag_id: Int?
    let tip: Int
    let title: String               // 大标题

    struct newUgc_recommend: Decodable {
        let activity: String
        let reason: String
    }
    let ugc_recommend: newUgc_recommend
    let url: String

    struct newUser_info: Decodable {
        let avatar_url: String
        let description: String?
        let follow: Bool
        let follower_count: Int
        let name: String

        struct user_info_auth: Decodable {
            let auth_type: String
            let auth_info: String
        }
        let user_auth_info: String?
        var user_auth_info_model: user_info_auth?
        let user_id: Int
        let user_verified: Bool
        let verified_content: String?
    }
    var user_info: newUser_info?
    let user_repin: Int
    let user_verified: Int
    let verified_content: String

    struct newVideo_detail_info: Decodable {
        let detail_video_large_image: newsImage_list
        let direct_play: Int
        let group_flags: Int
        let show_pgc_subscribe: Int
        let video_id: String
        let video_preloading_flag: Int
        let video_type: Int
        let video_watch_count: Int
        let video_watching_count: Int
    }
    let video_detail_info: newVideo_detail_info?
    let video_style: Int
    let video_duration: Int?
    var video_main_url: String?
    
}



struct LCHomeNewsData: Decodable {
    let message: String
    
    struct LCHomeNews: Decodable {
        let code: String
        let content: String
        var contentModel: LCHomeNewsDesc?
    }
    var data: [LCHomeNews]
}

extension LCHomeNewsDesc: ResponseToModel{}
extension LCHomeNewsDesc.newUser_info.user_info_auth: ResponseToModel{}

extension LCHomeNewsData: ResponseToModel{
    static func modelformNewsData(_ data: Data) -> LCHomeNewsData? {
//        let dict = swiftyJSONFrom(response: response)
//        if let json = try? dict.rawData(){
            if let newsData = modelform(data: data){
                var newsData_m = newsData
                newsData_m.data = newsData.data.map { homeNews -> LCHomeNewsData.LCHomeNews in
                    if let contentModel = LCHomeNewsDesc.modelform(content: homeNews.content){
                        var contentModel_m = contentModel
                        contentModel_m.user_info?.user_auth_info_model = contentModel.user_info?.user_auth_info.flatMap{ LCHomeNewsDesc.newUser_info.user_info_auth.modelform(content: $0) }
                        return LCHomeNews.init(code: homeNews.code, content: "", contentModel: contentModel_m)
                    }
                    return homeNews
                }
                return newsData_m
            }
//        }
        return nil
    }
}
