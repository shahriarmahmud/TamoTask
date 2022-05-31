//
//  NetworkManager.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import Foundation
import Reachability
import NotificationBannerSwift


class NetworkManager: NSObject {
    
    static let shared = NetworkManager()  // 2. Shared instance
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .unavailable
    }
    
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus = Reachability.Connection.unavailable
    
    // 5. Reachibility instance for Network status monitoring
    let reachability = try! Reachability()
    
    private var isDisplayingBanner = false
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        // to stop showing multiple banner at a short time (10 second)
        if isDisplayingBanner {
            return
        } else {
            isDisplayingBanner = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                self.isDisplayingBanner = false
            })
        }
        
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none, .unavailable:
            let banner = NotificationBanner(title: "No Internet Connection", subtitle: "swipe up to dismiss", style: .danger)
            banner.titleLabel?.textAlignment = .center
            banner.subtitleLabel?.textAlignment = .center
            banner.subtitleLabel?.font = UIFont.systemFont(ofSize: 12)
            banner.bannerHeight = 94
            banner.duration = 8
            banner.dismissOnSwipeUp = true
            banner.show()
        case .wifi:
            let banner = StatusBarNotificationBanner(title: "Wifi Network Available", style: .success)
            banner.duration = 3
            banner.show()
        case .cellular:
            let banner = StatusBarNotificationBanner(title: "Cellular Network Available", style: .success)
            banner.duration = 3
            banner.show()
        }
    }
    
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
}
