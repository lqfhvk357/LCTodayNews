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
            let fromVC = transitionContext.viewController(forKey: .from) as! LCSmallVideoViewController
            let toVC = transitionContext.viewController(forKey: .to) as! LCSmallVideoPlayViewController
            
            let containerView = transitionContext.containerView
            let toView = toVC.view
            containerView.addSubview(toView!)
            
            let animView = UIImageView(image: fromVC.animView.image)
            animView.backgroundColor = .black
            animView.contentMode = .scaleAspectFit
            containerView.addSubview(animView)
            animView.frame = fromVC.beginFrame!
            
            UIView.animate(withDuration: 0.2, animations: {
                let width = UIScreen.main.bounds.width
//                if #available(iOS 11.0, *) {
//                    let height = toView!.safeAreaLayoutGuide.layoutFrame.height
//                    animView!.frame = CGRect.init(x: 0, y: toView!.safeAreaLayoutGuide.layoutFrame.minY, width: width, height: height)
//                } else {
                    let height = UIScreen.main.bounds.height
                animView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
//                }
            }) {
                transitionContext.completeTransition($0)
                if $0 {
                    toVC.animView.image = animView.image
                    animView.removeFromSuperview()
                }
            }
        }else if operation == .pop{
            let fromVC = transitionContext.viewController(forKey: .from) as! LCSmallVideoPlayViewController
            let toVC = transitionContext.viewController(forKey: .to) as! LCSmallVideoViewController
            
            let containerView = transitionContext.containerView
            let toView = toVC.view
            containerView.addSubview(toView!)

            let animView = UIImageView(image: fromVC.animView.image)
            animView.backgroundColor = .black
            animView.contentMode = .scaleAspectFit
            animView.frame = fromVC.view.frame
            containerView.addSubview(animView)
            
            toVC.tabBarController?.tabBar.isHidden = true
            
            UIView.animate(withDuration: 0.2, animations: {
                animView.frame = toVC.beginFrame!
            }) {
                transitionContext.completeTransition($0)
                if $0 {
                    animView.removeFromSuperview()
                    toVC.tabBarController?.tabBar.isHidden = false
                }
            }
            
        }
        

        
    }
    
    
}
