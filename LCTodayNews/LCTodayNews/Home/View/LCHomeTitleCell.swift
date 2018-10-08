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
    
    var homeTitle: LCHomeNewsTitle? {
        didSet {
            titleLabel.text = homeTitle?.name
            if let select = homeTitle?.select {
                titleLabel.textColor = select ? UIColor.red : UIColor.black
            }else{
                titleLabel.textColor = UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

}

