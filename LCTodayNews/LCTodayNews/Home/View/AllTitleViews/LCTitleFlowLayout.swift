//
//  LCTitleFlowLayout.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/22.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

class LCTitleFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?  {
        let attrs = super.layoutAttributesForElements(in: rect)
        return attrs?.filter{ $0.representedElementCategory != .cell || $0.indexPath != IndexPath(row: 0, section: 0) }
    }
    
}
