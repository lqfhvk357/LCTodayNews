//
//  LCNavigationController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/29.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

class LCNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    override var shouldAutorotate: Bool {return false}
    
    var isActive = false
    var interactive = UIPercentDrivenInteractiveTransition()
    var screenEdgePanGR: UIScreenEdgePanGestureRecognizer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor.navbarBarTint

        self.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "lefterbackicon_titlebar_24x24_"), style: .plain, target: self, action: #selector(navigationBack))
        }
        
        super.pushViewController(viewController, animated: true)
        
    }
    

    //MARK: - GR
    @objc func panHandle(panGR: UIScreenEdgePanGestureRecognizer) {
        
        let x = CGFloat.maximum(0, panGR.translation(in: panGR.view).x)
        let percentComlete = x / ScreenWidth
        
        switch panGR.state {
        case .began:
            isActive =  true
            interactive.completionCurve = .linear;
            self.popViewController(animated: true)
        case .changed:
            interactive.update(percentComlete)
        case .cancelled, .ended:
            if percentComlete > 0.5 {
                interactive.finish()
            }else {
                interactive.cancel()
            }
            isActive = false
        default:
            isActive = false
        }
    }


}

extension LCNavigationController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool){
        if viewController.isKind(of: LCSearchResultsViewController.self) {
            let screenEdgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panHandle))
            screenEdgePanGR.edges = .left
            viewController.view.addGestureRecognizer(screenEdgePanGR)
            self.screenEdgePanGR = screenEdgePanGR
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isActive {
            return interactive
        }
        return nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push, toVC.isKind(of: LCSearchResultsViewController.self) {
            return LCNavBarAnimation(with: operation)
        }
        if operation == .pop, fromVC.isKind(of: LCSearchResultsViewController.self){
            return LCNavBarAnimation(with: operation)
        }
        
        if operation == .push, toVC.isKind(of: LCSmallVideoPlayViewController.self) {
            return AnimationController(with: .push)
        }
        
        if operation == .pop, fromVC.isKind(of: LCSmallVideoPlayViewController.self) {
            return AnimationController(with: .pop)
        }

        
        return nil
    }
}

extension LCNavigationController: UIGestureRecognizerDelegate {
    
}
