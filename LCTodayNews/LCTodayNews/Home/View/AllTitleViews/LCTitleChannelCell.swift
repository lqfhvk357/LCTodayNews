//
//  LCTitleChannelCell.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/6.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

class LCTitleChannelCell: UITableViewCell {
    
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var titlesCollectionView: UICollectionView!
    
    @IBOutlet weak var titlesCollectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var titlesCollectionViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        finishButton.layer.cornerRadius = 3
        finishButton.layer.masksToBounds = true
        finishButton.layer.borderWidth = 1
        finishButton.layer.borderColor = UIColor.red.cgColor
        
        self.titlesCollectionLayout.itemSize = CGSize(width: 70, height: 44)
        self.titlesCollectionLayout.minimumInteritemSpacing = 6
        self.titlesCollectionLayout.minimumLineSpacing = 6
        self.titlesCollectionLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
