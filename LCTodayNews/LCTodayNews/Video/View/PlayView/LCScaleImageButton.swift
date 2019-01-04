//
//  LCScaleImageButton.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/28.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

class LCScaleImageButton: UIButton {

    var scale: CGFloat = 0.6
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let width = contentRect.width * scale
        let height = contentRect.height * scale
        let x = (contentRect.width - width) * 0.5
        let y = (contentRect.height - height) * 0.5
        
        return CGRect(x: x, y: y, width: width, height: height)

    }
}
