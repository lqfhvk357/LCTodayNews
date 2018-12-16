//
//  LCVideoInfo.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/10.
//  Copyright © 2018 罗超. All rights reserved.
//

import Foundation

/*
{
    "data" : {
        "user_id" : "toutiao",
        "status" : 10,
        "video_list" : {
            "video_1" : {
                "backup_url_1" : "aHR0cDovL3Y3LnBzdGF0cC5jb20vYmVjYmI3OWU5YmZiZTllNmExN2M2YWNmMWY0NjM4OTYvNWMwZTgzOTQvdmlkZW8vbS8yMjA1MDY1NjI1NjQzNjY0NGQ0YjdmODY3ZjQ2ZTY5NGMxOTExNjEwMmZiNzAwMDA5YjljNDBiNmFlM2IvP3JjPU16czViSEU2T3pwNWFUTXpaVGN6TTBBcFFIUkFielkyTlRnM016VXpNek0wTlRRME5EVnZRR2d6ZFNsQVpqTjFLV1J6Y21kNWEzVnlaM2x5YkhoM1pqVXpRR3RtYm1ReWEzRm5jVjh0TFRZdEwzTnpMVzhqYnlNeUx6TXVNekF0TGpVeUx5MHZOUzA2STI4ak9tRXRjU002WUhacFhHSm1LMkJlWW1ZclhuRnNPaU11TDE0JTNE",
                "codec_type" : "h264",
                "vwidth" : 854,
                "main_url" : "aHR0cDovL3YxLXR0Lml4aWd1YS5jb20vZWIwNTQ3OTE5MDliZWI0MzdkMWM5MzFiZTQ5NDQ3YzcvNWMwZTgzOTQvdmlkZW8vbS8yMjA1MDY1NjI1NjQzNjY0NGQ0YjdmODY3ZjQ2ZTY5NGMxOTExNjEwMmZiNzAwMDA5YjljNDBiNmFlM2IvP3JjPU16czViSEU2T3pwNWFUTXpaVGN6TTBBcFFIUkFielkyTlRnM016VXpNek0wTlRRME5EVnZRR2d6ZFNsQVpqTjFLV1J6Y21kNWEzVnlaM2x5YkhoM1pqVXpRR3RtYm1ReWEzRm5jVjh0TFRZdEwzTnpMVzhqYnlNeUx6TXVNekF0TGpVeUx5MHZOUzA2STI4ak9tRXRjU002WUhacFhHSm1LMkJlWW1ZclhuRnNPaU11TDE0JTNE",
                "definition" : "480p",
                "size" : 16519019,
                "logo_type" : "xigua_share",
                "preload_size" : 327680,
                "spade_a" : "",
                "user_video_proxy" : 1,
                "quality" : "normal",
                "bitrate" : 797294,
                "preload_max_step" : 10,
                "preload_min_step" : 5,
                "file_hash" : "6cffbf1d8e4e2c1e4c7b2366d792179f",
                "encrypt" : false,
                "vheight" : 480,
                "socket_buffer" : 17938980,
                "preload_interval" : 60,
                "vtype" : "mp4"
            }
        },
        "enable_ssl" : false,
        "media_type" : "video",
        "auto_definition" : "480p",
        "dynamic_video" : null,
        "poster_url" : "http:\/\/p3.pstatp.com\/origin\/1258d00056a9281ef90e8",
        "video_id" : "v020049b0000bftvj7t8n75ngiq6i8n0",
        "validate" : "",
        "video_duration" : 152.56
    },
    "message" : "success",
    "total" : 1,
    "code" : 0
}
*/
struct LCVideoInfo: Decodable {
    struct Video_list: Decodable {
        struct Video_1: Decodable {
            let main_url: String
        }
        let video_1: Video_1
    }
    let video_list: Video_list
}


struct LCVideoInfoData: Decodable {
    let message: String
    let data: LCVideoInfo
    
}

extension LCVideoInfoData: ResponseToModel{}
