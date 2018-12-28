//
//  AnimationController.swift
//  AVPlayerDome
//
//  Created by 罗超 on 2018/11/27.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

class AnimationController: NSObject,  UIViewControllerAnimatedTransitioning{
    init(with operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    
    var operation: UINavigationController.Operation
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .push {
            let fromVC = transitionContext.viewController(forKey: .from) 
            let toVC = transitionContext.viewController(forKey: .to) as! LCSmallVideoPlayViewController
            
            let containerView = transitionContext.containerView
            let fromView = fromVC?.view
            containerView.addSubview(fromView!)
            let toView = toVC.view
            containerView.addSubview(toView!)
            toVC.animView.frame = toVC.beginFrame!
            
            
            UIView.animate(withDuration: 0.2, animations: {
                let width = UIScreen.main.bounds.width
                let height = UIScreen.main.bounds.height
                toVC.animView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
            }) {
                transitionContext.completeTransition($0)
            }
        }else if operation == .pop{
            let fromVC = transitionContext.viewController(forKey: .from) as! LCSmallVideoPlayViewController
            let toVC = transitionContext.viewController(forKey: .to)
            
            let containerView = transitionContext.containerView
            let toView = toVC?.view
            containerView.addSubview(toView!)
//            containerView.addSubview(fromVC.fakeWindow!)
            
            let animView = UIImageView(image: fromVC.animView.image)
            animView.backgroundColor = .black
            animView.contentMode = .scaleAspectFit
            animView.frame = fromVC.view.frame
            containerView.addSubview(animView)
            
            
            containerView.addSubview(fromVC.fakeNavBar!)
            fromVC.fakeNavBar!.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: NavBarHeight)
            
            containerView.addSubview(fromVC.fakeTabBar!)
            fromVC.fakeTabBar!.frame = CGRect(x: 0, y: ScreenHeight-TabBarHeight, width: ScreenWidth, height: TabBarHeight)
            
            UIView.animate(withDuration: 0.2, animations: {
                animView.frame = fromVC.beginFrame!
            }) {
                transitionContext.completeTransition($0)
                if $0 {
                    animView.removeFromSuperview()
                    
//                    toVC.tabBarController?.tabBar.isHidden = false
                    fromVC.fakeNavBar?.removeFromSuperview()
                    fromVC.fakeTabBar?.removeFromSuperview()
//                    fromVC.fakeWindow?.removeFromSuperview()
                }
            }
            
        }
        

        
    }
    
    
}
