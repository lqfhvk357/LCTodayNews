//
//  LCSectionHeader.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/7.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import SwiftyJSON

class LCSectionHeader: UICollectionReusableView {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var dataDict = Dictionary<String, String>() {
        didSet {
            mainTitleLabel.text = dataDict[KMainTitle]
            subTitleLabel.text = dataDict[KSubTitle]
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
}
