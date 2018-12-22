//
//  LCKeyWordCell.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/21.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

class LCKeyWordCell: UICollectionViewCell {
    
    var keyWord: String? {
        didSet {
            keyWordL.text = keyWord
        }
    }
    

    @IBOutlet weak var keyWordL: UILabel!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
