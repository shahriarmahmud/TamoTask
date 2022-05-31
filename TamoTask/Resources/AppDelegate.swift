//
//  AppDelegate.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupProgressAndKeyboard()
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            self.window?.makeKeyAndVisible()
            let token = Helper.getStringData(key: Constants.ttToken)
            if token.isEmpty{
                setupLoginVC()
            }else{
                setupDashboardVC()
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NetworkManager.shared.stopMonitoring()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NetworkManager.shared.startMonitoring()
    }
    
    private func setupProgressAndKeyboard() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setMinimumDismissTimeInterval(0.3)
        SVProgressHUD.setMaximumDismissTimeInterval(3)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }
    
    private func setupLoginVC(){
        let sb = UIStoryboard(storyboard: .login)
        let vc = sb.instantiateViewController(withIdentifier: TTLoginVC.self)
        let navigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    private func setupDashboardVC(){
        let sb = UIStoryboard(storyboard: .dashboard)
        let vc = sb.instantiateViewController(withIdentifier: TTDashboardVC.self)
        let navigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }


}

