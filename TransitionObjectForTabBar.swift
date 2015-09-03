//
//  TransitionAnimationForTabBar.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 15/7/22.
//  Copyright (c) 2015年 Dingkang Wang. All rights reserved.
//

import Foundation
import UIKit


//  Transition animation between tabViews
class TransitionObjectForTabBar: NSObject, UIViewControllerAnimatedTransitioning {
    
    var moveRight: Bool
    
    var dist: CGFloat
    
    init(moveRight: Bool, dist: Int) {
        self.moveRight = moveRight
        self.dist = CGFloat(dist)
        super.init()
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Get the "from" and "to" views
        let fromView : UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView : UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        transitionContext.containerView().addSubview(fromView)
        transitionContext.containerView().addSubview(toView)
        transitionContext.containerView().backgroundColor = UIColor.whiteColor()
        
        //Slide in slide out effect.
        if moveRight {
            toView.frame = CGRectMake(dist * toView.frame.width, 0, toView.frame.width, toView.frame.height)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                toView.frame = CGRectMake(0, 0, toView.frame.width, toView.frame.height)
                fromView.frame = CGRectMake(-self.dist * fromView.frame.width, 0, fromView.frame.width, fromView.frame.height)
                }) { (Bool) -> Void in
                    // update internal view - must always be called
                    transitionContext.completeTransition(true)
            }
        } else {
            toView.frame = CGRectMake(-dist * toView.frame.width, 0, toView.frame.width, toView.frame.height)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                toView.frame = CGRectMake(0, 0, toView.frame.width, toView.frame.height)
                fromView.frame = CGRectMake(self.dist * fromView.frame.width, 0, fromView.frame.width, fromView.frame.height)
                }) { (Bool) -> Void in
                    // update internal view - must always be called
                    transitionContext.completeTransition(true)
            }
        }
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.35
    }
}