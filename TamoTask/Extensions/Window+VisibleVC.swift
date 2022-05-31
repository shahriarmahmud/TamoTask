//
//  Window+VisibleVC.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 1/13/21.
//  Copyright © 2021 Shahriar Mahmud. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
            
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(_ vc:UIViewController) -> UIViewController {
        
        var nextOnStackViewController: UIViewController? = nil
        if let presented = vc.presentedViewController {
            nextOnStackViewController = presented
        } else if let navigationController = vc as? UINavigationController,
            let visible = navigationController.visibleViewController {
            nextOnStackViewController = visible
        } else if let tabBarController = vc as? UITabBarController,
            let visible = (tabBarController.selectedViewController ??
                tabBarController.presentedViewController) {
            nextOnStackViewController = visible
        }
        
        if let nextOnStackViewController = nextOnStackViewController {
            return getVisibleViewControllerFrom(nextOnStackViewController)
        } else {
            return vc
        }
    }
    
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        rootViewController = newRootViewController

        // Update status bar appearance using the new view controllers appearance - animate if needed
        
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view cont  rollers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
    
}
