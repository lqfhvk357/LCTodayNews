//
//  FuckCrash.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/8.
//  Copyright © 2018年 罗超. All rights reserved.
//

import Foundation
import UIKit

protocol FuckCrash {}

extension FuckCrash {
    func deadlock() -> Void {
        DispatchQueue.main.async {}
    }
}
