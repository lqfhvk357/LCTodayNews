//
//  LCNavBarAnimation.swift
//  LCPushNavBarAnimation
//
//  Created by 罗超 on 2018/12/18.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

let duration = 0.25


class LCNavBarAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationController.Operation
    
    
    init(with operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .push {
            let containerView = transitionContext.containerView
            let toVC = transitionContext.viewController(forKey: .to)!
            
            let toView = toVC.view
            containerView.addSubview(toView!)
            
            var navBar: LCFakeNavBar?
            if let searchVC = toVC as? LCSearchResultsViewController {
                navBar = searchVC.navBar
            }
            
            navBar?.readyPushAnim()
            
            UIView.animate(withDuration: duration, animations: {
                navBar?.pushAnim()
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        else {
            let containerView = transitionContext.containerView
            let fromVC = transitionContext.viewController(forKey: .from)!
            let toVC = transitionContext.viewController(forKey: .to)
            
            let toView = toVC?.view
            containerView.addSubview(toView!)
            
            let maskV = UIView(frame: toView!.frame)
            maskV.backgroundColor = UIColor.black
            maskV.alpha = 0.36
            containerView.addSubview(maskV)
            
            let fromView = fromVC.view
//            fromView?.layer.shadowRadius = 8
//            fromView?.layer.shadowColor = UIColor.green.cgColor
//            fromView?.layer.shadowOpacity = 0.6
            containerView.addSubview(fromView!)
            
            var navBar: LCFakeNavBar?
            if let searchVC = fromVC as? LCSearchResultsViewController {
                navBar = searchVC.navBar
                containerView.addSubview(navBar!)
            }

            navBar?.readyPopAnim()
            toView?.lc_x = -100
            fromView?.lc_x = 0
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                navBar?.popAnim()
                maskV.alpha = 0
                toView?.lc_x = 0
                fromView?.lc_x = ScreenWidth
                fromView?.layer.shadowOpacity = 0
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                maskV.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    navBar?.cancelPopAnim()
                    if let navBar = navBar {
                        fromView?.addSubview(navBar)
                    }
                }else{
                    navBar?.removeFromSuperview()
                }
            }
        }
        
    }

}
