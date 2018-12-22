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
        appearance.tintColor = UIColor.tarbarTint
        appearance.barTintColor = UIColor.white
        
        var imageNames = ["home", "video", "huoshan", ]
        UserDefaults.standard.bool(forKey: "login") ? imageNames.append("mine") : imageNames.append("no_login")
        
        for imageName in imageNames {
            var viewController: UIViewController
            var title: String = ""
            
            switch imageName {
            case "home":
                viewController = LCHomeViewController()
                title = "首页"
            case "video":
                viewController = LCVideoViewController()
                title = "西瓜视频"
            case "huoshan":
                viewController = LCSmallVideoViewController()
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
//        let nav = LCNavigationController.init(rootViewController: viewController)
        self.addChildViewController(viewController)
    }
}

extension UITabBarItem {
    convenience init(_ title:String, _ imageName: String) {
        self.init(title: title, image: UIImage(named: "\(imageName)_tabbar")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "\(imageName)_tabbar_press")?.withRenderingMode(.alwaysOriginal))
    }
}


