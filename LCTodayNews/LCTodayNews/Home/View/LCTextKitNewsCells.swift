//
//  LCTextKitNewsCells.swift
//  LCTodayNews
//
//  Created by 罗超 on 2019/4/7.
//  Copyright © 2019 罗超. All rights reserved.
//

import UIKit
import CoreText

class LCTextKitNewsCells: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let context = UIGraphicsGetCurrentContext()
        
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
    }

    var news: LCHomeNewsDesc? {
        didSet {
            guard let news = news else {
                return
            }
            
            print(news.abstract)
        }
    }
    
}
