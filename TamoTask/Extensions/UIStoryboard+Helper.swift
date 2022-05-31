//
//  UIStoryboard+Customization.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 1/13/21.
//  Copyright © 2021 Shahriar Mahmud. All rights reserved.
//


import UIKit

extension UIStoryboard {
    
    /// The uniform place where we state all the storyboard we have in our application
    enum Storyboard: String {
        case login      = "Login"
        case dashboard  = "Main"
        case commonWeb  = "CommonWeb"
    }
    
    // MARK: - Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    // MARK: - Class Functions
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    // MARK: - View Controller Instantiation from Generics
    func instantiateViewController<T>(withIdentifier identifier: T.Type) -> T where T: StoryboardIdentifiable {
        let className = String(describing: identifier)
        weak var weakSelf = self
        guard let vc =  weakSelf?.instantiateViewController(withIdentifier: className) as? T else {
            fatalError("Cannot find controller with identifier \(className)")
        }
        return vc
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController : StoryboardIdentifiable { }

