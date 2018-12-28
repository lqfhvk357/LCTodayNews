//
//  LCSmallVideoCell.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/11.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit
import Kingfisher

class LCSmallVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var playNumL: UILabel!
    @IBOutlet weak var zanNumL: UILabel!
    
    var news: LCVideoDesc? {
        didSet {
            guard let newsData = news else {
                return
            }
            
            titleL.text = newsData.raw_data.title
            
            if let urlString = newsData.raw_data.large_image_list.first?.urlString {
                backImageView.kf.setImage(with: URL(string: urlString))
            }
//            if let urlString = newsData.raw_data.video.origin_cover.url_list.first {
//                backImageView.kf.setImage(with: URL(string: urlString))
//            }
            
            if newsData.raw_data.action.play_count > 10000 {
                let text = String(format: "%.2f万次播放", Double(newsData.raw_data.action.play_count) / 10000.0)
                playNumL.text = text
            }else{
                playNumL.text = "\(newsData.raw_data.action.play_count)次播放"
            }
            
            if newsData.raw_data.action.digg_count > 10000 {
                let text = String(format: "%.2f万赞", Double(newsData.raw_data.action.digg_count) / 10000.0)
                zanNumL.text = text
            }else{
                zanNumL.text = "\(newsData.raw_data.action.digg_count)赞"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backImageView.contentMode = .scaleAspectFit
        backImageView.backgroundColor = .black
        // Initialization code
    }
    
    

}
