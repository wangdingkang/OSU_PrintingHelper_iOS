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
        
        // Do any additional setup after loading the view.
        self.tabBar.translucent = false
        self.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        switch InternetConnectionUtility.getMetworkStatus().value {
        case 0:
            // processed by info.plist using UIRequiresPersistentWiFi
            break
            
        case ReachableViaWiFi.value:
            //JLToast.makeText("Using wifi network", duration: JLToastDelay.ShortDelay).show()
            // nothing to do
//            var options: [NSObject: AnyObject] = [
//                kCRToastTextKey : "WiFi",
//                kCRToastNotificationTypeKey: CRToastType.StatusBar.rawValue,
//                kCRToastTimeIntervalKey: 0.6,
//                kCRToastTextAlignmentKey : NSTextAlignment.Center.rawValue,
//                kCRToastBackgroundColorKey : UIColor.redColor(),
//                kCRToastAnimationInTypeKey : CRToastAnimationType.Gravity.rawValue,
//                kCRToastAnimationOutTypeKey : CRToastAnimationType.Spring.rawValue,
//                kCRToastAnimationInDirectionKey : CRToastAnimationDirection.Top.rawValue,
//                kCRToastAnimationOutDirectionKey : CRToastAnimationDirection.Top.rawValue
//            ]
//            CRToastManager.showNotificationWithOptions(options, completionBlock: nil)
            break
            
        case ReachableViaWWAN.value:
            // show a prompt message
            //JLToast.makeText("Using 3G/4G network", duration: JLToastDelay.ShortDelay).show()
            
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

        default:
            //JLToast.makeText("What the fuck!?", duration: JLToastDelay.ShortDelay).show()
            break
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionObjectForTabBar()
    }
    
//    func showRetryAlert(errorMessage: String, retryFunction: UIAlertAction! -> Void) {
//        let retryMenu = UIAlertController(
//            title: "Alert",
//            message: errorMessage,
//            preferredStyle: UIAlertControllerStyle.Alert
//        )
//        
//        retryMenu.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler:
//            retryFunction))
//        
//        retryMenu.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
//        
//        presentViewController(retryMenu, animated: true, completion: nil)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
