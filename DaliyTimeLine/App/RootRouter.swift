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
}


class RootRouter: RootWireframe {
    var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }
    
    func setRootViewControllerToSplash(in window: UIWindow) {
        let splashVC = SplashRouter.createModule()
        let navController = UINavigationController(rootViewController: splashVC)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}
