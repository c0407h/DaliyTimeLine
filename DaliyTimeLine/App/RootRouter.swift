//
//  RootRouter.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/14/24.
//

import Foundation
import UIKit

protocol RootWireframe: AnyObject {
    func setRootViewControllerToSplash(in window: UIWindow)
    func setRootViewControllerToMain(in window: UIWindow)
}


class RootRouter: RootWireframe {
    func setRootViewControllerToSplash(in window: UIWindow) {
        let splashVC = SplashRouter.createModule()
        let navController = UINavigationController(rootViewController: splashVC)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func setRootViewControllerToMain(in window: UIWindow) {
        let mainVC = MainTabbarRouter.createModule()
        let navController = UINavigationController(rootViewController: mainVC)
        window.rootViewController = navController
        window.makeKeyAndVisible()        
    }
}
