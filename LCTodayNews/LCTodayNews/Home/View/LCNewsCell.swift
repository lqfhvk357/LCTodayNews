//
//  LCNewsCell.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/8.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import YogaKit
import SnapKit
import RxCocoa
import RxSwift

class LCNewsCell: UITableViewCell {
    let titleV = UIView()
    let bigTitleL = UILabel()
    let titleImageV = UIImageView()
    let groupImageView = UIView()
    let bigImageViewBackV = UIView()
    let sourceV = UIView()
    let stateL = UILabel()
    let hotL = UILabel()
    let sourceL = UILabel()
    let commentL = UILabel()
    let timeL = UILabel()
    let closeBtn = UIButton()
    let moreV = UIView()
    
    var news: LCHomeNewsDesc? {
        didSet {
            guard let newsData = news else {
                return
            }
            
            bigTitleL.text = newsData.title
            bigTitleL.yogaLayout()
            
            if newsData.hot == 1 {
                hotL.yoga.display = .flex
                stateL.yoga.display = .none
                closeBtn.isHidden = false
            }else if let style = newsData.label_style, style == 1{
                hotL.yoga.display = .none
                stateL.yoga.display = .flex
                closeBtn.isHidden = true
            }else {
                hotL.yoga.display = .none
                stateL.yoga.display = .none
                closeBtn.isHidden = false
            }
            
            if let media_name = newsData.media_name, media_name != "" {
                sourceL.yoga.display = .flex
                sourceL.text = media_name
            }else{
                sourceL.yoga.display = .none
            }
            
            commentL.text = "\(newsData.comment_count)评论"
            timeL.text = TimeInterval(newsData.publish_time).timeString()
            
            sourceL.yogaLayout()
            commentL.yogaLayout()
            timeL.yogaLayout()
            
            if let has_video = newsData.has_video, has_video {
                if let has_image = newsData.has_image, has_image, newsData.video_style == 0 {
                    titleImageV.yoga.display = .flex
                    bigImageViewBackV.yoga.display = .none
                    groupImageView.yoga.display = .none
                }else if newsData.video_style == 2 {
                    titleImageV.yoga.display = .none
                    bigImageViewBackV.yoga.display = .flex
                    groupImageView.yoga.display = .none
                }else {
                    titleImageV.yoga.display = .none
                    bigImageViewBackV.yoga.display = .none
                    groupImageView.yoga.display = .none
                }
            }else {
                if let has_image = newsData.has_image, has_image {
                    //                    print(newsData)
                    if let image_list = newsData.image_list, image_list.count == 1 { //右侧小图
                        titleImageV.yoga.display = .flex
                        bigImageViewBackV.yoga.display = .none
                        groupImageView.yoga.display = .none
                    }else if let image_list = newsData.image_list, image_list.count > 1 { //三张小图
                        titleImageV.yoga.display = .none
                        bigImageViewBackV.yoga.display = .none
                        groupImageView.yoga.display = .flex
                    }else if let large_image_list = newsData.large_image_list, let image = large_image_list.first { //大图
                        image.url
                        titleImageV.yoga.display = .none
                        bigImageViewBackV.yoga.display = .flex
                        groupImageView.yoga.display = .none
                    }else if let middle_image = newsData.middle_image { //右侧小图
                        middle_image.url
                        titleImageV.yoga.display = .flex
                        bigImageViewBackV.yoga.display = .none
                        groupImageView.yoga.display = .none
                    } else {
                        titleImageV.yoga.display = .none
                        bigImageViewBackV.yoga.display = .none
                        groupImageView.yoga.display = .none
                    }
                }else {
                    titleImageV.yoga.display = .none
                    bigImageViewBackV.yoga.display = .none
                    groupImageView.yoga.display = .none
                }
            }
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    func setupCell() {
        contentView.configureLayout { layout in
            layout.isEnabled = true
            layout.padding = 15
            layout.position = .relative
        }
        
        
        contentView.addSubview(titleV)
        titleV.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = .row
        }
        
        
        bigTitleL.numberOfLines = 2
        bigTitleL.font = UIFont.systemFont(ofSize: 16.5)
        bigTitleL.backgroundColor = UIColor.yellow
        titleV.addSubview(bigTitleL)
        bigTitleL.configureLayout { layout in
            layout.isEnabled = true
            layout.flexGrow = 1
            layout.width = 0
        }
        
       
        titleImageV.backgroundColor = UIColor.red
        titleV.addSubview(titleImageV)
        titleImageV.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 15
            layout.width = 93
            layout.height = 60
        }
        
//        titleImageV.yoga.display = .none
        
        
        groupImageView.backgroundColor = UIColor.purple
        contentView.addSubview(groupImageView)
        groupImageView.configureLayout { layout in
            layout.isEnabled = true
            layout.height = 70
            layout.padding = 5
            layout.flexDirection = .row
            
        }
        
        for i in 0...2 {
            let imageV = UIImageView()
            imageV.backgroundColor = UIColor.orange
            groupImageView.addSubview(imageV)
            imageV.configureLayout { layout in
                layout.isEnabled = true
                if i != 0 {
                    layout.marginLeft = 5
                }
                layout.flexGrow = 1
            }
        }
        
        
        contentView.addSubview(bigImageViewBackV)
        bigImageViewBackV.backgroundColor = UIColor.cyan
        bigImageViewBackV.configureLayout { layout in
            layout.isEnabled = true
            layout.aspectRatio = 580 / 326
        }
        
        
        
        
        
        contentView.addSubview(sourceV)
        sourceV.backgroundColor = UIColor.green
        sourceV.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.height = 18
        }
        
        
        
        stateL.text = "置顶"
        stateL.textColor = UIColor.red
        stateL.font = UIFont.systemFont(ofSize: 12)
        stateL.textAlignment = .center
        stateL.layer.borderColor = UIColor.red.cgColor
        stateL.layer.borderWidth = 0.5
        stateL.layer.cornerRadius = 3
        stateL.layer.masksToBounds = true
        
        let textSize = stateL.text?.textSize(systemFontSize: 12, width: contentView.width-30)
        sourceV.addSubview(stateL)
        stateL.configureLayout { layout in
            layout.isEnabled = true
            layout.width = YGValue(textSize!.width + CGFloat(5))
        }
        
        
        hotL.text = "热"
        hotL.textColor = UIColor.red
        hotL.font = UIFont.systemFont(ofSize: 12)
        hotL.textAlignment = .center
        hotL.layer.borderColor = UIColor.red.cgColor
        hotL.layer.borderWidth = 0.5
        hotL.layer.cornerRadius = 3
        hotL.layer.masksToBounds = true
        
        let hotTextSize = hotL.text?.textSize(systemFontSize: 12, width: contentView.width-30)
        sourceV.addSubview(hotL)
        hotL.configureLayout { layout in
            layout.isEnabled = true
            layout.width = YGValue(hotTextSize!.width + CGFloat(5))
        }
        
        
        sourceL.textColor = UIColor.gray
//        sourceL.text = "新华网"
        sourceL.backgroundColor = .red
        sourceL.font = UIFont.systemFont(ofSize: 11)
        sourceV.addSubview(sourceL)
        sourceL.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 5
        }
        
        
        commentL.textColor = UIColor.gray
//        commentL.text = "1001评论"
        commentL.backgroundColor = .yellow
        commentL.font = UIFont.systemFont(ofSize: 11)
        sourceV.addSubview(commentL)
        commentL.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 6
        }
        
        
        timeL.textColor = UIColor.gray
//        timeL.text = "刚刚"
        timeL.backgroundColor = .blue
        timeL.font = UIFont.systemFont(ofSize: 11)
        sourceV.addSubview(timeL)
        timeL.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 6
        }
        
        
        closeBtn.backgroundColor = UIColor.gray
        closeBtn.layer.borderColor = UIColor.gray.cgColor
        closeBtn.layer.borderWidth = 0.5
        closeBtn.layer.cornerRadius = 4
        closeBtn.layer.masksToBounds = true
        sourceV.addSubview(closeBtn)
        closeBtn.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 18
            layout.height = 13
            layout.right = 0
            layout.position = .absolute
        }
        
        
        
        moreV.backgroundColor = UIColor.gray
        moreV.layer.cornerRadius = 5
        moreV.layer.masksToBounds = true
        contentView.addSubview(moreV)
        moreV.configureLayout { layout in
            layout.isEnabled = true
            layout.marginTop = 15
            layout.height = 36
        }
        
        moreV.yoga.display = .none
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.yoga.applyLayout(preservingOrigin: true)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
