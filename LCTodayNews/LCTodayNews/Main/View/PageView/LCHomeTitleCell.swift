//
//  LCHomeTitleCell.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/4.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import RxSwift

class LCHomeTitleCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var homeTitle: LCPageHeaderTitle? {
        didSet {
            titleLabel.text = homeTitle?.pageTitle
            if let select = homeTitle?.pageSelect, select {
                titleLabel.textColor = UIColor.red
                titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            }else{
                titleLabel.textColor = UIColor.black
                titleLabel.font = UIFont.systemFont(ofSize: 16)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

}

