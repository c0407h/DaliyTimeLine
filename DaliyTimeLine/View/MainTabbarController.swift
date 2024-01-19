//
//  MainTabbarController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func configureTabbar() {
        let mainListController = MainListViewController()
        
        let profileController = ProfileViewController()
        
        viewControllers = [mainListController, profileController]
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
    }
    
    func configureUI() {
        self.delegate = self
    }
}


extension MainTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            
            return false
        }
        return true
    }
}
