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
import Kingfisher

class LCNewsCell: UITableViewCell {
    let titleV = UIView()
    let bigTitleL = UILabel()
    let titleImageV = UIImageView()
    let groupImageView = UIView()
    var imageView0 = UIImageView()
    var imageView1 = UIImageView()
    var imageView2 = UIImageView()
    let bigImageView = UIImageView()
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
            guard let news = news else {
                return
            }
            
            bigTitleL.text = news.title
            bigTitleL.yogaLayout()
            
            if news.hot == 1 {
                hotL.yoga.display = .flex
                stateL.yoga.display = .none
                closeBtn.isHidden = false
            }else if let style = news.label_style, style == 1{
                hotL.yoga.display = .none
                stateL.yoga.display = .flex
                closeBtn.isHidden = true
            }else {
                hotL.yoga.display = .none
                stateL.yoga.display = .none
                closeBtn.isHidden = false
            }
            
            closeBtn.isHidden = true
            
            if let media_name = news.media_name, media_name != "" {
                sourceL.yoga.display = .flex
                sourceL.text = media_name
            }else{
                sourceL.yoga.display = .none
            }
            
            commentL.text = "\(news.comment_count)评论"
            timeL.text = TimeInterval(news.publish_time).timeString()
            
            sourceL.yogaLayout()
            commentL.yogaLayout()
            timeL.yogaLayout()
            
            if let has_video = news.has_video, has_video {
                if let has_image = news.has_image, has_image, news.video_style == 0 { //右侧小图
                    showRightImage()
                }else if news.video_style == 2 {
                    if let large_image = news.video_detail_info?.detail_video_large_image {
                        showBigImage(with: large_image.urlString)
                    }else {
                        hiddenAllImage()
                    }
                }else if news.middle_image != nil { //右侧小图
                    showRightImage()
                }else {
                    hiddenAllImage()
                }
            }else {
                if let has_image = news.has_image, has_image {
                    if let image_list = news.image_list, image_list.count == 1 { //右侧小图
                        showRightImage()
                    }else if let image_list = news.image_list, image_list.count > 1 { //三张小图
                        showGroupImage()
                    }else if let large_image = news.large_image_list?.first{ //大图
                        showBigImage(with: large_image.urlString)
                    }else if news.middle_image != nil { //右侧小图
                        showRightImage()
                    } else {
                        hiddenAllImage()
                    }
                }else {
                    hiddenAllImage()
                }
            }
        }
    }
    
    
    //MARK: - override super
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.yoga.applyLayout(preservingOrigin: true, dimensionFlexibility: .flexibleHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize{
        contentView.yoga.applyLayout(preservingOrigin: true, dimensionFlexibility: .flexibleHeight)
        return contentView.sizeThatFits(size)
    }
    
    //MARK: -  Views
    func setupCell() {
        setupContentView()
        setupTitleView()
        setupGroupView()
        setupBigImageView()
        setupSourceView()
        setupMoreView()
//        clearSubViewsColors(with: contentView)
    }
    
    fileprivate func setupContentView() {
        contentView.configureLayout { layout in
            layout.isEnabled = true
            layout.padding = 15
            layout.position = .relative
        }
    }
    
    fileprivate func setupTitleView() {
        contentView.addSubview(titleV)
        titleV.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = .row
        }
        
        
        bigTitleL.numberOfLines = 2
        bigTitleL.font = UIFont.systemFont(ofSize: 16.5)
//        bigTitleL.backgroundColor = UIColor.yellow
        titleV.addSubview(bigTitleL)
        bigTitleL.configureLayout { layout in
            layout.isEnabled = true
            layout.flexGrow = 1
            layout.width = 0
        }
        
        
        titleImageV.backgroundColor = UIColor.gray
        titleV.addSubview(titleImageV)
        titleImageV.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 15
            layout.width = YGValue(93 * ScreenWidth / 320)
            layout.aspectRatio = 93/60
        }
    }
    
    fileprivate func setupSourceView() {
        contentView.addSubview(sourceV)
//        sourceV.backgroundColor = UIColor.green
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
        
        let sysFont12 = UIFont.systemFont(ofSize: 12)
        let textSize = stateL.text?.textSize(font: sysFont12, width: contentView.width-30)
        sourceV.addSubview(stateL)
        stateL.configureLayout { layout in
            layout.isEnabled = true
            layout.width = YGValue(textSize!.width + CGFloat(5))
            layout.marginRight = 5
        }
        
        hotL.text = "热"
        hotL.textColor = UIColor.red
        hotL.font = UIFont.systemFont(ofSize: 12)
        hotL.textAlignment = .center
        hotL.layer.borderColor = UIColor.red.cgColor
        hotL.layer.borderWidth = 0.5
        hotL.layer.cornerRadius = 3
        hotL.layer.masksToBounds = true
        
        let hotTextSize = hotL.text?.textSize(font: sysFont12, width: contentView.width-30)
        sourceV.addSubview(hotL)
        hotL.configureLayout { layout in
            layout.isEnabled = true
            layout.width = YGValue(hotTextSize!.width + CGFloat(5))
            layout.marginRight = 5
        }
        
        sourceL.textColor = UIColor.gray
//        sourceL.backgroundColor = .yellow
        sourceL.font = UIFont.systemFont(ofSize: 11)
        sourceV.addSubview(sourceL)
        sourceL.configureLayout { layout in
            layout.isEnabled = true
            layout.marginRight = 5
        }
        
        
        commentL.textColor = UIColor.gray
//        commentL.backgroundColor = .yellow
        commentL.font = UIFont.systemFont(ofSize: 11)
        sourceV.addSubview(commentL)
        commentL.configureLayout { layout in
            layout.isEnabled = true
            layout.marginRight = 6
        }
        
        
        timeL.textColor = UIColor.gray
//        timeL.backgroundColor = .yellow
        timeL.font = UIFont.systemFont(ofSize: 11)
        sourceV.addSubview(timeL)
        timeL.configureLayout { layout in
            layout.isEnabled = true
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
    }
    
    fileprivate func setupGroupView() {
//        groupImageView.backgroundColor = UIColor.gray
        contentView.addSubview(groupImageView)
        groupImageView.configureLayout { layout in
            layout.isEnabled = true
            layout.aspectRatio = 288/70
//            layout.padding = 5
            layout.flexDirection = .row
            
        }
        
        for i in 0...2 {
            let imageV = UIImageView()
            imageV.backgroundColor = UIColor.gray
            groupImageView.addSubview(imageV)
            imageV.configureLayout { layout in
                layout.isEnabled = true
                if i != 0 {
                    layout.marginLeft = 5
                }
                layout.marginTop = 5
                layout.marginBottom = 5
                layout.flexGrow = 1
                layout.width = 1
            }
            
            switch i {
                case 0: imageView0 = imageV
                case 1: imageView1 = imageV
                case 2: imageView2 = imageV
            default:
                break
            }
        }
    }
    
    fileprivate func setupBigImageView() {
        contentView.addSubview(bigImageView)
        bigImageView.backgroundColor = UIColor.gray
        bigImageView.isUserInteractionEnabled = true
        bigImageView.configureLayout { layout in
            layout.isEnabled = true
            layout.aspectRatio = 580 / 326
        }
    }
    
    fileprivate func setupMoreView() {
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
    
    //MARK: - Private
    func setupRightImage() {
        if let urlString = news?.image_list?.first?.urlString {
            titleImageV.kf.setImage(with: URL(string: urlString))
        }else if let urlString = news?.middle_image?.urlString {
            titleImageV.kf.setImage(with: URL(string: urlString))
        }else if let urlString = news?.large_image_list?.first?.urlString {
            titleImageV.kf.setImage(with: URL(string: urlString))
        }
    }
    
    func showRightImage() {
        bigTitleL.numberOfLines = 3
        titleImageV.yoga.display = .flex
        bigImageView.yoga.display = .none
        groupImageView.yoga.display = .none
        setupRightImage()
    }
    
    func showGroupImage() {
        bigTitleL.numberOfLines = 2
        titleImageV.yoga.display = .none
        bigImageView.yoga.display = .none
        groupImageView.yoga.display = .flex
        
        if let image_list = news?.image_list {
            for i in 0...image_list.count-1 {
                switch i {
                case 0: imageView0.kf.setImage(with: URL(string: image_list[i].urlString))
                case 1: imageView1.kf.setImage(with: URL(string: image_list[i].urlString))
                case 2: imageView2.kf.setImage(with: URL(string: image_list[i].urlString))
                default:
                    break
                }
            }
        }
    }
    
    func hiddenAllImage() {
        bigTitleL.numberOfLines = 2
        titleImageV.yoga.display = .none
        bigImageView.yoga.display = .none
        groupImageView.yoga.display = .none
    }
    
    func showBigImage(with urlString: String) {
        bigTitleL.numberOfLines = 2
        titleImageV.yoga.display = .none
        bigImageView.yoga.display = .flex
        groupImageView.yoga.display = .none
        bigImageView.kf.setImage(with: URL(string: urlString))
    }
    
    func clearSubViewsColors(with contentView: UIView) {
        for view in contentView.subviews {
            view.backgroundColor = UIColor.clear
            if view.subviews.count > 0 {
                clearSubViewsColors(with: view)
            }
        }
    }
    
    

}
