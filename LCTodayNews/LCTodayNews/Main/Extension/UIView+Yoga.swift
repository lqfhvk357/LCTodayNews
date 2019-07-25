//
//  UIView+Yoga.swift
//  LCTodayNews
//
//  Created by 罗超 on 2019/4/9.
//  Copyright © 2019 罗超. All rights reserved.
//

import Foundation
import YogaKit

extension UIView {
    func yogaLayout() {
        self.yoga.display = .none
        self.yoga.display = .flex
    }
}
