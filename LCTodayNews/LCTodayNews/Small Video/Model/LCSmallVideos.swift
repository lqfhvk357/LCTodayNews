//
//  LCSmallVideos.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/12.
//  Copyright © 2018 罗超. All rights reserved.
//

import Foundation

/*
 "raw_data":{
 "status":{
 "allow_share":true,
 "allow_comment":true,
 "allow_download":true,
 "is_delete":false
 },
 "first_frame_image_list":[
 {
 "url":"http://lf1-ttcdn-tos.pstatp.com/img/mosaic-legacy/37a10000521b43f1a363~noop.jpeg",
 "url_list":[
 {
 "url":"http://lf1-ttcdn-tos.pstatp.com/img/mosaic-legacy/37a10000521b43f1a363~noop.jpeg"
 }
 ],
 "uri":"37a10000521b43f1a363",
 "height":960,
 "width":540,
 "image_type":1
 }
 ],
 "recommand_reason":"",
 "title":"哈哈",
 "animated_image_list":[
 {
 "url":"http://lf1-ttcdn-tos.pstatp.com/obj/mosaic-legacy/30a8001378b9049f5f73",
 "url_list":[
 {
 "url":"http://lf1-ttcdn-tos.pstatp.com/obj/mosaic-legacy/30a8001378b9049f5f73"
 }
 ],
 "uri":"30a8001378b9049f5f73",
 "height":960,
 "width":540,
 "image_type":2
 }
 ],
 "detail_schema":"sslocal://awemevideo?group_id=6446971495095733518&group_source=19&item_id=6446971495095733518&request_id=20170907211023172020030003865E42&enter_from=click_category&category_name=hotsoon_video&log_pb=%7B%22impr_id%22%3A%2220170907211023172020030003865E42%22%7D&gd_ext_json=%7B%22log_pb%22%3A%7B%22impr_id%22%3A%2220170907211023172020030003865E42%22%7D%7D",
 "app_schema":"snssdk1128://feed",
 "share":{
 "share_weibo_desc":"#抖音上瘾# @小妹. ⚡ 发了一个抖音短视频，你尽管点开，不好看算我输！戳这里>>",
 "share_title":"@小妹. ⚡发了一个抖音短视频，你尽管点开，不好看算我输！",
 "share_url":"https://www.amemv.com/share/video/6446971495095733518",
 "share_desc":"哈哈"
 },
 "publish_reason":{
 "verb":"",
 "noun":""
 },
 "label":"",
 "action":{
 "read_count":0,
 "user_bury":0,
 "bury_count":0,
 "forward_count":0,
 "digg_count":661,
 "play_count":112867,
 "comment_count":54,
 "user_repin":0,
 "user_digg":0
 },
 "create_time":1501052538,
 "video":{
 "ratio":"720p",
 "play_addr":{
 "url_list":[
 "https://aweme.snssdk.com/aweme/v1/play/?video_id=4c472eaad3df429f997ff0b09ed6344a&line=0",
 "https://aweme.snssdk.com/aweme/v1/play/?video_id=4c472eaad3df429f997ff0b09ed6344a&line=1"
 ],
 "uri":"4c472eaad3df429f997ff0b09ed6344a"
 },
 "video_id":"4c472eaad3df429f997ff0b09ed6344a",
 "height":960,
 "width":540,
 "download_addr":{
 "url_list":[
 "https://aweme.snssdk.com/aweme/v1/play/?video_id=4c472eaad3df429f997ff0b09ed6344a&ratio=720p&watermark=1&line=0",
 "https://aweme.snssdk.com/aweme/v1/play/?video_id=4c472eaad3df429f997ff0b09ed6344a&ratio=720p&watermark=1&line=1"
 ],
 "uri":"4c472eaad3df429f997ff0b09ed6344a"
 },
 "origin_cover":{
 "url_list":[
 "http://lf1-ttcdn-tos.pstatp.com/img/mosaic-legacy/30a70017b0891ffa481e~noop.jpeg"
 ],
 "uri":"30a70017b0891ffa481e"
 },
 "duration":15.067
 },
 "user":{
 "info":{
 "user_id":55455423761,
 "name":"小妹. ⚡",
 "verified_content":"",
 "avatar_url":"http://p3.pstatp.com/thumb/33070002298d30b4afa4",
 "desc":"",
 "schema":"sslocal://profile?uid=55455423761&refer=dongtai",
 "user_verified":0,
 "medals":null,
 "user_auth_info":""
 },
 "relation":{
 "is_followed":0,
 "is_following":0,
 "is_friend":0
 },
 "relation_count":{
 "followers_count":0,
 "followings_count":0
 }
 },
 "large_image_list":[
 {
 "url":"http://lf1-ttcdn-tos.pstatp.com/img/mosaic-legacy/30a70017b0891ffa481e~noop.jpeg",
 "url_list":[
 {
 "url":"http://lf1-ttcdn-tos.pstatp.com/img/mosaic-legacy/30a70017b0891ffa481e~noop.jpeg"
 }
 ],
 "uri":"30a70017b0891ffa481e",
 "height":960,
 "width":540,
 "image_type":1
 }
 ],
 "group_source":19,
 "item_id":6446971495095733000,
 "music":{
 "album":"",
 "cover_hd":null,
 "author":"李遐怡 - 1,2,3,4",
 "music_id":6377246668945001000,
 "cover_large":null,
 "title":"1,2,3,4",
 "cover_medium":null,
 "cover_thumb":null
 },
 "group_id":6446971495095733000,
 "thumb_image_list":[
 {
 "url":"http://lf1-ttcdn-tos.pstatp.com/img/mosaic-legacy/30a70017b0891ffa481e~noop.jpeg",
 "url_list":[
 {
 "url":"http://lf1-ttcdn-tos.pstatp.com/img/mosaic-legacy/30a70017b0891ffa481e~noop.jpeg"
 }
 ],
 "uri":"30a70017b0891ffa481e",
 "height":604,
 "width":375,
 "image_type":1
 }
 ]
 },
 */

struct LCVideoDesc: Decodable {
    
    struct RowDataModel: Decodable {
        struct modelStatus: Decodable {
            let allow_share: Bool
            let allow_comment: Bool
            let allow_download: Bool
            let is_delete: Bool
        }
        let status: modelStatus
        
        struct modelAction: Decodable {
            let digg_count: Int
            let play_count: Int
        }
        let action: modelAction
        let first_frame_image_list: [LCHomeNewsDesc.newsImage_list]
        let animated_image_list: [LCHomeNewsDesc.newsImage_list]
        let large_image_list: [LCHomeNewsDesc.newsImage_list]
        let title: String
        
        struct videoModel: Decodable{
            let width: Int
            let height: Int
            
            struct Address: Decodable{
                let url_list: [String]
                let uri: String
                
            }
            let play_addr: Address
            let download_addr: Address
            let origin_cover: Address
        }
        let video: videoModel
    }
    let raw_data: RowDataModel
}

struct LCSmallVideos: Decodable {
    let message: String
    
    struct LCVideoNews: Decodable {
        let code: String
        let content: String
        var contentModel: LCVideoDesc?
    }
    var data: [LCVideoNews]
    let has_more: Bool
    let has_more_to_refresh: Bool
}

extension LCVideoDesc: ResponseToModel {}

extension LCSmallVideos: ResponseToModel{
    static func modelformVideoData(_ data: Data) -> LCSmallVideos? {
        if let newsData = modelform(data: data){
            var newsData_m = newsData
            newsData_m.data = newsData.data.map { homeNews -> LCSmallVideos.LCVideoNews in
                if let contentModel = LCVideoDesc.modelform(content: homeNews.content){
                    return LCVideoNews.init(code: homeNews.code, content: "", contentModel: contentModel)
                }
                return homeNews
            }
            return newsData_m
        }
        return nil
    }
}
