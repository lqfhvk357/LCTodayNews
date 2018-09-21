//
//  LCTabBarController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/20.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

class LCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBar.appearance()
        appearance.tintColor = UIColor(0xf55a5d)
        appearance.barTintColor = UIColor.white
        
        var imageNames = ["home", "video", "weitoutiao", "huoshan", ]
        UserDefaults.standard.bool(forKey: "login") ? imageNames.append("mine") : imageNames.append("no_login")
        
        for imageName in imageNames {
            var viewController: UIViewController
            var title: String = ""
            
            switch imageName {
            case "home":
                viewController = UIViewController()
                title = "首页"
            case "video":
                viewController = UIViewController()
                title = "西瓜视频"
            case "weitoutiao":
                viewController = UIViewController()
                title = "微头条"
            case "huoshan":
                viewController = UIViewController()
                title = "小视频"
            case "no_login":
                viewController = UIViewController()
                title = "未登录"
            case "mine":
                viewController = UIViewController()
                title = "我的"
            default:
                viewController = UIViewController()
            }
            
            let item = UITabBarItem.init(title, imageName)
            self.addChildViewController(viewController, withTabBarItem: item)
        }
    }
    
    func addChildViewController(_ viewController: UIViewController, withTabBarItem item: UITabBarItem) -> () {
        viewController.tabBarItem = item
        self.addChildViewController(viewController)
    }
}

extension UITabBarItem {
    convenience init(_ title:String, _ imageName: String) {
        self.init(title: title, image: UIImage(named: "\(imageName)_tabbar")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "\(imageName)_tabbar_press")?.withRenderingMode(.alwaysOriginal))
    }
}


