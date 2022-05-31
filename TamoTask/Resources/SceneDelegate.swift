//
//  SceneDelegate.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let windowScene = (scene as? UIWindowScene) {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window = self.window
            let token = Helper.getStringData(key: Constants.ttToken)
            if token.isEmpty{
                setupLoginVC()
            }else{
                setupDashboardVC()
            }
            
        }else{
            DLog("not getting window")
        }
    }
    
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        NetworkManager.shared.startMonitoring()
    }
    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        NetworkManager.shared.stopMonitoring()
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

