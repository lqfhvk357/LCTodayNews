//
//  LCNavBarAnimation.swift
//  LCPushNavBarAnimation
//
//  Created by 罗超 on 2018/12/18.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

class LCNavBarAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationController.Operation
    
    
    init(with operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .push {
            let containerView = transitionContext.containerView
            let toVC = transitionContext.viewController(forKey: .to) as! LCSearchResultsViewController
            let toView = toVC.view
            containerView.addSubview(toView!)
            let navBar = toVC.navBar
//            let fromVC = transitionContext.viewController(forKey: .from) as! LCHomeViewController
            
            
            navBar.layoutIfNeeded()
            navBar.whiteViewLeading.constant = 45
            navBar.whiteViewTrailing.constant = 58
            UIView.animate(withDuration: 0.3, animations: {
                navBar.searchBtn.alpha = 1
                navBar.searchTF.alpha = 1
                navBar.arrowBtn.alpha = 1
                
                navBar.tipsL.alpha = 0
                navBar.hotBtn.alpha = 0
                navBar.updateConstraints()
                navBar.layoutIfNeeded()
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        else {
            let containerView = transitionContext.containerView
            let fromVC = transitionContext.viewController(forKey: .from) as! LCSearchResultsViewController
            let toVC = transitionContext.viewController(forKey: .to)
            let toView = toVC?.view
            containerView.addSubview(toView!)
            
            let maskV = UIView(frame: toView!.frame)
            maskV.backgroundColor = UIColor.black
            maskV.alpha = 0.36
            containerView.addSubview(maskV)
            
            let fromView = fromVC.view
            containerView.addSubview(fromView!)
            let navBar = fromVC.navBar
            containerView.addSubview(navBar)

            
            navBar.layoutIfNeeded()
            navBar.whiteViewLeading.constant = 15
            navBar.whiteViewTrailing.constant = 15
            toView?.x = -100
            fromView?.x = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                navBar.searchBtn.alpha = 0
                navBar.searchTF.alpha = 0
                navBar.arrowBtn.alpha = 0

                navBar.tipsL.alpha = 1
                navBar.hotBtn.alpha = 1
                
                maskV.alpha = 0
                toView?.x = 0
                fromView?.x = ScreenWidth
                navBar.updateConstraints()
                navBar.layoutIfNeeded()
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                maskV.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    navBar.whiteViewLeading.constant = 45
                    navBar.whiteViewTrailing.constant = 58
                    fromView?.addSubview(navBar)
                }else{
//                    toVC.tabBarController?.tabBar.isHidden = false
                    navBar.removeFromSuperview()
                }
            }
        }

        
    }
    

}
