//
//  RootTabBarController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/15/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the tabBar to be opaque.
        self.tabBar.translucent = false
        
        // set the default transition animation.
        self.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // if user is connected via WWAN, pop up a notification.
        if Utils.getMetworkStatus().value == ReachableViaWWAN.value{
            var options: [NSObject: AnyObject] = [
                kCRToastTextKey : "Using 3G/4G network ",
                kCRToastNotificationTypeKey: CRToastType.StatusBar.rawValue,
                kCRToastTimeIntervalKey: 0.8,
                kCRToastTextAlignmentKey : NSTextAlignment.Center.rawValue,
                kCRToastBackgroundColorKey : UIColor.redColor(),
                kCRToastAnimationInTypeKey : CRToastAnimationType.Gravity.rawValue,
                kCRToastAnimationOutTypeKey : CRToastAnimationType.Spring.rawValue,
                kCRToastAnimationInDirectionKey : CRToastAnimationDirection.Top.rawValue,
                kCRToastAnimationOutDirectionKey : CRToastAnimationDirection.Top.rawValue
            ]
            CRToastManager.showNotificationWithOptions(options, completionBlock: nil)
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // implement the delegate function, return a transition animation object.
        if let controllers = tabBarController.viewControllers as? [UIViewController] {
            let fromIndex = find(controllers, fromVC)!
            let toIndex = find(controllers, toVC)!
            if fromIndex < toIndex {
                return TransitionObjectForTabBar(moveRight: true, dist: abs(fromIndex - toIndex))
            } else {
                return TransitionObjectForTabBar(moveRight: false, dist: abs(fromIndex - toIndex))
            }
        }
        return TransitionObjectForTabBar(moveRight: true, dist: 1)
    }

}
