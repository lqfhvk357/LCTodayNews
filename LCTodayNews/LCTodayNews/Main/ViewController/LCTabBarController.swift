//
//  LCTabBarController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/20.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit


class LCTabBarController: UITabBarController {

    let noVC = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBar.appearance()
        appearance.tintColor = UIColor.tarbarTint
        appearance.barTintColor = UIColor.white
        self.delegate = self
        
        var imageNames = ["home", "video", "send_tt", "huoshan", ]
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
            case "send_tt":
                viewController = noVC
                title = "发头条"
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

extension LCTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == noVC  {
            let sendView = LCSendView.lc_loadForBundle()
            self.view.addSubview(sendView)
            sendView.frame = self.view.bounds
            sendView.show()
            return false
        }else{
            return true
        }
    }
}


