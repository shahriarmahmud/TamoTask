//
//  CMAppHelper.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import Foundation
import UIKit
import SwiftUI

func DLog<T>(_ object: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    let fileString = file as NSString
    let fileLastPathComponent = fileString.lastPathComponent as NSString
    let filename = fileLastPathComponent.deletingPathExtension
    print("\(filename).\(function)[\(line)]: \(object)\n", terminator: "")
    #endif
}

typealias DictString = [String:String]

struct RootVCHelper {
    
    static func setToDashboardVC() {
        let storyboard = UIStoryboard(storyboard: .dashboard)
        let vc = storyboard.instantiateViewController(withIdentifier: TTDashboardVC.self)
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
            keyWindow?.rootViewController = navigationController
            keyWindow?.makeKeyAndVisible()
        } else {
            let sb = UIStoryboard(storyboard: .dashboard)
            let vc = sb.instantiateViewController(withIdentifier: TTDashboardVC.self)
            
            let transition = CATransition()
            transition.type = CATransitionType.fade
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
            UIApplication.shared.keyWindow?.set(rootViewController: vc, withTransition: transition)
        }
    }
    
    static func setToLoginVC() {
        let storyboard = UIStoryboard(storyboard: .login)
        let vc = storyboard.instantiateViewController(withIdentifier: TTLoginVC.self)
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
            keyWindow?.rootViewController = navigationController
            keyWindow?.makeKeyAndVisible()
        } else {
            let sb = UIStoryboard(storyboard: .login)
            let vc = sb.instantiateViewController(withIdentifier: TTLoginVC.self)
            
            let transition = CATransition()
            transition.type = CATransitionType.fade
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
            UIApplication.shared.keyWindow?.set(rootViewController: vc, withTransition: transition)
        }
    }
    
    
}


